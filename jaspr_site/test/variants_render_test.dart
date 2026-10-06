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

    test('screenshots have alt text; only the first two of the first project are eager', () async {
      final html = await render(ProjectsVariant.caseStudy, all);
      expect(html, contains('alt="App 1 screenshot 1 of 2"'));
      expect(RegExp('loading="eager"').allMatches(html), hasLength(2));
      expect(html, isNot(contains('alt=""')));
    });

    test('gallery has controls, dots and a counter for several screenshots', () async {
      final html = await render(ProjectsVariant.caseStudy, all);
      expect(html, contains('aria-label="Next screenshot"'));
      expect(html, contains('aria-label="Previous screenshot"'));
      expect(html, contains('1 / 2'));
      expect(RegExp('class="gal-dot"').allMatches(html), hasLength(6));
      expect(html, contains('aria-roledescription="carousel"'));
    });

    test('many screenshots use a scrubbable progress bar instead of wrapping dots', () async {
      final many = project(5)..['galleryImages'] = [for (var j = 0; j < 24; j++) 'https://img.test/m-$j.webp'];
      final html = await render(ProjectsVariant.caseStudy, [many]);
      expect(html, contains('type="range"'));
      expect(html, contains('max="23"'));
      expect(html, contains('1 / 24'));
      expect(html, isNot(contains('class="gal-dot"')));
    });

    test('up to eight screenshots keep the dots', () async {
      final eight = project(5)..['galleryImages'] = [for (var j = 0; j < 8; j++) 'https://img.test/e-$j.webp'];
      final html = await render(ProjectsVariant.caseStudy, [eight]);
      expect(RegExp('class="gal-dot"').allMatches(html), hasLength(8));
      expect(html, isNot(contains('type="range"')));
    });

    test('a single screenshot shows no browsing controls', () async {
      final one = project(7)..['galleryImages'] = ['https://img.test/only.webp'];
      final html = await render(ProjectsVariant.caseStudy, [one]);
      expect(html, contains('https://img.test/only.webp'));
      expect(html, isNot(contains('Next screenshot')));
      expect(html, isNot(contains('gal-dot')));
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
      expect(html, isNot(contains('gal-track')));
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

  group('stage showcase (V2-D)', () {
    test('every project is a complete section in the HTML', () async {
      final html = await render(ProjectsVariant.stageShowcase, all);
      for (var i = 1; i <= 3; i++) {
        expect(html, contains('id="sd-slot-${i - 1}"'));
        expect(html, contains('Description of app $i'));
        expect(html, contains('play.google.com/store/apps/details?id=app$i'));
        expect(html, contains('https://img.test/$i-1.webp'));
      }
      expect(RegExp('class="sd-slot"').allMatches(html), hasLength(3));
    });

    test('has a way past the section, a counter and project navigation', () async {
      final html = await render(ProjectsVariant.stageShowcase, all);
      expect(html, contains('href="#contact"'));
      expect(html, contains('Skip to contact'));
      expect(html, contains('Project 1 / 3'));
      expect(RegExp('class="sd-nav-item"').allMatches(html), hasLength(3));
    });

    test('screenshots are browsed with the gallery, not by scrolling', () async {
      final html = await render(ProjectsVariant.stageShowcase, all);
      expect(RegExp('aria-roledescription="carousel"').allMatches(html), hasLength(3));
    });

    test('is far shorter than the original scroll showcase', () async {
      // 8 projects x 8 screenshots: the original needs 1400 + 8 x 800 px each.
      final many = [for (var i = 1; i <= 8; i++) project(i)..['galleryImages'] = [for (var j = 0; j < 8; j++) 'https://img.test/$i-$j.webp']];
      final stage = await render(ProjectsVariant.stageShowcase, many);
      final v1 = await render(ProjectsVariant.v1, many);
      int px(String html) => int.parse(RegExp(r'height:\s*(\d+)').firstMatch(html)!.group(1)!);
      expect(px(v1), greaterThan(60000));
      // The stage showcase sets no pixel height of its own: each project is a
      // 130dvh slot, so 8 projects are about 10 screens however many
      // screenshots they have.
      expect(RegExp(r'height:\s*\d{4,}').hasMatch(stage), isFalse);
    });

    test('has exactly one client component: Jaspr forbids nesting them', () async {
      // A nested client anchor makes the browser bundle throw on load, which
      // silently disables every interactive part of the page.
      final html = await render(ProjectsVariant.stageShowcase, all);
      expect(RegExp('<!--@').allMatches(html), hasLength(1));
      expect(html, contains('<!--@project_stage_showcase'));
      expect(html, isNot(contains('<!--@shot_gallery')));
    });

    test('empty list renders nothing harmful', () async {
      final html = await render(ProjectsVariant.stageShowcase, const []);
      expect(html, isNot(contains('sd-slot')));
    });
  });

  group('pinned showcase (V2-E)', () {
    test('every project text and link is in the HTML, only the first is active', () async {
      final html = await render(ProjectsVariant.pinnedShowcase, all);
      for (var i = 1; i <= 3; i++) {
        expect(html, contains('Description of app $i'));
        expect(html, contains('play.google.com/store/apps/details?id=app$i'));
        expect(html, contains('https://img.test/$i-1.webp'));
      }
      expect(RegExp('class="pp-info"').allMatches(html), hasLength(3));
      expect(RegExp('data-active="true"').allMatches(html), hasLength(2)); // info + phone
      expect(html, contains('Project 1 / 3'));
      expect(html, contains('Skip to contact'));
    });

    test('has exactly one client component', () async {
      final html = await render(ProjectsVariant.pinnedShowcase, all);
      expect(RegExp('<!--@').allMatches(html), hasLength(1));
    });

    test('inactive projects expose only their first screenshot', () async {
      final html = await render(ProjectsVariant.pinnedShowcase, all);
      // Jaspr also serialises the project data into an HTML comment for
      // hydration, so look at the real <img src> attributes only.
      final sources = RegExp(r'<img[^>]*src="([^"]+)"').allMatches(html).map((m) => m.group(1)).toList();
      expect(sources, contains('https://img.test/3-1.webp'));
      expect(sources, isNot(contains('https://img.test/3-2.webp')));
      // The active project adds the screenshot that is about to play.
      expect(sources, contains('https://img.test/1-2.webp'));
    });

    test('empty list renders nothing harmful', () async {
      final html = await render(ProjectsVariant.pinnedShowcase, const []);
      expect(html, isNot(contains('pp-info')));
    });
  });

  test('production default is the original design', () {
    expect(projectsVariant, ProjectsVariant.v1);
  });
}
