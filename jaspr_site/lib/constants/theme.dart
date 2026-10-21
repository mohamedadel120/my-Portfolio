import 'package:jaspr/dom.dart';

import 'motion_css.dart';
import 'theme_direction.dart';

export 'theme_direction.dart';

/// Design tokens ported from the Flutter app's `AppColors`
/// (lib/core/constants/app_colors.dart) and `AppTheme`
/// (lib/core/theme/app_theme.dart). Kept as plain Dart constants, same as
/// the Flutter side, just consumed by [Styles] objects instead of a
/// `ThemeData`/`ColorScheme`. Directions a and b (see theme_direction.dart)
/// keep the cyan but put it on slightly blue-tinted, calmer surfaces, and
/// swap the purple second accent for a quiet slate.
class AppColors {
  // Direction c is light: the neon cyan cannot carry text on off-white, so a
  // deep teal of the same family does (about 5:1 on the page colour, 5.4:1 on
  // white; never put it on its own tint). It is also the colour of the light
  // logo (web/images/logo-teal.png), so the brand reads as one colour.
  static const primary = isLight ? Color('#0E7490') : Color('#00D9FF'); // Cyan
  static const secondary = isCalm ? Color('#64748B') : Color('#7B2CBF'); // Purple
  // Lighter purple for text: #7B2CBF on the dark surfaces is only ~2.5:1
  // contrast, below the 4.5:1 WCAG AA minimum for body text.
  static const secondaryText = isLight ? Color('#475569') : isCalm ? Color('#A9B4C2') : Color('#B57BFF');
  // A barely warm off-white: neutral enough that the teal and each app's own
  // colour sit on it without the page turning beige.
  static const background = isLight ? Color('#F6F6F3') : isCalm ? Color('#0B0E13') : Color('#000000');
  static const surface = isLight ? Color('#FFFFFF') : isCalm ? Color('#12161D') : Color('#121212');
  static const surfaceLight = isLight ? Color('#EDEDE8') : isCalm ? Color('#1A1F27') : Color('#1E1E1E');

  static const textPrimary = isLight ? Color('#16171A') : Color('#FFFFFF');
  static const textSecondary = isLight ? Color('#16171AB8') : Color('#FFFFFFB3'); // white70 = 70% alpha
  static const textTertiary = isLight ? Color('#16171A9E') : Color('#FFFFFF8A'); // white54 = 54% alpha

  /// What sits on a [primary] fill (buttons): dark on the cyan, white on the teal.
  static const onPrimary = isLight ? Color('#FFFFFF') : background;

  // Light theme overrides (from AppTheme.lightTheme's ColorScheme.light)
  static const lightSecondary = Color('#424242');
  static const lightSurface = Color('#F5F5F5');
  static const lightSurfaceContainerHighest = Color('#E0E0E0');

  /// The cyan as a glow (shadows, halos). Full strength today; the new
  /// directions keep a faint trace so hover states still read as lifting.
  /// On the light page a glow would look like a smudge, so it becomes a soft
  /// ink shadow that still reads as lifting.
  static Color glow(double alpha) =>
      isLight ? const Color('#16171A').withValues(alpha: alpha * 0.18) : primary.withValues(alpha: alpha * (isCalm ? 0.4 : 1));

  /// A readable version of a project's own colour (`var(--accent)`) for text:
  /// lightened on the dark page, darkened on the light one, so a yellow app
  /// still gives readable text on off-white.
  static const accentText = isLight
      ? 'color-mix(in srgb, var(--accent) 55%, #000000)'
      : 'color-mix(in srgb, var(--accent) 62%, #ffffff)';

  /// A card or field outline: cyan today, a neutral hairline in the new
  /// directions so the accent is left for links, buttons and active states.
  static Color outline(double alpha) => isCalm ? textPrimary.withValues(alpha: 0.1) : primary.withValues(alpha: alpha);
}

/// One Google Fonts family: its name, the generic family it falls back to
/// and the css2 axis spec (only the weights the site uses).
class WebFont {
  final String name;
  final FontFamily generic;
  final String axes;

  const WebFont(this.name, this.generic, [this.axes = '']);

  FontFamily get family => FontFamily.list([FontFamily(name), generic]);

  String get query => 'family=${name.replaceAll(' ', '+')}${axes.isEmpty ? '' : ':$axes'}';
}

/// What a piece of text is for. The new directions choose a family per
/// role; today's look keeps each component's own family (the `was:` value).
enum FontRole {
  /// Paragraphs, form fields, buttons, links: anything read at length.
  text,

  /// Section titles, card titles, names, big numbers.
  heading,

