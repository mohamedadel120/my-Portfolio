import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import '../constants/theme.dart';
import '../data/profile_repository.dart';

/// Ported from `ExpertiseDesktopView`/`ExpertiseCard` — a vertical list of
/// index/icon/title/description rows with a hover state, done with CSS
/// instead of `MouseRegion`/`AnimatedContainer`. Icons render as Material
/// Symbols ligatures (see utils/icon_mapper.dart) instead of Flutter
/// `IconData`.
class ExpertiseSection extends AsyncStatelessComponent {
  const ExpertiseSection({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final items = await fetchExpertise();

    return section(id: 'expertise', classes: 'expertise', [
      h2(classes: 'section-title', [.text('Expertise')]),
      div(classes: 'expertise-list', [
        for (final (i, item) in items.indexed)
          div(
            classes: 'expertise-row reveal',
            styles: Styles(raw: {'transition-delay': '${i * 80}ms'}),
            [
              span(classes: 'expertise-index', [.text((i + 1).toString().padLeft(2, '0'))]),
              span(classes: 'material-symbols-rounded expertise-icon', [.text(item.iconKey)]),
              div(classes: 'expertise-text', [
                h3(classes: 'expertise-title', [.text(item.title)]),
                p(classes: 'expertise-description', [.text(item.description)]),
              ]),
            ],
          ),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.expertise', [
      css('&').styles(padding: Padding.symmetric(horizontal: 3.75.rem, vertical: 6.25.rem)),
    ]),
    css('.expertise-list', [
      css('&').styles(margin: Margin.only(top: 4.5.rem)),
    ]),
    css('.expertise-row', [
      css('&').styles(
        display: Display.flex,
        alignItems: AlignItems.center,
        gap: Gap.all(2.rem),
        padding: Padding.symmetric(vertical: 2.5.rem),
        border: Border.only(bottom: BorderSide.solid(color: Colors.white.withValues(alpha: 0.1))),
        transition: Transition('background-color', duration: 250.ms),
      ),
      css('&:hover').styles(backgroundColor: Colors.white.withValues(alpha: 0.02)),
      css('&:hover .expertise-icon').styles(color: AppColors.primary),
    ]),
    css('.expertise-index', [
      css('&').styles(
        color: AppColors.textTertiary,
        fontFamily: FontFamily.list([FontFamily('Space Mono'), FontFamilies.monospace]),
        fontSize: 1.25.rem,
        fontWeight: FontWeight.w700,
        width: 3.rem,
      ),
    ]),
    css('.expertise-icon', [
      css('&').styles(
        color: AppColors.textSecondary,
        fontSize: 2.rem,
        transition: Transition('color', duration: 250.ms),
      ),
    ]),
    css('.expertise-title', [
      css('&').styles(
        color: AppColors.textPrimary,
        fontFamily: FontFamily.list([FontFamily('IBM Plex Mono'), FontFamilies.monospace]),
        fontWeight: FontWeight.w600,
        fontSize: 1.5.rem,
        margin: Margin.only(bottom: 0.5.rem),
      ),
    ]),
    css('.expertise-description', [
      css('&').styles(
        color: AppColors.textSecondary,
        fontFamily: FontFamily.list([FontFamily('JetBrains Mono'), FontFamilies.monospace]),
        fontSize: 0.95.rem,
        lineHeight: Unit.expression('1.6'),
        maxWidth: 700.px,
      ),
    ]),
  ];
}
