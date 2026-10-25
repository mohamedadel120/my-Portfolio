import 'dart:convert';

import 'package:jaspr/server.dart';
import 'package:jaspr_site/constants/home_layout.dart';
import 'package:jaspr_site/constants/theme.dart';
import 'package:jaspr_site/data/profile_repository.dart';
import 'package:jaspr_site/main.server.options.dart';
import 'package:jaspr_site/sections/hero_section.dart';
import 'package:test/test.dart';

/// Direction c (light, product-first). Its hero is rendered here with
/// `light: true`, since the direction itself is chosen at compile time.
void main() {
  setUpAll(() => Jaspr.initializeApp(options: defaultServerOptions));

  const hero = HeroData(name: 'Mohamed Adel', title: 'Flutter Developer', subtitle: '3+ Years Experience', cvUrl: '');

  Map<String, dynamic> app(String title, String downloads, {List<String>? images, String? slug}) => {
    'title': title,
    'description': '',
    'tech': const <String>[],
    'color': 0xFFFBBF24,
    'downloads': downloads,
    'galleryImages': images,
    'slug': slug,
  };

  Future<String> render(List<Map<String, dynamic>> projects) async {
    final result = await renderComponent(
      HeroSection.content(hero, layout: HomeLayout.v2, projects: projects, light: true),
      standalone: true,
    );
    return utf8.decode(result.body).split('</head>').last;
  }

  test('the phone shows the first app with screenshots and links to its case study', () async {
    final html = await render([
      app('Gomla Mobile App', '10,000+', images: ['/g1.webp', '/g2.webp'], slug: 'gomla'),
      app('Stock Mobile App', '10,000+', images: ['/s1.webp'], slug: 'stock'),
    ]);
    expect(html, contains('href="/projects/gomla"'));
    expect(html, contains('src="/g1.webp"'));
    expect(html, isNot(contains('src="/s1.webp"')));
    // Four frames for the CSS cycle, repeating when there are fewer shots.
    expect(RegExp('class="hero-shot"').allMatches(html), hasLength(4));
  });

  test('the proof row only shows real download counts, at most three', () async {
    final html = await render([
      app('Gomla Mobile App', '10,000+'),
      app('Palleta Mobile App', 'Active Development'),
      app('Stock Mobile App', '10,000+'),
      app('ureva', 'Coming Soon'),
      app('Albatal Mobile App', '1,000+'),
      app('Other', '500+'),
    ]);
    final proof = RegExp(r'<ul class="hero-proof"[\s\S]*?</ul>').firstMatch(html)!.group(0)!;
    expect(proof, contains('Gomla'));
    expect(proof, contains('Stock'));
    expect(proof, contains('Albatal'));
    expect(proof, isNot(contains('Other')), reason: 'only the first three');
    expect(proof, isNot(contains('Active Development')));
    expect(proof, isNot(contains('Coming Soon')));
    expect(proof, isNot(contains('Mobile App')), reason: 'names are shortened');
  });

  test('no apps: no phone and no proof row, the text still renders', () async {
    final html = await render(const []);
    expect(html, contains('Flutter apps people actually download.'));
    expect(html, isNot(contains('hero-device')));
    expect(html, isNot(contains('hero-proof')));
  });

  test('direction c loads Geist and Geist Mono only', () {
    final fonts = AppFonts.byDirection[ThemeDirection.c]!;
    expect(fonts.loaded.map((f) => f.name), ['Geist', 'Geist Mono']);
    expect(fonts.importUrl, contains('display=swap'));
  });
}