  /// The hero name.
  display,

  /// Small labels, tags, periods, counters.
  accent,
}

/// The families a direction loads and which one each [FontRole] uses.
class DirectionFonts {
  final List<WebFont> loaded;
  final Map<FontRole, WebFont> roles;
  final FontWeight headingWeight;

  const DirectionFonts(this.loaded, this.roles, {this.headingWeight = FontWeight.w700});

  /// One css2 request for every family, `display=swap` so text shows in the
  /// fallback font instead of staying invisible while the files load.
  String get importUrl => 'https://fonts.googleapis.com/css2?${[for (final f in loaded) f.query].join('&')}&display=swap';
}

/// Fonts per direction. Today's look loads seven families (body JetBrains
/// Mono, headings IBM Plex Mono, nav Fira Code, labels Space Mono, hero
/// links Oswald, hero name Orbitron, mobile menu Anton) through the
/// stylesheet's `@import`, instead of the `google_fonts` package's runtime
/// fetch-and-swap. The new directions load two, as variable fonts so every
/// weight in the range comes from one file.
class AppFonts {
  static const jetBrainsMono = WebFont('JetBrains Mono', FontFamilies.monospace, 'wght@400;500;700');
  static const ibmPlexMono = WebFont('IBM Plex Mono', FontFamilies.monospace, 'wght@600;700;900');
  static const firaCode = WebFont('Fira Code', FontFamilies.monospace, 'wght@400;600');
  static const spaceMono = WebFont('Space Mono', FontFamilies.monospace, 'wght@400;700');
  static const oswald = WebFont('Oswald', FontFamilies.sansSerif, 'wght@400;700');
  static const orbitron = WebFont('Orbitron', FontFamilies.sansSerif, 'wght@500;700');
  static const anton = WebFont('Anton', FontFamilies.sansSerif);

  // a: Manrope is a geometric grotesk that stays open and legible at small
  // sizes on dark backgrounds; JetBrains Mono (already the brand's mono)
  // only for the small technical accents.
  static const _manrope = WebFont('Manrope', FontFamilies.sansSerif, 'wght@400..800');
  static const _jetBrainsMonoAccent = WebFont('JetBrains Mono', FontFamilies.monospace, 'wght@400..700');

  // b: Fraunces is a soft, slightly quirky serif that makes the headings feel
  // personal; Inter carries all text and the (uppercase, tracked) labels.
  static const _fraunces = WebFont('Fraunces', FontFamilies.serif, 'wght@400..700');
  static const _inter = WebFont('Inter', FontFamilies.sansSerif, 'wght@400..800');

  // c: Geist is a precise, neutral grotesk in the spirit of product sites;
  // its own mono sets the numbers and tags, so the two read as one family.
  static const _geist = WebFont('Geist', FontFamilies.sansSerif, 'wght@400..800');
  static const _geistMono = WebFont('Geist Mono', FontFamilies.monospace, 'wght@400..600');

  static const byDirection = {
    ThemeDirection.current: DirectionFonts([jetBrainsMono, ibmPlexMono, firaCode, spaceMono, oswald, orbitron, anton], {}),
    ThemeDirection.a: DirectionFonts([_manrope, _jetBrainsMonoAccent], {
      FontRole.text: _manrope,
      FontRole.heading: _manrope,
      FontRole.display: _manrope,
      FontRole.accent: _jetBrainsMonoAccent,
    }),
    ThemeDirection.b: DirectionFonts([_fraunces, _inter], {
      FontRole.text: _inter,
      FontRole.heading: _fraunces,
      FontRole.display: _fraunces,
      FontRole.accent: _inter,
    }, headingWeight: FontWeight.w600),
    ThemeDirection.c: DirectionFonts([_geist, _geistMono], {
      FontRole.text: _geist,
      FontRole.heading: _geist,
      FontRole.display: _geist,
      FontRole.accent: _geistMono,
    }, headingWeight: FontWeight.w600),
  };

  static final active = byDirection[themeDirection]!;

  /// The family for a piece of text: [was] (its family today) in the current
  /// look, the direction's family for [role] otherwise.
  static FontFamily of(FontRole role, {required WebFont was}) => isCalm ? active.roles[role]!.family : was.family;

  static final body = of(FontRole.text, was: jetBrainsMono);
  static final heading = of(FontRole.heading, was: ibmPlexMono);
}

/// The one type scale of the new directions, smallest to largest.
enum TypeStep { label, small, body, lead, h3, h2, title, display }

/// Font sizes. Today's look keeps every component's own size (the `was:`
/// value); the new directions map each piece of text to a [TypeStep].
class AppType {
  static Unit size(TypeStep step, {required Unit was}) => isCalm ? scale(themeDirection, step) : was;

