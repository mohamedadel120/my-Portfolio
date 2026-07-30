import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import '../constants/theme.dart';
import '../data/profile_repository.dart';

/// Ported from `HeroDesktopView`. Fetched at build time (server-only,
/// `AsyncStatelessComponent` — see the migration plan's Phase 2 goal) rather
/// than client-side, so the name/title/subtitle are in the static HTML a
/// crawler sees. Entrance animations (staggered fade+slide for the eyebrow/
/// name/footer) and the aurora's slow pulse are plain CSS `@keyframes`
/// instead of the original's `flutter_animate` calls.
class HeroSection extends AsyncStatelessComponent {
  const HeroSection({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final hero = await fetchHeroData();
    // Original's _buildTitleSpans: the word "DEVELOPER" within the eyebrow
    // title (e.g. "FLUTTER DEVELOPER") is colored differently from the rest.
    final titleParts = hero.title.toUpperCase().split('DEVELOPER');

    return section(id: 'hero', classes: 'hero', [
      div(classes: 'hero-aurora', []),
      div(classes: 'hero-content reveal', [
        div(classes: 'hero-eyebrow', [
          span([
            for (final (i, part) in titleParts.indexed) ...[
              if (part.isNotEmpty) .text(part),
              if (i < titleParts.length - 1)
                span(classes: 'hero-title-highlight', [.text('DEVELOPER')]),
            ],
          ]),
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
        // Was bottom-anchored (align-items: end) in a full-viewport-height
        // section, leaving a large stretch of empty space above the content
        // on any screen taller than the content itself. Centering moves the
        // content up into that space instead of leaving it all above.
        alignItems: AlignItems.center,
        minHeight: 100.vh,
        padding: Padding.symmetric(horizontal: 3.75.rem, vertical: 6.25.rem),
        overflow: Overflow.hidden,
      ),
    ]),
    css('.hero-aurora', [
      css('&').styles(
        position: Position.absolute(top: (-150).px, right: (-150).px),
        width: 950.px,
        height: 950.px,
        radius: BorderRadius.circular(50.percent),
        backgroundColor: AppColors.primary.withValues(alpha: 0.12),
        shadow: BoxShadow(offsetX: Unit.zero, offsetY: Unit.zero, blur: 160.px, spread: 40.px, color: AppColors.primary.withValues(alpha: 0.12)),
        // `Animation(count: double.infinity)` serializes to the invalid CSS
        // keyword "infinity" (not "infinite"), silently breaking the whole
        // shorthand -- written out literally instead (see the identical
        // issue/fix in components/project_showcase.dart).
        raw: {'animation': 'auroraPulse 5000ms ease-in-out infinite'},
      ),
    ]),
    css.keyframes('auroraPulse', {
      '0%, 100%': Styles(transform: Transform.scale(1)),
      '50%': Styles(transform: Transform.scale(1.2)),
    }),
    css('.hero-content', [
      // Was capped at 1400px regardless of viewport width -- on a wide
      // desktop screen that left a large stretch of empty space to the
      // right of the name with nothing but a small, mostly off-screen
      // aurora blob in it.
      css('&').styles(position: Position.relative(), zIndex: ZIndex(1), maxWidth: 1800.px, width: 100.percent),
    ]),
    css('.hero-eyebrow', [
      css('&').styles(
        display: Display.flex,
        alignItems: AlignItems.center,
        gap: Gap.all(1.rem),
        margin: Margin.only(bottom: 1.rem),
        opacity: 0,
        raw: {'animation': 'heroFadeSlideX 800ms ease-out both'},
      ),
      css('span').styles(
        color: AppColors.textPrimary,
        fontFamily: FontFamily.list([FontFamily('IBM Plex Mono'), FontFamilies.monospace]),
        fontWeight: FontWeight.w700,
        fontSize: 1.rem,
      ),
      css('.hero-title-highlight').styles(color: AppColors.primary, fontWeight: FontWeight.w500),
      css('.hero-eyebrow-line').styles(width: 40.px, height: 1.px, backgroundColor: AppColors.primary),
      css('.hero-location').styles(
        color: AppColors.textTertiary,
        fontFamily: FontFamily.list([FontFamily('Space Mono'), FontFamilies.monospace]),
        fontWeight: FontWeight.normal,
        fontSize: 0.85.rem,
      ),
    ]),
    css.keyframes('heroFadeSlideX', {
      '0%': Styles(opacity: 0, transform: Transform.translate(x: (-16).px)),
      '100%': Styles(opacity: 1, transform: Transform.translate(x: Unit.zero)),
    }),
    css('.hero-name', [
      css('&').styles(
        fontFamily: FontFamily.list([FontFamily('Orbitron'), FontFamilies.sansSerif]),
        fontSize: Unit.expression('clamp(3rem, 11vw, 18rem)'),
        lineHeight: Unit.expression('0.9'),
        letterSpacing: (-4).px,
        color: AppColors.textPrimary,
        margin: Margin.only(bottom: 3.rem),
        opacity: 0,
        raw: {'animation': 'heroFadeSlideY 1000ms ease-out 200ms both'},
      ),
    ]),
    css.keyframes('heroFadeSlideY', {
      '0%': Styles(opacity: 0, transform: Transform.translate(y: 50.px)),
      '100%': Styles(opacity: 1, transform: Transform.translate(y: Unit.zero)),
    }),
    css('.hero-footer', [
      css('&').styles(
        display: Display.flex,
        alignItems: AlignItems.end,
        justifyContent: JustifyContent.spaceBetween,
        gap: Gap.all(2.rem),
        flexWrap: FlexWrap.wrap,
        opacity: 0,
        raw: {'animation': 'heroFadeSlideYSmall 800ms ease-out 500ms both'},
      ),
    ]),
    css.keyframes('heroFadeSlideYSmall', {
      '0%': Styles(opacity: 0, transform: Transform.translate(y: 30.px)),
      '100%': Styles(opacity: 1, transform: Transform.translate(y: Unit.zero)),
    }),
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
