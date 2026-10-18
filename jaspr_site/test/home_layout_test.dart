import 'dart:convert';

import 'package:jaspr/server.dart';
import 'package:jaspr_site/constants/home_layout.dart';
import 'package:jaspr_site/data/profile_repository.dart';
import 'package:jaspr_site/main.server.options.dart';
import 'package:jaspr_site/pages/home.dart';
import 'package:jaspr_site/sections/about_brief_section.dart';
import 'package:jaspr_site/sections/about_section.dart';
import 'package:jaspr_site/sections/contact_section.dart';
import 'package:jaspr_site/sections/experience_section.dart';
import 'package:jaspr_site/sections/expertise_section.dart';
import 'package:jaspr_site/sections/hero_section.dart';
import 'package:jaspr_site/sections/projects_section.dart';
import 'package:jaspr_site/sections/testimonials_section.dart';
import 'package:jaspr_site/sections/why_choose_me_section.dart';
import 'package:test/test.dart';

Future<String> render(Component component) async {
  final result = await renderComponent(component, standalone: true);
  // Standalone output prepends the components' CSS in <head>; assertions are
  // about the rendered markup only.
  return utf8.decode(result.body).split('</head>').last;
}

const hero = HeroData(name: 'Mohamed Adel', title: 'Flutter Developer', subtitle: '3+ Years Experience', cvUrl: '');

// Shaped like the live data: progress values, and a repeated skill.
const about = AboutData(
  professionalSummary: 'Flutter Developer with 3+ years of experience.',
  downloadsCount: '10k+',
  ratings: '',
  features: [],
  skills: [
    TechnicalSkill(name: 'Flutter & Dart', progress: 0.95, isPrimary: true),
    TechnicalSkill(name: 'Clean Architecture & Bloc', progress: 0.90, isPrimary: true),
    TechnicalSkill(name: 'Firebase & REST APIs', progress: 0.88, isPrimary: false),
    TechnicalSkill(name: 'CI/CD & DevOps', progress: 0.80, isPrimary: false),
    TechnicalSkill(name: 'CI/CD & DevOps', progress: 0.80, isPrimary: false),
    TechnicalSkill(name: 'Kotlin', progress: 0.5, isPrimary: false),
  ],
);

void main() {
  setUpAll(() => Jaspr.initializeApp(options: defaultServerOptions));

  test('the chosen structure (v2) is the default; v1 is still available', () {
    expect(homeLayout, HomeLayout.v2);
    expect(HomeLayout.values, [HomeLayout.v1, HomeLayout.v2]);
    expect(heroCopyIndex, 0);
    expect(heroCopies, hasLength(3));
  });

  test('v1 renders the same sections as before, in the same order', () {
    expect(Home.sections(HomeLayout.v1).map((c) => c.runtimeType), [
      HeroSection,
      AboutSection,
      ExpertiseSection,
      WhyChooseMeSection,
      ExperienceSection,
      ProjectsSection,
      TestimonialsSection,
      ContactSection,
    ]);
    expect((Home.sections(HomeLayout.v1).first as HeroSection).layout, HomeLayout.v1);
  });

  test('v2 puts Projects first and has one About', () {
    expect(Home.sections(HomeLayout.v2).map((c) => c.runtimeType), [
      HeroSection,
      ProjectsSection,
      ExperienceSection,
      AboutBriefSection,
      TestimonialsSection,
      ContactSection,
    ]);
    expect((Home.sections(HomeLayout.v2).first as HeroSection).layout, HomeLayout.v2);
  });

  group('hero', () {
    test('v1 keeps today\'s text', () async {
      final html = await render(HeroSection.content(hero, layout: HomeLayout.v1));
      expect(html, contains('class="hero-name"'));
      expect(html, contains('MOHAMED ADEL'));
      expect(html, contains('3+ Years Experience'));
      expect(html, contains('BASED IN EGYPT'));
      for (final copy in heroCopies) {
        expect(html, isNot(contains(copy.headline)));
      }
    });

    for (final (i, copy) in heroCopies.indexed) {
      test('v2 option ${i + 1} renders its headline and sub-line', () async {
        // The dark directions' text hero (direction c has its own, see
        // direction_c_test.dart).
        final html = await render(HeroSection.content(hero, layout: HomeLayout.v2, copyIndex: i, light: false));
        expect(html, contains('<h1 class="hero-headline">${copy.headline}</h1>'));
        expect(html, contains(copy.subline));
        expect(html, contains('MOHAMED ADEL'));
        expect(html, isNot(contains('class="hero-name"')));
      });
    }

    test('every option stays short and uses only confirmed facts', () {
      for (final copy in heroCopies) {
        expect(copy.headline.split(' ').length, lessThanOrEqualTo(12), reason: copy.headline);
        final text = '${copy.headline} ${copy.subline}';
        expect(text, isNot(contains('%')));
        expect(text.toLowerCase(), isNot(contains('rating')));
        expect(text.toLowerCase(), isNot(contains('first')));
        // Every number is one of the confirmed ones.
        for (final m in RegExp(r'\d[\d,]*\+?').allMatches(text)) {
          expect(['3+', '10,000+', '1,000+'], contains(m.group(0)), reason: text);
        }
      }
    });
  });

  group('merged About', () {
    test('shows the summary and grouped skills without any percentage', () async {
      final html = await render(AboutBriefSection.content(about));
      expect(html, contains('id="about"'));
      expect(html, contains('Flutter Developer with 3+ years of experience.'));
      expect(html, contains('Flutter &amp; Dart'));
      expect(html, isNot(contains('%')));
      expect(html, isNot(contains('95')));
      expect(html, isNot(contains('skill-fill')));
      expect(RegExp('CI/CD &amp; DevOps').allMatches(html), hasLength(1));
    });

    test('groups by area, and an unknown skill still shows', () {
      final groups = groupSkills(about.skills);
      expect(groups.map((g) => g.area), ['Mobile & UI', 'Architecture & state', 'Backend & APIs', 'Delivery', 'Other']);
      expect(groups.last.skills, ['Kotlin']);
    });

    test('an empty summary renders no empty paragraph', () async {
      const empty = AboutData(professionalSummary: ' ', downloadsCount: '', ratings: '', features: [], skills: []);
      final html = await render(AboutBriefSection.content(empty));
      expect(html, isNot(contains('about-brief-summary')));
    });
  });
}