  static Unit scale(ThemeDirection direction, TypeStep step) => switch (step) {
    TypeStep.label => 0.75.rem,
    TypeStep.small => 0.875.rem,
    TypeStep.body => 1.rem,
    TypeStep.lead => 1.125.rem,
    TypeStep.h3 => 1.25.rem,
    TypeStep.h2 => const Unit.expression('clamp(1.5rem, 1.25rem + 1vw, 2rem)'),
    // The serif of direction b carries a larger title and hero name well.
    TypeStep.title => direction == ThemeDirection.b
        ? const Unit.expression('clamp(2.25rem, 1.5rem + 3vw, 3.5rem)')
        : const Unit.expression('clamp(2rem, 1.5rem + 2.5vw, 3rem)'),
    TypeStep.display => direction == ThemeDirection.b
        ? const Unit.expression('clamp(3rem, 1.5rem + 7vw, 8rem)')
        : const Unit.expression('clamp(2.75rem, 1.5rem + 6vw, 7rem)'),
  };
}

/// Same three tiers as `ResponsiveBreakpoints`
/// (lib/core/responsive/responsive_breakpoints.dart), with the previously
/// undefined 1024-1440 gap closed: tablet now explicitly ends where desktop
/// begins, and 1440 is a "wide desktop" refinement tier rather than a second
/// hard boundary.
class Breakpoints {
  static const mobile = 768; // < 768  = mobile
  static const tablet = 1024; // 768-1023 = tablet, >=1024 = desktop
  static const wideDesktop = 1440; // >=1440 = extra spacing/wider layout
}

