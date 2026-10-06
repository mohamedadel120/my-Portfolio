import 'dart:convert';

import 'package:jaspr/server.dart';
import 'package:jaspr_site/constants/projects_variant.dart';
import 'package:jaspr_site/main.server.options.dart';
import 'package:jaspr_site/sections/projects_section.dart';
import 'package:test/test.dart';

Map<String, dynamic> project(int i, {bool full = true}) => {
  'title': 'App $i',
  'description': 'Description of app $i',
  'tech': ['Flutter', 'Bloc'],
  'color': 0xFF00D9FF,
  'downloads': '',
  'galleryImages': full ? ['https://img.test/$i-1.webp', 'https://img.test/$i-2.webp'] : null,
  'androidStoreUrl': full ? 'https://play.google.com/store/apps/details?id=app$i' : null,
  'iosStoreUrl': full ? 'https://apps.apple.com/app/id$i' : null,
  'videoUrl': null,
  if (full && i == 1) 'role': 'Lead developer',
};

Future<String> render(ProjectsVariant variant, List<Map<String, dynamic>> projects) async {
  final result = await renderComponent(ProjectsSection.showcase(variant, projects), standalone: true);
  // Standalone output prepends the components' CSS in <head>; assertions are
  // about the rendered markup only.
  return utf8.decode(result.body).split('</head>').last;
}

void main() {
  setUpAll(() => Jaspr.initializeApp(options: defaultServerOptions));

  final all = [for (var i = 1; i <= 3; i++) project(i)];

  group('every variant renders real content', () {
    for (final variant in ProjectsVariant.values) {
      test('$variant', () async {
        final html = await render(variant, all);
        expect(html, contains('App 1'));
        expect(html, isNot(contains('Instance of')));
      });
    }
  });

  group('case study (V2-A)', () {
    test('has all projects, links and screenshots in the HTML', () async {
      final html = await render(ProjectsVariant.caseStudy, all);
      for (var i = 1; i <= 3; i++) {
        expect(html, contains('App $i'));
        expect(html, contains('Description of app $i'));
        expect(html, contains('play.google.com/store/apps/details?id=app$i'));
        expect(html, contains('https://img.test/$i-1.webp'));
      }
      expect(RegExp('<article').allMatches(html), hasLength(3));
      expect(html, contains('href="#contact"'));
    });

    test('screenshots have alt text and only the first one is eager', () async {
      final html = await render(ProjectsVariant.caseStudy, all);
      expect(html, contains('alt="App 1 screenshot 1 of 2"'));
      expect(RegExp('loading="eager"').allMatches(html), hasLength(1));
      expect(html, isNot(contains('alt=""')));
    });

    test('external links are safe', () async {
      final html = await render(ProjectsVariant.caseStudy, all);
      expect(html, contains('rel="noopener"'));
      expect(html, contains('target="_blank"'));
    });

    test('owner-written case study copy shows only when present', () async {
      final html = await render(ProjectsVariant.caseStudy, all);
      expect(html, contains('Lead developer'));
      expect(RegExp('My role').allMatches(html), hasLength(1));
      expect(html, isNot(contains('The problem')));
    });

    test('a project with no media and no store links degrades cleanly', () async {
      final html = await render(ProjectsVariant.caseStudy, [project(9, full: false)]);
      expect(html, contains('App 9'));
      expect(html, contains('Coming soon'));
      expect(html, isNot(contains('cs-shots')));
    });

    test('empty list renders nothing harmful', () async {
      final html = await render(ProjectsVariant.caseStudy, const []);
      expect(html, isNot(contains('<article')));
    });
  });

  group('index + detail (V2-B)', () {
    test('server HTML contains every project and marks only the first current', () async {
      final html = await render(ProjectsVariant.indexDetail, all);
      for (var i = 1; i <= 3; i++) {
        expect(html, contains('Description of app $i'));
      }
      expect(RegExp(r'id="idx-panel-\d"').allMatches(html), hasLength(3));
      expect(RegExp(r'aria-current="true"').allMatches(html).length, greaterThanOrEqualTo(1));
      expect(RegExp(r'hidden').allMatches(html).length, greaterThanOrEqualTo(2));
    });

    test('empty list renders nothing harmful', () async {
      final html = await render(ProjectsVariant.indexDetail, const []);
      expect(html, isNot(contains('idx-panel')));
    });
  });

  group('refined sticky (V2-C)', () {
    test('adds the contact call to action and region label; v1 does not', () async {
      final refined = await render(ProjectsVariant.refinedSticky, all);
      final v1 = await render(ProjectsVariant.v1, all);
      expect(refined, contains('Build something like this'));
      expect(refined, contains('aria-label="Project showcase"'));
      expect(v1, isNot(contains('Build something like this')));
      expect(v1, isNot(contains('aria-label="Project showcase"')));
    });

    test('shorter scroll than the original', () async {
      int height(String html) =>
          int.parse(RegExp(r'height:\s*(\d+)').firstMatch(html)!.group(1)!);
      final refined = height(await render(ProjectsVariant.refinedSticky, all));
      final v1 = height(await render(ProjectsVariant.v1, all));
      expect(refined, lessThan(v1));
    });
  });

  test('production default is the original design', () {
    expect(projectsVariant, ProjectsVariant.v1);
  });
}
