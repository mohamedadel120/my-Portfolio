import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import '../components/project_view.dart';
import '../constants/home_layout.dart';
import '../constants/motion_css.dart';
import '../constants/theme.dart';
import '../data/profile_repository.dart';
import 'projects_section.dart';

/// Ported from `HeroDesktopView`. Fetched at build time (server-only,
/// `AsyncStatelessComponent` — see the migration plan's Phase 2 goal) rather
/// than client-side, so the name/title/subtitle are in the static HTML a
/// crawler sees. Entrance animations (staggered fade+slide for the eyebrow/
/// name/footer) and the aurora's slow pulse are plain CSS `@keyframes`
/// instead of the original's `flutter_animate` calls.
///
/// The v2 home layout (see constants/home_layout.dart) swaps the giant name
/// for a headline that says what Mohamed builds and proves it; the name moves
/// into the eyebrow line. v1 is today's hero, untouched.
class HeroSection extends AsyncStatelessComponent {
  /// Which home structure this hero belongs to. Defaults to [homeLayout].
  final HomeLayout layout;

  /// The v2 headline option (index into [heroCopies]). Ignored by v1.
  final int copyIndex;

  const HeroSection({super.key, this.layout = homeLayout, this.copyIndex = heroCopyIndex});

  @override
  Future<Component> build(BuildContext context) async {
    final hero = await fetchHeroData();
    // Direction c shows the apps in the hero itself.
    final projects = isLight && layout == HomeLayout.v2 ? await fetchProjectMaps() : const <Map<String, dynamic>>[];
    return content(hero, layout: layout, copyIndex: copyIndex, projects: projects);
  }

  /// The hero markup for [hero]. Public so tests can render every layout and
  /// headline option without a network fetch. [projects] feeds direction c's
  /// phone and proof row; elsewhere it is ignored.
  static Component content(
    HeroData hero, {
    HomeLayout layout = homeLayout,
    int copyIndex = heroCopyIndex,
    List<Map<String, dynamic>> projects = const [],
    bool light = isLight,
  }) {
    return switch (layout) {
      HomeLayout.v1 => _v1(hero),
      HomeLayout.v2 when light => _product(hero, [for (final p in projects) ProjectView.fromMap(p)]),
      HomeLayout.v2 => _v2(hero, heroCopies[copyIndex]),
    };
  }

  /// Direction c: show, don't tell. The headline says what Mohamed builds,
  /// the phone shows the featured app running, and the proof row carries the
  /// numbers (so the headline does not have to). Only confirmed facts.
  static Component _product(HeroData hero, List<ProjectView> projects) {
    final featured = projects.where((p) => p.images.isNotEmpty).firstOrNull;
    // The apps with a real download count, biggest first in the list order.
    final proven = projects.where((p) => p.downloads.contains(RegExp(r'\d'))).take(3).toList();
    // Always four frames for the one CSS cycle; fewer screenshots repeat.
    final shots = featured == null ? const <String>[] : [for (var i = 0; i < 4; i++) featured.images[i % featured.images.length]];

    return section(id: 'hero', classes: 'hero hero-v2 hero-product', [
      div(classes: 'hero-product-grid', [
        div(classes: 'hero-content reveal', [
          div(classes: 'hero-eyebrow', [
            span([.text(hero.name.toUpperCase())]),
            div(classes: 'hero-eyebrow-line', []),
            span(classes: 'hero-location', [.text(hero.title.toUpperCase())]),
          ]),
          h1(classes: 'hero-headline', [.text('Flutter apps people actually download.')]),
          p(classes: 'hero-subtitle', [.text('3+ years shipping Android and iOS apps, from first screen to store listing. Based in Cairo, Egypt.')]),
          div(classes: 'hero-buttons', [
            a(href: '/#projects', classes: 'hero-btn hero-btn-primary', [.text('See the apps')]),
            a(href: '/#contact', classes: 'hero-btn', [.text('Get in touch')]),
          ]),
          if (proven.isNotEmpty)
            div(classes: 'hero-proof-block', [
              p(id: 'hero-proof-label', classes: 'hero-proof-label', [.text('Downloads')]),
              ul(classes: 'hero-proof', attributes: {'aria-labelledby': 'hero-proof-label'}, [
                for (final p in proven)
                  li(styles: Styles(raw: {'--accent': p.accentHex}), [
                    span(classes: 'hero-proof-dot', attributes: {'aria-hidden': 'true'}, []),
                    span(classes: 'hero-proof-name', [.text(_shortName(p.title))]),
                    span(classes: 'hero-proof-count', [.text(p.downloads)]),
                  ]),
              ]),
            ]),
        ]),
        if (featured != null)
          a(
            href: featured.caseStudyPath ?? '/#projects',
            classes: 'hero-device-link',
            styles: Styles(raw: {'--accent': featured.accentHex}),
            // Named by its visible caption; the phone itself is decorative.
            [
              div(classes: 'hero-device', attributes: {'aria-hidden': 'true'}, [
                div(classes: 'hero-island', []),
                div(classes: 'hero-screen', [
                  for (final (i, src) in shots.indexed)
                    img(
                      src: src,
                      alt: '',
                      classes: 'hero-shot',
                      styles: Styles(raw: {'--i': '$i'}),
                      attributes: {'loading': i == 0 ? 'eager' : 'lazy', 'decoding': 'async', if (i == 0) 'fetchpriority': 'high'},
                    ),
                ]),
              ]),
              span(classes: 'hero-device-caption', [
                span(classes: 'hero-proof-dot', attributes: {'aria-hidden': 'true'}, []),
                .text('Read the ${_shortName(featured.title)} case study'),
              ]),
            ],
          ),
      ]),
    ]);
  }

