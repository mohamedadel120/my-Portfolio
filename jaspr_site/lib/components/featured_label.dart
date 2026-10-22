import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import 'project_view.dart';

/// The owner-controlled emphasis for a project: a small "Featured" label and
/// one headline claim (`featured` and `highlight` in Firestore). Renders
/// nothing for a project that has neither, so every presentation can place it
/// the same way, right after the title.
class FeaturedLabel extends StatelessComponent {
  final ProjectView view;

  const FeaturedLabel(this.view, {super.key});

  @override
  Component build(BuildContext context) {
    final highlight = view.highlight;
    if (!view.featured && highlight == null) return const Component.fragment([]);

    return div(classes: 'feat', [
      if (view.featured)
        span(classes: 'feat-badge', [
          // Clipped box: the icon font shows its ligature text until it loads.
          span(classes: 'material-symbols-rounded feat-star', attributes: {'aria-hidden': 'true'}, [.text('star')]),
          .text('Featured project'),
        ]),
      if (highlight != null) p(classes: 'feat-highlight', attributes: const {'dir': 'auto'}, [.text(highlight)]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.feat', [
      css('&').styles(display: Display.flex, flexDirection: FlexDirection.column, alignItems: AlignItems.start, gap: Gap.all(0.6.rem)),
    ]),
    css('.feat-badge', [
      css('&').styles(
        display: Display.inlineFlex,
        alignItems: AlignItems.center,
        gap: Gap.all(0.35.rem),
        padding: Padding.symmetric(horizontal: 0.75.rem, vertical: 0.3.rem),
        radius: BorderRadius.circular(2.rem),
        border: Border.all(color: AppColors.primary, width: 1.px),
        // Teal text on its own tint falls under 4.5:1 on the light page.
        backgroundColor: lit(AppColors.primary.withValues(alpha: 0.14), light: AppColors.surface),
        color: AppColors.primary,
        fontFamily: themed(null, calm: AppFonts.of(FontRole.accent, was: AppFonts.jetBrainsMono)),
        fontSize: AppType.size(TypeStep.label, was: 0.78.rem),
        fontWeight: themed(FontWeight.w800, calm: FontWeight.w600),
        raw: {'box-shadow': '0 0 22px -6px ${AppColors.glow(0.7).value}'},
      ),
    ]),
    css('.feat-star', [
      css('&').styles(
        width: 1.rem,
        height: 1.rem,
        overflow: Overflow.hidden,
        fontSize: 1.rem,
        raw: {'line-height': '1', 'font-variation-settings': "'FILL' 1"},
      ),
    ]),
    css('.feat-highlight', [
      css('&').styles(
        margin: Margin.zero,
        // The app's own colour where the design provides one (--accent-fg).
        fontSize: Unit.expression('clamp(1.05rem, 2.3dvh, 1.3rem)'),
        fontWeight: FontWeight.w700,
        lineHeight: Unit.expression('1.45'),
        // Dark looks: the app's own colour. Light look: ink text (a darkened
        // yellow reads as muddy olive) with the app's colour as a side mark.
        raw: lit(
          {'color': 'var(--accent-fg, ${AppColors.textPrimary.value})'},
          light: {
            'color': AppColors.textPrimary.value,
            'border-left': '3px solid var(--accent, ${AppColors.primary.value})',
            'padding-left': '0.85rem',
          },
        ),
        maxWidth: Unit.expression('60ch'),
      ),
    ]),
  ];
}
