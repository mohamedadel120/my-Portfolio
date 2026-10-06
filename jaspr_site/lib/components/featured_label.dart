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
      if (view.featured) span(classes: 'feat-badge', [.text('Featured')]),
      if (highlight != null) p(classes: 'feat-highlight', [.text(highlight)]),
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
        padding: Padding.symmetric(horizontal: 0.7.rem, vertical: 0.25.rem),
        radius: BorderRadius.circular(0.5.rem),
        border: Border.all(color: AppColors.primary, width: 1.px),
        color: AppColors.primary,
        fontSize: 0.75.rem,
        fontWeight: FontWeight.w700,
      ),
    ]),
    css('.feat-highlight', [
      css('&').styles(
        margin: Margin.zero,
        color: AppColors.textPrimary,
        fontSize: 1.05.rem,
        fontWeight: FontWeight.w600,
        lineHeight: Unit.expression('1.5'),
        maxWidth: Unit.expression('60ch'),
      ),
    ]),
  ];
}