  /// "Gomla Mobile App" reads as "Gomla" in a compact list.
  static String _shortName(String title) => title.replaceAll(RegExp(r'\s*mobile app\s*$', caseSensitive: false), '').trim();

  static Component _v1(HeroData hero) {
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

  static Component _v2(HeroData hero, HeroCopy copy) {
    return section(id: 'hero', classes: 'hero hero-v2', [
      div(classes: 'hero-aurora', []),
      div(classes: 'hero-content reveal', [
        div(classes: 'hero-eyebrow', [
          span([.text(hero.name.toUpperCase())]),
          div(classes: 'hero-eyebrow-line', []),
          span(classes: 'hero-location', [.text('${hero.title.toUpperCase()} · CAIRO, EGYPT')]),
        ]),
        h1(classes: 'hero-headline', [.text(copy.headline)]),
        div(classes: 'hero-footer', [
          p(classes: 'hero-subtitle', [.text(copy.subline)]),
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
        backgroundColor: AppColors.glow(0.12),
        shadow: BoxShadow(offsetX: Unit.zero, offsetY: Unit.zero, blur: 160.px, spread: 40.px, color: AppColors.glow(0.12)),
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
      // Was capped at 1800px -- on a large/ultrawide desktop monitor
      // (2560px+) that still left a big stretch of empty space to the
      // right of the footer links before reaching the true window edge.
      css('&').styles(position: Position.relative(), zIndex: ZIndex(1), maxWidth: 2400.px, width: 100.percent),
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
        fontFamily: AppFonts.of(FontRole.accent, was: AppFonts.ibmPlexMono),
        fontWeight: themed(FontWeight.w700, calm: FontWeight.w600),
        fontSize: AppType.size(TypeStep.small, was: 1.rem),
        letterSpacing: themed(null, calm: 0.08.em),
      ),
      css('.hero-title-highlight').styles(color: AppColors.primary, fontWeight: FontWeight.w500),
      css('.hero-eyebrow-line').styles(width: 40.px, height: 1.px, backgroundColor: AppColors.primary),
      css('.hero-location').styles(
        color: AppColors.textTertiary,
        fontFamily: AppFonts.of(FontRole.accent, was: AppFonts.spaceMono),
        fontWeight: FontWeight.normal,
        fontSize: AppType.size(TypeStep.label, was: 0.85.rem),
      ),
    ]),
    css.keyframes('heroFadeSlideX', {
      '0%': Styles(opacity: 0, transform: Transform.translate(x: (-16).px)),
      '100%': Styles(opacity: 1, transform: Transform.translate(x: Unit.zero)),
    }),
    css('.hero-name', [
      css('&').styles(
        fontFamily: AppFonts.of(FontRole.display, was: AppFonts.orbitron),
        fontSize: AppType.size(TypeStep.display, was: Unit.expression('clamp(3rem, 11vw, 18rem)')),
        lineHeight: themed(Unit.expression('0.9'), calm: Unit.expression('0.95')),
        letterSpacing: themed((-4).px, calm: (-0.03).em),
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
    // v2: a sentence, not a name, so a readable size and line length instead
    // of the name's viewport-filling display type. Same entrance as the name.
    css('.hero-headline', [
      css('&').styles(
        maxWidth: 22.em,
        fontFamily: FontFamily.list([AppFonts.heading, FontFamilies.monospace]),
        fontSize: Unit.expression('clamp(2rem, 5vw, 4.5rem)'),
        fontWeight: FontWeight.w800,
        lineHeight: Unit.expression('1.1'),
        letterSpacing: (-1).px,
        color: AppColors.textPrimary,
        margin: Margin.only(bottom: 3.rem),
        opacity: 0,
        raw: {'animation': 'heroFadeSlideY 1000ms ease-out 200ms both'},
      ),
    ]),
    css('.hero-v2', [
      css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile.px), [
        css('&').styles(padding: Padding.symmetric(horizontal: 1.25.rem, vertical: 6.25.rem)),
      ]),
    ]),
    css('.hero-v2 .hero-subtitle').styles(maxWidth: 520.px),
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
        fontFamily: AppFonts.of(FontRole.text, was: AppFonts.jetBrainsMono),
        fontSize: AppType.size(TypeStep.lead, was: 1.125.rem),
        lineHeight: Unit.expression('1.6'),
      ),
    ]),
    css('.hero-actions', [
      css('&').styles(display: Display.flex, gap: Gap.all(2.rem)),
      css('a').styles(
        color: AppColors.textPrimary,
        textDecoration: TextDecoration.none,
        fontFamily: AppFonts.of(FontRole.text, was: AppFonts.oswald),
        fontWeight: FontWeight.w700,
        fontSize: AppType.size(TypeStep.body, was: 1.rem),
        letterSpacing: themed(1.px, calm: 0.06.em),
        // Vertical padding brings the tap target to ~44px on phones.
        display: Display.inlineBlock,
        padding: Padding.symmetric(vertical: 0.75.rem),
      ),
      css('a:hover').styles(color: AppColors.primary),
    ]),
    ..._productStyles,
  ];

  // Direction c's hero. Rules are prefixed with `.hero-product` so they win
  // over the shared hero rules above without !important.
  static List<StyleRule> get _productStyles => [
    css('.hero-product', [
      css('&').styles(minHeight: Unit.auto, padding: Padding.only(top: 9.rem, bottom: 5.rem, left: 3.75.rem, right: 3.75.rem)),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile.px), [
        css('&').styles(padding: Padding.only(top: 7.rem, bottom: 3.5.rem, left: 1.25.rem, right: 1.25.rem)),
      ]),
    ]),
    css('.hero-product-grid', [
      css('&').styles(
        display: Display.grid,
        alignItems: AlignItems.center,
        width: 100.percent,
        maxWidth: 72.rem,
        margin: Margin.symmetric(horizontal: Unit.auto),
        raw: {'grid-template-columns': 'minmax(0, 1fr) auto', 'gap': '3rem 5rem'},
      ),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.tablet.px), [
        css('&').styles(raw: {'grid-template-columns': 'minmax(0, 1fr)', 'justify-items': 'start'}),
      ]),
    ]),
    css('.hero-product .hero-headline').styles(
      maxWidth: 13.em,
      fontSize: Unit.expression('clamp(2.4rem, 1.4rem + 3.6vw, 4.6rem)'),
      fontWeight: FontWeight.w600,
      lineHeight: Unit.expression('1.02'),
      letterSpacing: (-0.04).em,
      margin: Margin.only(bottom: 1.5.rem),
      raw: {'text-wrap': 'balance'},
    ),
    css('.hero-product .hero-subtitle').styles(
      maxWidth: 34.rem,
      margin: Margin.only(bottom: 2.25.rem),
      opacity: 0,
      raw: {'animation': 'heroFadeSlideYSmall 800ms cubic-bezier(0.23, 1, 0.32, 1) 350ms both'},
    ),
    css('.hero-buttons', [
      css('&').styles(
        display: Display.flex,
        flexWrap: FlexWrap.wrap,
        gap: Gap.all(0.75.rem),
        opacity: 0,
        raw: {'animation': 'heroFadeSlideYSmall 800ms cubic-bezier(0.23, 1, 0.32, 1) 450ms both'},
      ),
    ]),
    css('.hero-btn', [
      css('&').styles(
        display: Display.inlineFlex,
        alignItems: AlignItems.center,
        minHeight: 3.rem,
        padding: Padding.symmetric(horizontal: 1.4.rem),
        radius: BorderRadius.circular(999.px),
        border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.16), width: 1.px),
        color: AppColors.textPrimary,
        backgroundColor: AppColors.surface,
        textDecoration: TextDecoration.none,
        fontWeight: FontWeight.w600,
        fontSize: 1.rem,
        raw: {'transition': 'transform 160ms cubic-bezier(0.23, 1, 0.32, 1), background-color 160ms ease, border-color 160ms ease'},
      ),
      css('&:active').styles(transform: Transform.scale(0.97)),
      css('&:focus-visible').styles(raw: {'outline': '2px solid ${AppColors.primary.value}', 'outline-offset': '3px'}),
    ]),
    css('.hero-btn-primary').styles(
      backgroundColor: AppColors.textPrimary,
      color: AppColors.background,
      border: Border.all(color: AppColors.textPrimary, width: 1.px),
    ),
    RawMediaRule.hoverCapable([
      css('.hero-btn:hover').styles(raw: {'border-color': AppColors.textPrimary.withValues(alpha: 0.4).value}),
      css('.hero-btn-primary:hover').styles(raw: {'background-color': AppColors.primary.value, 'border-color': AppColors.primary.value}),
    ]),
    // The proof: each app's own colour, its name and its download count.
    css('.hero-proof-block').styles(
      margin: Margin.only(top: 2.5.rem),
      opacity: 0,
      raw: {'animation': 'heroFadeSlideYSmall 800ms cubic-bezier(0.23, 1, 0.32, 1) 550ms both'},
    ),
    css('.hero-proof-label').styles(
      margin: Margin.only(bottom: 0.6.rem),
      color: AppColors.textTertiary,
      fontFamily: AppFonts.of(FontRole.accent, was: AppFonts.jetBrainsMono),
      fontSize: 0.75.rem,
      raw: {'letter-spacing': '0.08em', 'text-transform': 'uppercase'},
    ),
    css('.hero-proof', [
      css('&').styles(
        display: Display.flex,
        flexWrap: FlexWrap.wrap,
        gap: Gap.all(0.5.rem),
        margin: Margin.zero,
        padding: Padding.zero,
        listStyle: ListStyle.none,
      ),
      css('li').styles(
        display: Display.inlineFlex,
        alignItems: AlignItems.center,
        gap: Gap.all(0.5.rem),
        padding: Padding.symmetric(horizontal: 0.9.rem, vertical: 0.5.rem),
        radius: BorderRadius.circular(999.px),
        backgroundColor: AppColors.surface,
        border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.08), width: 1.px),
        fontSize: 0.9.rem,
      ),
    ]),
    css('.hero-proof-dot').styles(
      width: 0.6.rem,
      height: 0.6.rem,
      radius: BorderRadius.circular(50.percent),
      raw: {'background': 'var(--accent)', 'flex': '0 0 auto'},
    ),
    css('.hero-proof-name').styles(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
    css('.hero-proof-count').styles(
      color: AppColors.textSecondary,
      fontFamily: AppFonts.of(FontRole.accent, was: AppFonts.jetBrainsMono),
      fontSize: 0.82.rem,
      raw: {'font-variant-numeric': 'tabular-nums'},
    ),
    // The phone: the featured app's screenshots crossfading on their own.
    css('.hero-device-link', [
      css('&').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        alignItems: AlignItems.center,
        gap: Gap.all(1.25.rem),
        textDecoration: TextDecoration.none,
        opacity: 0,
        raw: {'animation': 'heroFadeSlideYSmall 900ms cubic-bezier(0.23, 1, 0.32, 1) 300ms both', 'justify-self': 'center'},
      ),
      css('&:focus-visible').styles(raw: {'outline': '2px solid ${AppColors.primary.value}', 'outline-offset': '6px', 'border-radius': '2rem'}),
    ]),
    css('.hero-device').styles(
      position: Position.relative(),
      width: Unit.expression('clamp(13.5rem, 22vw, 18.5rem)'),
      padding: Padding.all(10.px),
      radius: BorderRadius.circular(3.rem),
      raw: {
        'aspect-ratio': '9 / 19.5',
        'background': 'linear-gradient(145deg, #3a3b3f 0%, #1c1d20 45%, #0f1012 60%, #2e2f33 100%)',
        'box-shadow': '0 50px 80px -35px rgba(22,23,26,0.5), 0 30px 70px -20px color-mix(in srgb, var(--accent) 35%, transparent)',
        'transition': 'transform 260ms cubic-bezier(0.23, 1, 0.32, 1)',
      },
    ),
    css('.hero-island').styles(
      position: Position.absolute(top: 20.px, left: 50.percent),
      width: 5.rem,
      height: 1.5.rem,
      radius: BorderRadius.circular(1.rem),
      backgroundColor: Colors.black,
      zIndex: ZIndex(2),
      raw: {'transform': 'translateX(-50%)'},
    ),
    css('.hero-screen').styles(
      position: Position.relative(),
      width: 100.percent,
      height: 100.percent,
      overflow: Overflow.hidden,
      radius: BorderRadius.circular(2.4.rem),
      backgroundColor: Colors.black,
    ),
    css('.hero-shot').styles(
      position: Position.absolute(top: Unit.zero, left: Unit.zero),
      width: 100.percent,
      height: 100.percent,
      raw: {'object-fit': 'cover', 'opacity': '0'},
    ),
    // Each frame holds for about 3 seconds, then crossfades to the next.
    MotionRule.allowed([
      css('.hero-shot').styles(raw: {'animation': 'heroShot 12s linear infinite', 'animation-delay': 'calc(var(--i) * 3s)'}),
    ]),
    // Reduced motion: the first screenshot, still.
    MotionRule.reduced([
      css('.hero-shot').styles(raw: {'animation': 'none'}),
    ]),
    css('.hero-shot:first-child').styles(raw: {'opacity': '1'}),
    MotionRule.allowed([
      css('.hero-shot:first-child').styles(raw: {'opacity': '0'}),
    ]),
    css.keyframes('heroShot', {
      '0%': Styles(opacity: 0),
      '4%': Styles(opacity: 1),
      '25%': Styles(opacity: 1),
      '29%': Styles(opacity: 0),
      '100%': Styles(opacity: 0),
    }),
    css('.hero-device-caption').styles(
      display: Display.inlineFlex,
      alignItems: AlignItems.center,
      gap: Gap.all(0.5.rem),
      color: AppColors.textSecondary,
      fontSize: 0.9.rem,
      fontWeight: FontWeight.w500,
    ),
    RawMediaRule.hoverCapable([
      css('.hero-device-link:hover .hero-device').styles(raw: {'transform': 'translateY(-4px)'}),
      css('.hero-device-link:hover .hero-device-caption').styles(color: AppColors.textPrimary),
    ]),
  ];
}
