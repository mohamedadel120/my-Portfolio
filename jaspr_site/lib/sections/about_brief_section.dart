import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import '../constants/theme.dart';
import '../data/profile_repository.dart';

/// The v2 home page's one short About (see constants/home_layout.dart). It
/// replaces About, Expertise and Why Choose Me, which said similar things:
/// the profile's professional summary, then the same skills the old
/// "Proficiency" tile lists, grouped by area. No percentages or bars: a
/// self-rated "95%" says nothing a reader can check.
///
/// Reads the same `profile_info/main` document as [AboutSection], so the
/// skills are Firestore's when it has them and the existing fallback list
/// otherwise. The `/about` route still renders [AboutSection].
class AboutBriefSection extends AsyncStatelessComponent {
  const AboutBriefSection({super.key});

  @override
  Future<Component> build(BuildContext context) async => content(await fetchAboutData());

  /// The section markup for [about]. Public so tests can render it without a
  /// network fetch.
  static Component content(AboutData about) {
    final summary = about.professionalSummary.trim();
    return section(id: 'about', classes: 'about-brief', [
      h2(classes: 'section-title', [.text('About Me')]),
      div(classes: 'about-brief-body', [
        if (summary.isNotEmpty) p(classes: 'about-brief-summary reveal', [.text(summary)]),
        div(classes: 'skill-groups', [
          for (final (i, group) in groupSkills(about.skills).indexed)
            div(
              classes: 'skill-group reveal',
              styles: Styles(raw: {'transition-delay': '${i * 80}ms'}),
              [
                h3(classes: 'skill-group-title', [.text(group.area)]),
                ul(classes: 'skill-chips', [
                  for (final name in group.skills) li([.text(name)]),
                ]),
              ],
            ),
        ]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.about-brief', [
      css('&').styles(padding: Padding.symmetric(horizontal: 3.75.rem, vertical: 6.25.rem)),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile.px), [
        css('&').styles(padding: Padding.symmetric(horizontal: 1.25.rem, vertical: 4.rem)),
      ]),
    ]),
    css('.about-brief-body', [
      css('&').styles(maxWidth: 1000.px, margin: Margin.only(top: 3.75.rem, left: Unit.auto, right: Unit.auto)),
    ]),
    css('.about-brief-summary', [
      css('&').styles(
        color: AppColors.textSecondary,
        fontFamily: AppFonts.of(FontRole.text, was: AppFonts.jetBrainsMono),
        fontSize: 1.125.rem,
        lineHeight: Unit.expression('1.7'),
        margin: Margin.only(bottom: 3.rem),
      ),
    ]),
    css('.skill-groups', [
      css('&').styles(
        display: Display.grid,
        gap: Gap.all(1.5.rem),
        raw: {'grid-template-columns': 'repeat(auto-fit, minmax(min(100%, 220px), 1fr))'},
      ),
    ]),
    css('.skill-group', [
      css('&').styles(
        backgroundColor: AppColors.surface.withValues(alpha: 0.6),
        border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.08), width: 1.px),
        radius: BorderRadius.circular(1.25.rem),
        padding: Padding.all(1.5.rem),
      ),
    ]),
    css('.skill-group-title', [
      css('&').styles(
        color: AppColors.primary,
        fontFamily: AppFonts.of(FontRole.accent, was: AppFonts.spaceMono),
        fontSize: 0.8.rem,
        letterSpacing: 2.px,
        textTransform: TextTransform.upperCase,
        margin: Margin.only(bottom: 1.rem),
      ),
    ]),
    css('.skill-chips', [
      css('&').styles(
        display: Display.flex,
        flexWrap: FlexWrap.wrap,
        gap: Gap.all(0.5.rem),
        padding: Padding.zero,
        margin: Margin.zero,
        raw: {'list-style': 'none'},
      ),
      css('li').styles(
        color: AppColors.textPrimary,
        fontFamily: AppFonts.of(FontRole.text, was: AppFonts.jetBrainsMono),
        fontSize: 0.85.rem,
        padding: Padding.symmetric(horizontal: 0.75.rem, vertical: 0.4.rem),
        radius: BorderRadius.circular(999.px),
        backgroundColor: AppColors.textPrimary.withValues(alpha: 0.05),
        border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.1), width: 1.px),
      ),
    ]),
  ];
}

/// One area and the skill names that belong to it.
typedef SkillGroup = ({String area, List<String> skills});

// Keywords that place a skill name in an area, checked in this order (so
// "State Management (Bloc, Cubit)" lands in architecture before anything
// else can claim it). Areas are listed on the page in [_areaOrder].
const _areaKeywords = <(String, List<String>)>[
  ('Architecture & state', ['architecture', 'bloc', 'cubit', 'state management', 'provider']),
  ('Backend & APIs', ['firebase', 'supabase', 'api', 'graphql', 'rest']),
  ('Delivery', ['ci/cd', 'devops', 'testing', 'flavor']),
  ('Mobile & UI', ['flutter', 'dart', 'ui', 'responsive', 'animation']),
];

const _areaOrder = ['Mobile & UI', 'Architecture & state', 'Backend & APIs', 'Delivery', 'Other'];

/// Groups [skills] by area, dropping repeats (the fallback list has two) and
/// any progress value. A name no keyword matches goes under "Other" rather
/// than disappearing, so a skill added in Firestore always shows.
List<SkillGroup> groupSkills(List<TechnicalSkill> skills) {
  final byArea = <String, List<String>>{};
  final seen = <String>{};
  for (final skill in skills) {
    final name = skill.name.trim();
    if (name.isEmpty || !seen.add(name.toLowerCase())) continue;
    final lower = name.toLowerCase();
    final area = _areaKeywords
        .firstWhere((entry) => entry.$2.any(lower.contains), orElse: () => ('Other', const []))
        .$1;
    (byArea[area] ??= []).add(name);
  }
  return [
    for (final area in _areaOrder)
      if (byArea[area] case final names?) (area: area, skills: names),
  ];
}
