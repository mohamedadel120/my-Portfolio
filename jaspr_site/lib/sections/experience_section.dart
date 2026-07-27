import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import '../constants/theme.dart';
import '../data/experience_repository.dart';

/// Ported from `ExperienceDesktopView`/`ProfessionalExperienceCard` — a
/// vertical timeline (dot + connecting line + card) done with CSS instead
/// of nested `Stack`/`Positioned` widgets and `flutter_animate`.
class ExperienceSection extends AsyncStatelessComponent {
  const ExperienceSection({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final items = await fetchExperiences();

    return section(id: 'experience', classes: 'experience', [
      h2(classes: 'section-title', [.text('Work Experience')]),
      div(classes: 'timeline', [
        for (final (i, exp) in items.indexed)
          div(classes: i == items.length - 1 ? 'timeline-row last' : 'timeline-row', [
            div(classes: 'timeline-rail', [
              div(classes: 'timeline-dot', []),
              if (i != items.length - 1) div(classes: 'timeline-line', []),
            ]),
            div(
              classes: 'timeline-card reveal',
              styles: Styles(raw: {'transition-delay': '${i * 100}ms'}),
              [
              div(classes: 'timeline-card-header', [
                div([
                  h3(classes: 'timeline-company', [.text(exp.company)]),
                  p(classes: 'timeline-role', [.text(exp.role)]),
                ]),
                span(classes: 'timeline-period', [.text(exp.period)]),
              ]),
              div(classes: 'timeline-divider', []),
              ul(classes: 'timeline-achievements', [
                for (final achievement in exp.achievements) li([.text(achievement)]),
              ]),
            ]),
          ]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.experience', [
      css('&').styles(padding: Padding.symmetric(horizontal: 3.75.rem, vertical: 6.25.rem)),
    ]),
    css('.timeline', [
      css('&').styles(margin: Margin.only(top: 4.5.rem)),
    ]),
    css('.timeline-row', [
      css('&').styles(display: Display.flex, alignItems: AlignItems.stretch, gap: Gap.all(2.rem)),
    ]),
    css('.timeline-rail', [
      css('&').styles(display: Display.flex, flexDirection: FlexDirection.column, alignItems: AlignItems.center, width: 1.rem),
    ]),
    css('.timeline-dot', [
      css('&').styles(
        width: 1.rem,
        height: 1.rem,
        radius: BorderRadius.circular(50.percent),
        backgroundColor: AppColors.primary,
        border: Border.all(color: AppColors.background, width: 3.px),
        shadow: BoxShadow(offsetX: Unit.zero, offsetY: Unit.zero, blur: 12.px, spread: 2.px, color: AppColors.primary.withValues(alpha: 0.4)),
      ),
    ]),
    css('.timeline-line', [
      css('&').styles(
        flex: Flex(grow: 1),
        width: 2.px,
        margin: Margin.symmetric(vertical: 0.5.rem),
        raw: {'background': 'linear-gradient(${AppColors.primary.withValues(alpha: 0.6).value}, ${AppColors.primary.withValues(alpha: 0.2).value})'},
      ),
    ]),
    css('.timeline-card', [
      css('&').styles(
        flex: Flex(grow: 1),
        margin: Margin.only(bottom: 3.rem),
        padding: Padding.all(2.rem),
        backgroundColor: AppColors.surface,
        radius: BorderRadius.circular(1.25.rem),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15), width: 1.5.px),
      ),
    ]),
    css('.timeline-row.last .timeline-card').styles(margin: Margin.only(bottom: Unit.zero)),
    css('.timeline-card-header', [
      css('&').styles(display: Display.flex, justifyContent: JustifyContent.spaceBetween, alignItems: AlignItems.start, gap: Gap.all(1.rem)),
    ]),
    css('.timeline-company', [
      css('&').styles(
        color: AppColors.primary,
        fontFamily: FontFamily.list([FontFamily('JetBrains Mono'), FontFamilies.monospace]),
        fontSize: 1.5.rem,
        fontWeight: FontWeight.w700,
        margin: Margin.only(bottom: 0.5.rem),
      ),
    ]),
    css('.timeline-role', [
      css('&').styles(
        color: AppColors.textPrimary,
        fontFamily: FontFamily.list([FontFamily('JetBrains Mono'), FontFamilies.monospace]),
        fontSize: 1.1.rem,
        fontWeight: FontWeight.w600,
      ),
    ]),
    css('.timeline-period', [
      css('&').styles(
        color: AppColors.secondary,
        fontFamily: FontFamily.list([FontFamily('JetBrains Mono'), FontFamilies.monospace]),
        fontSize: 0.8.rem,
        fontWeight: FontWeight.w600,
        padding: Padding.symmetric(horizontal: 1.rem, vertical: 0.5.rem),
        radius: BorderRadius.circular(0.75.rem),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.4), width: 1.5.px),
        backgroundColor: AppColors.secondary.withValues(alpha: 0.15),
        whiteSpace: WhiteSpace.noWrap,
      ),
    ]),
    css('.timeline-divider', [
      css('&').styles(
        height: 1.px,
        margin: Margin.symmetric(vertical: 1.75.rem),
        raw: {'background': 'linear-gradient(90deg, ${AppColors.primary.withValues(alpha: 0.3).value}, transparent)'},
      ),
    ]),
    css('.timeline-achievements', [
      css('&').styles(margin: Margin.zero, padding: Padding.zero, raw: {'list-style': 'none'}),
      css('li').styles(
        position: Position.relative(),
        color: AppColors.textPrimary.withValues(alpha: 0.9),
        fontFamily: FontFamily.list([FontFamily('JetBrains Mono'), FontFamilies.monospace]),
        fontSize: 1.rem,
        lineHeight: Unit.expression('1.7'),
        padding: Padding.only(left: 1.25.rem, bottom: 1.125.rem),
      ),
      css('li::before').styles(
        content: '',
        position: Position.absolute(left: Unit.zero, top: 0.65.rem),
        width: 6.px,
        height: 6.px,
        radius: BorderRadius.circular(50.percent),
        backgroundColor: AppColors.primary,
      ),
    ]),
  ];
}
