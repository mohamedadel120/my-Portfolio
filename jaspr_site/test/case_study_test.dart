import 'dart:convert';

import 'package:jaspr/server.dart';
import 'package:jaspr_site/components/project_view.dart';
import 'package:jaspr_site/constants/projects_variant.dart';
import 'package:jaspr_site/data/project_slug.dart';
import 'package:jaspr_site/main.server.options.dart';
import 'package:jaspr_site/pages/project_case_study.dart';
import 'package:jaspr_site/sections/projects_section.dart';
import 'package:test/test.dart';

Map<String, dynamic> project(String title, {Map<String, dynamic> extra = const {}}) => {
  'title': title,
  'description': 'What $title does.',
  'tech': ['Flutter', 'Bloc'],
  'color': 0xFFFBBF24,
  'downloads': '10,000+',
  'galleryImages': ['https://img.test/$title-1.webp', 'https://img.test/$title-2.webp'],
  'androidStoreUrl': 'https://play.google.com/store/apps/details?id=x',
  'iosStoreUrl': null,
  'videoUrl': null,
  'slug': projectSlug(title),
  ...extra,
};

Future<String> renderPage(Map<String, dynamic> p, {Map<String, dynamic>? previous, Map<String, dynamic>? next}) async {
  final result = await renderComponent(ProjectCaseStudy(project: p, previous: previous, next: next), standalone: true);
  return utf8.decode(result.body);
}

/// The page body only: no <head>, no hydration data comments.
String body(String html) => html.split('</head>').last.replaceAll(RegExp(r'<!--@[\s\S]*?-->'), '');

void main() {
  setUpAll(() => Jaspr.initializeApp(options: defaultServerOptions));

  group('slugs', () {
    test('made from the title, without "mobile app" or punctuation', () {
      expect(projectSlug('Gomla Mobile App'), 'gomla');
      expect(projectSlug('DrugZa - TagPharma'), 'drugza-tagpharma');
      expect(projectSlug('to-let'), 'to-let');
      expect(projectSlug('  ureva  '), 'ureva');
    });

    test('a title with nothing usable still gets an address', () {
      expect(projectSlug('جملة'), 'project');
      expect(projectSlug(''), 'project');
    });

    test('every project gets a unique slug; the owner\'s own one wins', () {
      final slugs = withSlugs([
        {'title': 'Stock'},
        {'title': 'Stock Mobile App'},
        {'title': 'Gomla', 'slug': ' Gomla Beauty '},
        {'title': 'جملة'},
        {'title': 'عربي'},
      ]).map((p) => p['slug']).toList();
      expect(slugs, ['stock', 'stock-2', 'gomla-beauty', 'project', 'project-2']);
    });

    test('the showcase and the pages read the same slugs', () {
      final view = ProjectView.fromMap(project('Gomla Mobile App'));
      expect(view.caseStudyPath, '/projects/gomla');
      expect(ProjectView.fromMap({'title': 'No slug'}).caseStudyPath, isNull);
    });
  });

  group('case study page', () {
    test('title, story and links for a project with a written problem', () async {
      final html = await renderPage(project('Gomla Mobile App', extra: {
        'problem': 'Buying beauty products meant going to a store.',
        'highlight': 'AI reads your skin.',
        'featured': true,
      }));
      final page = body(html);
      expect(page, contains('<h1 class="cs-title">Gomla Mobile App</h1>'));
      expect(page, contains('The problem'));
      expect(page, contains('Buying beauty products meant going to a store.'));
      // With a problem above it, the description is the answer to it.
      expect(page, contains('The solution'));
      expect(page, isNot(contains('>Overview<')));
      expect(page, contains('Featured project'));
      expect(page, contains('href="/projects"'));
      expect(page, contains('href="/#contact"'));
      expect(RegExp('<!--@').allMatches(html.split('</head>').last), hasLength(1), reason: 'only the gallery is interactive');
    });

    test('parts the owner has not written are left out, never filled in', () async {
      final page = body(await renderPage(project('Stock')));
      expect(page, contains('Overview'));
      for (final missing in ['The problem', 'My role', 'The outcome', 'The solution', 'Featured project']) {
        expect(page, isNot(contains(missing)), reason: missing);
      }
    });

    test('role and outcome appear once written', () async {
      final page = body(await renderPage(project('Stock', extra: {'role': 'Lead developer', 'outcome': 'Shipped on both stores.'})));
      expect(page, contains('My role'));
      expect(page, contains('Lead developer'));
      expect(page, contains('The outcome'));
    });

    test('a download count is labelled as one; a status is not', () async {
      expect(body(await renderPage(project('A'))), contains('Downloads'));
      final soon = body(await renderPage(project('B', extra: {'downloads': 'Coming Soon'})));
      expect(soon, contains('Status'));
      expect(soon, isNot(contains('Downloads')));
      final none = body(await renderPage(project('C', extra: {'downloads': '', 'androidStoreUrl': null})));
      expect(none, isNot(contains('cs-facts')));
    });

    test('previous and next projects link to their pages', () async {
      final page = body(await renderPage(project('Gomla'), previous: project('DrugZa - TagPharma'), next: project('Stock')));
      expect(page, contains('href="/projects/drugza-tagpharma"'));
      expect(page, contains('href="/projects/stock"'));
    });

    test('with two projects the other one is offered once, not twice', () async {
      final other = project('Stock');
      final page = body(await renderPage(project('Gomla'), previous: other, next: other));
      expect(RegExp('href="/projects/stock"').allMatches(page), hasLength(1));
    });

    test('a single project has no "more projects" block', () async {
      expect(body(await renderPage(project('Gomla'))), isNot(contains('cs-more')));
    });

    test('no screenshots: no gallery, and a video when there is one', () async {
      final html = await renderPage(project('DrugZa', extra: {'galleryImages': null, 'videoUrl': 'assets/videos/demo.mp4'}));
      expect(body(html), isNot(contains('class="gal"')));
      expect(body(html), contains('src="/assets/videos/demo.mp4#t=0.1"'));
      expect(RegExp('<!--@').allMatches(html.split('</head>').last), isEmpty);
    });

    test('search description: the highlight, else the description cut at a word', () {
      expect(ProjectCaseStudy.pageDescription(ProjectView.fromMap(project('A', extra: {'highlight': 'Short claim.'}))), 'Short claim.');
      final long = ProjectView.fromMap(project('B', extra: {'description': List.filled(60, 'word').join(' ')}));
      final description = ProjectCaseStudy.pageDescription(long);
      expect(description.length, lessThanOrEqualTo(160));
      expect(description, endsWith('word...'));
    });
  });

  test('every project in the showcase links to its case study', () async {
    final projects = withSlugs([project('Gomla Mobile App'), project('Stock Mobile App')]);
    final result = await renderComponent(ProjectsSection.showcase(ProjectsVariant.pinnedShowcase, projects), standalone: true);
    final html = body(utf8.decode(result.body));
    expect(html, contains('href="/projects/gomla"'));
    expect(html, contains('href="/projects/stock"'));
    // The visible words start the accessible name (voice control).
    expect(html, contains('aria-label="Read the case study: Gomla Mobile App"'));
  });
}
