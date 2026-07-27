import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import '../constants/theme.dart';
import '../data/profile_repository.dart';

/// Ported from `HeroDesktopView`. Fetched at build time (server-only,
/// `AsyncStatelessComponent` — see the migration plan's Phase 2 goal) rather
/// than client-side, so the name/title/subtitle are in the static HTML a
/// crawler sees. The pulsing "aurora" background blob is a static CSS
/// radial-gradient here instead of an infinite `flutter_animate` loop —
/// reveal/entrance animations are a deliberately separate pass (Phase 5).
class HeroSection extends AsyncStatelessComponent {
  const HeroSection({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final hero = await fetchHeroData();

    return section(id: 'hero', classes: 'hero', [
      div(classes: 'hero-aurora', []),
      div(classes: 'hero-content reveal', [
        div(classes: 'hero-eyebrow', [
          span([.text(hero.title.toUpperCase())]),
          div(classes: 'hero-eyebrow-line', []),
          span(classes: 'hero-location', [.text('BASED IN EGYPT')]),
        ]),
        h1(classes: 'hero-name', [.text(hero.name.toUpperCase())]),
        div(classes: 'hero-footer', [
          p(classes: 'hero-subtitle', [.text(hero.subtitle)]),
          div(classes: 'hero-actions', [
            a(href: '/#projects', classes: 'hero-action', [.text('PROJECTS →')]),
            a(href: '/#contact', classes: 'hero-action', [.text('CONTACT →')]),
          ]),
        ]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.hero', [
      css('&').styles(
        position: Position.relative(),
        display: Display.flex,
        alignItems: AlignItems.end,
        minHeight: 100.vh,
        padding: Padding.symmetric(horizontal: 3.75.rem, vertical: 6.25.rem),
        overflow: Overflow.hidden,
      ),
    ]),
    css('.hero-aurora', [
      css('&').styles(
        position: Position.absolute(top: (-100).px, right: (-100).px),
        width: 600.px,
        height: 600.px,
        radius: BorderRadius.circular(50.percent),
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
        shadow: BoxShadow(offsetX: Unit.zero, offsetY: Unit.zero, blur: 100.px, spread: 20.px, color: AppColors.primary.withValues(alpha: 0.1)),
      ),
    ]),
    css('.hero-content', [
      css('&').styles(position: Position.relative(), zIndex: ZIndex(1), maxWidth: 1400.px, width: 100.percent),
    ]),
    css('.hero-eyebrow', [
      css('&').styles(
        display: Display.flex,
        alignItems: AlignItems.center,
        gap: Gap.all(1.rem),
        margin: Margin.only(bottom: 1.rem),
      ),
      css('span').styles(
        color: AppColors.textPrimary,
        fontFamily: FontFamily.list([FontFamily('IBM Plex Mono'), FontFamilies.monospace]),
        fontWeight: FontWeight.w700,
        fontSize: 1.rem,
      ),
      css('.hero-eyebrow-line').styles(width: 40.px, height: 1.px, backgroundColor: AppColors.primary),
      css('.hero-location').styles(
        color: AppColors.textTertiary,
        fontFamily: FontFamily.list([FontFamily('Space Mono'), FontFamilies.monospace]),
        fontWeight: FontWeight.normal,
        fontSize: 0.85.rem,
      ),
    ]),
    css('.hero-name', [
      css('&').styles(
        fontFamily: FontFamily.list([FontFamily('Orbitron'), FontFamilies.sansSerif]),
        fontSize: Unit.expression('clamp(3rem, 10vw, 15rem)'),
        lineHeight: Unit.expression('0.9'),
        letterSpacing: (-4).px,
        color: AppColors.textPrimary,
        margin: Margin.only(bottom: 3.rem),
      ),
    ]),
    css('.hero-footer', [
      css('&').styles(
        display: Display.flex,
        alignItems: AlignItems.end,
        justifyContent: JustifyContent.spaceBetween,
        gap: Gap.all(2.rem),
        flexWrap: FlexWrap.wrap,
      ),
    ]),
    css('.hero-subtitle', [
      css('&').styles(
        maxWidth: 400.px,
        color: AppColors.textSecondary,
        fontFamily: FontFamily.list([FontFamily('JetBrains Mono'), FontFamilies.monospace]),
        fontSize: 1.125.rem,
        lineHeight: Unit.expression('1.6'),
      ),
    ]),
    css('.hero-actions', [
      css('&').styles(display: Display.flex, gap: Gap.all(2.rem)),
      css('a').styles(
        color: AppColors.textPrimary,
        textDecoration: TextDecoration.none,
        fontFamily: FontFamily.list([FontFamily('Oswald'), FontFamilies.sansSerif]),
        fontWeight: FontWeight.w700,
        fontSize: 1.rem,
        letterSpacing: 1.px,
      ),
      css('a:hover').styles(color: AppColors.primary),
    ]),
  ];
}
