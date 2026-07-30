import 'package:jaspr/dom.dart';

/// Design tokens ported from the Flutter app's `AppColors`
/// (lib/core/constants/app_colors.dart) and `AppTheme`
/// (lib/core/theme/app_theme.dart). Kept as plain Dart constants, same as
/// the Flutter side, just consumed by [Styles] objects instead of a
/// `ThemeData`/`ColorScheme`.
class AppColors {
  static const primary = Color('#00D9FF'); // Cyan
  static const secondary = Color('#7B2CBF'); // Purple
  static const background = Color('#000000');
  static const surface = Color('#121212');
  static const surfaceLight = Color('#1E1E1E');

  static const textPrimary = Color('#FFFFFF');
  static const textSecondary = Color('#FFFFFFB3'); // white70 = 70% alpha
  static const textTertiary = Color('#FFFFFF8A'); // white54 = 54% alpha

  // Light theme overrides (from AppTheme.lightTheme's ColorScheme.light)
  static const lightSecondary = Color('#424242');
  static const lightSurface = Color('#F5F5F5');
  static const lightSurfaceContainerHighest = Color('#E0E0E0');
}

/// Body copy uses JetBrains Mono, headings use IBM Plex Mono — same pairing
/// as `AppTheme._buildTextTheme`. Loaded via real `<link>` tags (see
/// main.server.dart's `Document.head`) instead of the `google_fonts`
/// package's runtime fetch-and-swap.
class AppFonts {
  static const body = FontFamily('JetBrains Mono');
  static const heading = FontFamily('IBM Plex Mono');
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
  css.import(
    'https://fonts.googleapis.com/css2'
    '?family=JetBrains+Mono:wght@400;500;700'
    '&family=IBM+Plex+Mono:wght@600;700;900'
    '&family=Fira+Code:wght@400;600'
    '&family=Space+Mono:wght@400;700'
    '&family=Oswald:wght@400;700'
    '&family=Orbitron:wght@500;700'
    '&family=Anton'
    '&family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20..48,400,0..1,0'
    '&display=swap',
  ),
  css('html').styles(raw: {'scroll-behavior': 'smooth'}),
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
    fontFamily: .list([AppFonts.body, FontFamilies.monospace]),
    margin: .zero,
    minHeight: 100.vh,
    padding: .zero,
  ),
  css(':root[data-theme="light"] body').styles(
    backgroundColor: Colors.white,
    color: Colors.black,
  ),
  css('h1, h2, h3, h4, h5, h6').styles(
    fontFamily: .list([AppFonts.heading, FontFamilies.monospace]),
    fontWeight: .w700,
    margin: .zero,
  ),
  css('.material-symbols-rounded').styles(raw: {
    'font-variation-settings': "'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24",
  }),
  css('section').styles(raw: {'scroll-margin-top': '80px'}),
  css('.section-title', [
    css('&').styles(
      fontFamily: .list([AppFonts.heading, FontFamilies.monospace]),
      fontSize: Unit.expression('clamp(2.25rem, 5vw, 4rem)'),
      fontWeight: .w800,
      letterSpacing: (-1).px,
      lineHeight: Unit.expression('1.1'),
      color: AppColors.textPrimary,
      textAlign: TextAlign.center,
    ),
    css('&::after').styles(
      content: '',
      display: .block,
      width: 6.25.rem,
      height: 4.px,
      margin: Margin.only(top: 1.5.rem, left: Unit.auto, right: Unit.auto),
      radius: BorderRadius.circular(2.px),
      raw: {'background': 'linear-gradient(90deg, ${AppColors.primary.value}, ${AppColors.secondary.value})'},
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
];
