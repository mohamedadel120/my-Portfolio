import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import '../constants/theme.dart';
import '../data/why_choose_me_repository.dart';

/// Ported from the Flutter app's `WhyChooseMeSection`/`_WhyChooseMeCard` — a
/// responsive grid of icon/title/description cards, each tinted with its own
/// Firestore `color`. The per-card color is passed as a `--accent` custom
/// property and mixed down with `color-mix()` in place of Flutter's
/// `withValues(alpha:)`; the hover lift is CSS instead of `AnimatedContainer`.
class WhyChooseMeSection extends AsyncStatelessComponent {
  const WhyChooseMeSection({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final reasons = await fetchWhyChooseMe();

    return section(id: 'why-choose-me', classes: 'why-choose-me', [
      h2(classes: 'section-title', [.text('Why Choose Me')]),
      div(classes: 'reasons-grid', [
        for (final (i, reason) in reasons.indexed)
          div(
            classes: 'reason-card reveal',
            styles: Styles(raw: {'--accent': reason.color, '--reveal-delay': '${i * 80}ms'}),
            [
              span(classes: 'material-symbols-rounded reason-icon', [.text(reason.iconKey)]),
              h3(classes: 'reason-title', [.text(reason.title)]),
              p(classes: 'reason-description', [.text(reason.description)]),
            ],
          ),
      ]),
    ]);
  }

  static String _accent(int percent) => 'color-mix(in srgb, var(--accent) $percent%, transparent)';

  // The staggered reveal delay applies only to the scroll-in fade/slide
  // (`transform`); the hover lift uses the separate `translate` property so it
  // responds immediately instead of waiting out the card's stagger delay.
  static const _transition =
      'opacity 600ms ease-out var(--reveal-delay, 0ms), transform 600ms ease-out var(--reveal-delay, 0ms), '
      'translate 300ms ease, border-color 300ms ease, box-shadow 300ms ease';

  @css
  static List<StyleRule> get styles => [
    css('.why-choose-me', [
      css('&').styles(
        padding: Padding.symmetric(horizontal: 3.75.rem, vertical: 6.25.rem),
      ),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile.px), [
        css('&').styles(
          padding: Padding.symmetric(horizontal: 1.25.rem, vertical: 4.rem),
        ),
      ]),
    ]),
    css('.reasons-grid', [
      css('&').styles(
        display: Display.grid,
        gap: Gap.all(1.5.rem),
        margin: Margin.only(top: 4.5.rem),
        raw: {'grid-template-columns': 'repeat(3, minmax(0, 1fr))'},
      ),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.tablet.px), [
        css('&').styles(raw: {'grid-template-columns': 'repeat(2, minmax(0, 1fr))'}),
      ]),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile.px), [
        css('&').styles(
          gap: Gap.all(1.rem),
          margin: Margin.only(top: 3.rem),
          raw: {'grid-template-columns': '1fr'},
        ),
      ]),
    ]),
    css('.reason-card', [
      css('&').styles(
        padding: Padding.all(1.75.rem),
        radius: BorderRadius.circular(1.25.rem),
        raw: {
          'background': 'linear-gradient(135deg, ${_accent(12)}, ${_accent(6)} 50%, ${AppColors.surface.value})',
          'border': '1.5px solid ${_accent(25)}',
          'box-shadow': '0 4px 20px ${_accent(12)}',
        },
      ),
      // Beats the global `.reveal` transition on specificity.
      css('&.reveal').styles(raw: {'transition': _transition}),
      css('&.reveal.revealed:hover').styles(
        raw: {
          'translate': '0 -6px',
          'border-color': _accent(50),
          'box-shadow': '0 8px 30px ${_accent(30)}',
        },
      ),
    ]),
    css('.reason-icon', [
      css('&').styles(
        display: Display.inlineBlock,
        fontSize: 2.rem,
        padding: Padding.all(0.875.rem),
        radius: BorderRadius.circular(0.875.rem),
        margin: Margin.only(bottom: 1.25.rem),
        raw: {
          'color': 'var(--accent)',
          'background': 'linear-gradient(90deg, ${_accent(30)}, ${_accent(15)})',
          'border': '1.5px solid ${_accent(40)}',
        },
      ),
    ]),
    css('.reason-title', [
      css('&').styles(
        color: AppColors.textPrimary,
        fontFamily: FontFamily.list([FontFamily('JetBrains Mono'), FontFamilies.monospace]),
        fontSize: 1.3.rem,
        fontWeight: FontWeight.w700,
        margin: Margin.only(bottom: 0.75.rem),
      ),
    ]),
    css('.reason-description', [
      css('&').styles(
        color: AppColors.textSecondary,
        fontFamily: FontFamily.list([FontFamily('JetBrains Mono'), FontFamilies.monospace]),
        fontSize: 0.95.rem,
        lineHeight: Unit.expression('1.6'),
        margin: Margin.zero,
      ),
    ]),
  ];
}