/// Global, page-wide CSS — the static-site equivalent of `MaterialApp.theme`.
/// Component-local styles live on each component's own `@css` getter.
@css
List<StyleRule> get styles => [
  // The text and icon fonts are NOT imported here: an `@import` holds back
  // the whole page until Google's stylesheet arrives (on a slow phone it was
  // most of the 5 s before anything showed). main.server.dart loads both
  // without blocking instead; see [fontStylesheets].
  // Smooth scrolling is off for visitors who asked for reduced motion (see
  // the MotionRule below), and every scrollbar uses a slim, themed track
  // instead of the browser's default white one.
  css('html').styles(raw: {
    'scroll-behavior': 'smooth',
    'scrollbar-width': 'thin',
    'scrollbar-color': '${themed(AppColors.primary.withValues(alpha: 0.45), calm: AppColors.textPrimary.withValues(alpha: 0.2)).value} ${AppColors.background.value}',
  }),
  MotionRule.reduced([
    css('html').styles(raw: {'scroll-behavior': 'auto'}),
  ]),
  // Backstop against any decorative layer (e.g. the hero aurora) widening
  // the page on phones. `clip` (unlike `hidden`) doesn't create a scroll
  // container, so position: sticky inside the page keeps working.
  css('html, body').styles(raw: {'overflow-x': 'clip'}),
  // No box-sizing reset existed anywhere in the site -- every element
  // defaulted to content-box, so `width`/`height`/`min-height` never
  // actually included padding/border. That silently made `.hero`'s
  // `min-height: 100vh` plus its vertical padding render taller than the
  // viewport (skewing "centered" content upward), and made `.phone-frame`'s
  // specified 280x580 actually render as 300x600. border-box is the
  // standard fix and safe globally: it doesn't change how anything
  // *without* both a size and padding/border renders.
  css('*, *::before, *::after').styles(raw: {'box-sizing': 'border-box'}),
  css('html, body').styles(
    backgroundColor: AppColors.background,
    color: AppColors.textPrimary,
    fontFamily: AppFonts.body,
    margin: .zero,
    minHeight: 100.vh,
    padding: .zero,
  ),
  // The new directions' proportional text gets the usual reading defaults:
  // a comfortable line height and the thinner, crisper dark-mode rendering.
  if (isCalm)
    css('body').styles(
      lineHeight: Unit.expression('1.6'),
      raw: {'-webkit-font-smoothing': 'antialiased', '-moz-osx-font-smoothing': 'grayscale', 'text-rendering': 'optimizeLegibility'},
    ),
  css(':root[data-theme="light"] body').styles(
    backgroundColor: Colors.white,
    color: Colors.black,
  ),
  css('h1, h2, h3, h4, h5, h6').styles(
    fontFamily: AppFonts.heading,
    fontWeight: AppFonts.active.headingWeight,
    margin: .zero,
  ),
  css('.material-symbols-rounded').styles(raw: {
    'font-variation-settings': "'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24",
  }),
  css('section').styles(raw: {'scroll-margin-top': '80px'}),
  css('.section-title', [
    css('&').styles(
      fontFamily: AppFonts.heading,
      fontSize: AppType.size(TypeStep.title, was: Unit.expression('clamp(2.25rem, 5vw, 4rem)')),
      fontWeight: themed(.w800, calm: AppFonts.active.headingWeight),
      letterSpacing: themed((-1).px, calm: lit((-0.02).em, light: (-0.035).em)),
      lineHeight: Unit.expression('1.1'),
      color: AppColors.textPrimary,
      textAlign: TextAlign.center,
    ),
    // Today a wide cyan-to-purple bar; the new directions keep a short,
    // plain cyan mark.
    css('&::after').styles(
      content: '',
      display: .block,
      width: themed(6.25.rem, calm: 2.5.rem),
      height: themed(4.px, calm: 3.px),
      margin: Margin.only(top: themed(1.5.rem, calm: 1.25.rem), left: Unit.auto, right: Unit.auto),
      radius: BorderRadius.circular(2.px),
      raw: {
        'background': themed('linear-gradient(90deg, ${AppColors.primary.value}, ${AppColors.secondary.value})', calm: AppColors.primary.value),
      },
    ),
  ]),
  // Reveal-on-scroll: elements start hidden/offset, then get `.revealed`
  // toggled by IntersectionObserver (components/scroll_reveal.dart) once
  // they enter the viewport. Same visual intent as the Flutter app's
  // per-item `GSAPEnhancedAnimation`/`ScrollTriggeredAnimation` staggers,
  // done here with plain CSS transitions instead of a JS animation library.
  css('.reveal').styles(
    opacity: 0,
    transform: Transform.translate(y: 30.px),
    raw: {'transition': 'opacity 600ms ease-out, transform 600ms ease-out'},
  ),
  css('.reveal.revealed').styles(opacity: 1, transform: Transform.translate(y: 0.px)),
  // Phone layout. Sections used 3.75rem (60px) side padding at every width,
  // which left ~255px of content on a 375px phone, and `1fr` grid tracks /
  // flex items default to `min-width: auto`, so any long word or wide child
  // pushed the whole page wider than the screen (452px at 375px). Reclaim
  // the gutters, let grid/flex children shrink, and wrap long words.
  css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile.px), [
    css('section.about, section.expertise, section.experience, section.projects, section.contact').styles(
      padding: Padding.symmetric(horizontal: 1.25.rem, vertical: 4.rem),
    ),
    css('.nav-bar').styles(padding: Padding.symmetric(horizontal: 1.rem, vertical: 1.rem)),
    css('.about-grid > *, .contact-grid > *, .contact-side > *, .timeline-card, .bento').styles(raw: {'min-width': '0'}),
    css('.timeline-card-header').styles(flexWrap: FlexWrap.wrap),
    css('.timeline-row').styles(gap: Gap.all(1.rem)),
    css('.timeline-card').styles(padding: Padding.all(1.25.rem)),
    css('p, li, h1, h2, h3, h4, dd, dt').styles(raw: {'overflow-wrap': 'break-word'}),
  ]),
];

/// Every Material Symbols icon the site renders. Google Fonts only serves the
/// glyphs listed here (`icon_names`), so an icon missing from this list shows
/// as its name in plain text; test/material_icons_test.dart checks the source
/// for any icon that is used but not listed. Keep it sorted.
const materialIconNames = [
  'architecture', 'arrow_back', 'arrow_forward', 'bolt', 'call', 'chevron_left', 'chevron_right', 'cloud', 'code',
  'design_services', 'download', 'email', 'format_quote', 'link', 'location_on', 'mail', 'pause',
  'people', 'phone_android', 'play_arrow', 'rocket_launch', 'speed', 'stacks', 'star',
];

/// The text fonts of the active direction, in one request (see [AppFonts]).
final googleFontsUrl = AppFonts.active.importUrl;

/// The font stylesheets the page loads, in order: the text fonts, then the
/// icon font (cut down to the icons the site uses at the one size it uses;
/// the full Material Symbols font is about 1.4 MB). main.server.dart links
/// them so they do not block the first paint.
List<String> get fontStylesheets => [googleFontsUrl, materialSymbolsUrl];

/// Optical size 24 and weight 400 only (what `.material-symbols-rounded`
/// asks for), with the FILL axis kept for the filled star.
final materialSymbolsUrl = 'https://fonts.googleapis.com/css2'
    '?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,400,0..1,0'
    '&icon_names=${materialIconNames.join(',')}'
    '&display=block';
