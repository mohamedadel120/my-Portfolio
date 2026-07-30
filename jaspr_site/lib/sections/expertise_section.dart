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
        position: Position.relative(),
        display: Display.flex,
        alignItems: AlignItems.center,
        gap: Gap.all(2.rem),
        padding: Padding.symmetric(vertical: 2.5.rem, horizontal: 1.rem),
        border: Border.only(bottom: BorderSide.solid(color: Colors.white.withValues(alpha: 0.1))),
        raw: {'transition': 'background-color 250ms, transform 250ms ease, padding-left 250ms ease'},
      ),
      css('&:hover').styles(
        backgroundColor: Colors.white.withValues(alpha: 0.03),
        transform: Transform.translate(x: 0.5.rem),
      ),
      css('&:hover .expertise-icon').styles(
        color: AppColors.primary,
        raw: {
          'transform': 'scale(1.2) rotate(-8deg)',
          'filter': 'drop-shadow(0 0 10px ${AppColors.primary.withValues(alpha: 0.6).value})',
        },
      ),
      css('&:hover .expertise-index').styles(color: AppColors.secondary),
      css('&:hover .expertise-title').styles(color: AppColors.primary),
      // A left accent bar that grows in from the middle on hover, echoing
      // the section-title underline's gradient elsewhere on the page.
      css('&::before').styles(
        content: '',
        position: Position.absolute(left: Unit.zero, top: 50.percent),
        width: 3.px,
        height: 100.percent,
        radius: BorderRadius.circular(2.px),
        opacity: 0,
        raw: {
          'transform': 'translateY(-50%) scaleY(0)',
          'background': 'linear-gradient(${AppColors.primary.value}, ${AppColors.secondary.value})',
          'transition': 'transform 250ms ease, opacity 250ms ease',
        },
      ),
      css('&:hover::before').styles(opacity: 1, raw: {'transform': 'translateY(-50%) scaleY(1)'}),
    ]),
    css('.expertise-index', [
      css('&').styles(
        color: AppColors.textTertiary,
        fontFamily: FontFamily.list([FontFamily('Space Mono'), FontFamilies.monospace]),
        fontSize: 1.25.rem,
        fontWeight: FontWeight.w700,
        width: 3.rem,
        raw: {'transition': 'color 250ms ease'},
      ),
    ]),
    css('.expertise-icon', [
      css('&').styles(
        display: Display.inlineBlock,
        color: AppColors.textSecondary,
        fontSize: 2.rem,
        raw: {'transition': 'color 250ms ease, transform 250ms ease, filter 250ms ease'},
      ),
    ]),
    css('.expertise-title', [
      css('&').styles(
        color: AppColors.textPrimary,
        fontFamily: FontFamily.list([FontFamily('IBM Plex Mono'), FontFamilies.monospace]),
        fontWeight: FontWeight.w600,
        fontSize: 1.5.rem,
        margin: Margin.only(bottom: 0.5.rem),
        raw: {'transition': 'color 250ms ease'},
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
