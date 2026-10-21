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
};

Future<String> render(ProjectsVariant variant, List<Map<String, dynamic>> projects) async {
  final result = await renderComponent(ProjectsSection.showcase(variant, projects), standalone: true);
  // Standalone output prepends the components' CSS in <head>; assertions are
  // about the rendered markup only.
  return utf8.decode(result.body).split('</head>').last;
}

/// The markup without Jaspr's hydration data comment, which repeats every raw
/// field of every project.
String markupOnly(String html) => html.replaceAll(RegExp(r'<!--@[\s\S]*?-->'), '');

void main() {
  setUpAll(() => Jaspr.initializeApp(options: defaultServerOptions));

  final all = [for (var i = 1; i <= 3; i++) project(i)];

  test('the chosen design is the default; the original is still available', () {
    expect(projectsVariant, ProjectsVariant.pinnedShowcase);
    expect(ProjectsVariant.values, [ProjectsVariant.v1, ProjectsVariant.pinnedShowcase]);
  });

  group('both designs render real content', () {
    for (final variant in ProjectsVariant.values) {
      test('$variant', () async {
        final html = await render(variant, all);
        expect(html, contains('App 1'));
        expect(html, isNot(contains('Instance of')));
        expect(RegExp('<!--@').allMatches(html), hasLength(1), reason: 'exactly one client component');
      });
    }
  });

  group('original (v1) is untouched', () {
    test('has none of the new controls', () async {
      final html = await render(ProjectsVariant.v1, all);
      expect(html, isNot(contains('build yours')));
      expect(html, isNot(contains('pp-hud')));
      expect(html, isNot(contains('aria-label="Project showcase"')));
    });
  });

  group('pinned showcase', () {
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

    test('only the active project and its neighbours load screenshots', () async {
      final html = await render(ProjectsVariant.pinnedShowcase, [for (var i = 1; i <= 5; i++) project(i)]);
      final sources = RegExp(r'<img[^>]*src="([^"]+)"').allMatches(html).map((m) => m.group(1)).toList();
      // The active project adds the screenshot that is about to play.
      expect(sources, containsAll(['https://img.test/1-1.webp', 'https://img.test/1-2.webp']));
      // Its neighbour keeps its first screenshot ready, nothing more.
      expect(sources, contains('https://img.test/2-1.webp'));
      expect(sources, isNot(contains('https://img.test/2-2.webp')));
      // Projects further away load nothing until the visitor gets close.
      for (var i = 3; i <= 5; i++) {
        expect(sources.where((s) => s!.startsWith('https://img.test/$i-')), isEmpty, reason: 'project $i');
      }
    });

    test('arrows flank the phone and the player bar sits over the screen', () async {
      final html = await render(ProjectsVariant.pinnedShowcase, all);
      expect(html, contains('class="pp-deck"'));
      expect(html.indexOf('aria-label="Previous screenshot"'), lessThan(html.indexOf('class="pp-phones"')));
      expect(html.indexOf('aria-label="Next screenshot"'), greaterThan(html.indexOf('class="pp-phones"')));
      expect(html, contains('class="pp-hud"'));
      expect(html, contains('class="pp-tap"'));
      final hud = RegExp(r'class="pp-hud">.*?class="pp-count"', dotAll: true).firstMatch(html)!.group(0)!;
      expect(hud, isNot(contains('Previous screenshot')));
      expect(hud, isNot(contains('Next screenshot')));
    });

    test('a project with a single screenshot has no arrows or player bar', () async {
      final one = project(7)..['galleryImages'] = ['https://img.test/only.webp'];
      final html = await render(ProjectsVariant.pinnedShowcase, [one]);
      expect(html, isNot(contains('aria-label="Next screenshot"')));
      expect(html, isNot(contains('class="pp-hud"')));
    });

    test('round store buttons and the shared call to action', () async {
      final html = await render(ProjectsVariant.pinnedShowcase, all);
      expect(html, contains('class="store-btn store-btn-play"'));
      expect(html, contains('store-btn store-btn-ios'));
      expect(html, contains('class="store-tooltip"'));
      expect(html, contains('aria-label="Get App 1 on Google Play (opens in a new tab)"'));
      expect(html, contains('rel="noopener"'));
      expect(html, contains('class="cta-btn"'));
      expect(html, contains('build yours'));
      expect(html, contains('rocket_launch'));
    });

    test('a project on neither store says coming soon instead of store buttons', () async {
      final html = markupOnly(await render(ProjectsVariant.pinnedShowcase, [project(9, full: false)]));
      expect(html, contains('Coming soon'));
      expect(html, isNot(contains('class="store-btn')));
    });

    test('"Coming soon" is not repeated when the status line already says it', () async {
      final soon = project(9, full: false)..['downloads'] = 'Coming Soon';
      final html = markupOnly(await render(ProjectsVariant.pinnedShowcase, [soon]));
      expect(RegExp('coming soon', caseSensitive: false).allMatches(html), hasLength(1));
    });

    test('empty list renders nothing harmful', () async {
      final html = await render(ProjectsVariant.pinnedShowcase, const []);
      expect(html, isNot(contains('pp-info')));
    });
  });

  group('featured project', () {
    final featured = project(1)..['featured'] = true..['highlight'] = 'One app for skin analysis and delivery';
    final plain = [project(2), project(3)];

    test('shows the badge, the headline and a star in the list', () async {
      final html = await render(ProjectsVariant.pinnedShowcase, [featured, ...plain]);
      expect(RegExp('class="feat-badge"').allMatches(html), hasLength(1));
      expect(html, contains('Featured project'));
      expect(html, contains('One app for skin analysis and delivery'));
      expect(RegExp('pp-nav-star').allMatches(html), hasLength(1));
    });

    test('shows nothing extra when neither field is set', () async {
      final html = await render(ProjectsVariant.pinnedShowcase, plain);
      expect(html, isNot(contains('feat-badge')));
      expect(html, isNot(contains('feat-highlight')));
      expect(html, isNot(contains('pp-nav-star')));
    });

    test('a highlight without featured shows the headline but no badge', () async {
      final only = project(4)..['highlight'] = 'Just a headline';
      final html = await render(ProjectsVariant.pinnedShowcase, [only]);
      expect(html, contains('Just a headline'));
      expect(html, isNot(contains('feat-badge')));
    });
  });
}
