import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import 'project_showcase.vm.dart' if (dart.library.js_interop) 'project_showcase.web.dart';

// Material Symbols has no real Apple/Android brand marks -- these are the
// Simple Icons (simpleicons.org, CC0) single-path glyphs, viewBox 0 0 24 24.
const _appleLogoPath =
    'M12.152 6.896c-.948 0-2.415-1.078-3.96-1.04-2.04.027-3.91 1.183-4.961 '
    '3.014-2.117 3.675-.546 9.103 1.519 12.09 1.013 1.454 2.208 3.09 3.792 '
    '3.039 1.52-.065 2.09-.987 3.935-.987 1.831 0 2.35.987 3.96.948 1.637 '
    '-.026 2.676-1.48 3.676-2.948 1.156-1.688 1.636-3.325 1.662-3.415-.039 '
    '-.013-3.182-1.221-3.22-4.857-.026-3.04 2.48-4.494 2.597-4.559-1.429 '
    '-2.09-3.623-2.324-4.39-2.376-2-.156-3.675 1.09-4.61 1.09zm3.415-3.132c'
    '.843-1.012 1.404-2.427 1.245-3.83-1.207.052-2.662.805-3.532 1.818-.78 '
    '.896-1.454 2.338-1.273 3.714 1.338.104 2.715-.688 3.559-1.701z';
const _androidLogoPath =
    'M17.523 15.34c-.5 0-.906.406-.906.906s.406.906.906.906.906-.406.906'
    '-.906-.406-.906-.906-.906zm-11.046 0c-.5 0-.906.406-.906.906s.406.906'
    '.906.906.906-.406.906-.906-.406-.906-.906-.906zm11.323-6.42l1.809-3.13'
    'a.375.375 0 00-.649-.375l-1.831 3.17A11.045 11.045 0 0012 8.077c-1.85 '
    '0-3.6.37-5.13 1.008L5.038 5.914a.375.375 0 00-.649.375l1.809 3.13A10.245 '
    '10.245 0 001.2 17.523h21.6a10.245 10.245 0 00-4.998-8.603z';
// Simple Icons "Google Play" -- shown in place of the Android robot on hover
// so the button reads as "this is where it links to", not just "this is
// Android".
const _googlePlayPath =
    'M3 20.5v-17c0-.59.34-1.11.84-1.35L13.69 12l-9.85 9.85c-.5-.24-.84-.76'
    '-.84-1.35zm13.81-5.38L6.05 21.34l8.49-8.49 3.27 3.27zm3.35-4.31c.34.27'
    '.59.68.59 1.19s-.22.9-.57 1.18l-2.29 1.32-3.5-3.5 3.5-3.5 2.27 1.31z'
    'M6.05 2.66l10.76 6.22-3.27 3.27-8.49-8.49z';

/// Ported from `StickyProjectShowcase` — a scroll-driven phone mockup that
/// stays pinned while cycling through each project's gallery images/video,
/// with the tech-stack word and left-side info panel advancing in sync.
///
/// The original hand-rolled its own sticky positioning by tracking the
/// element's absolute screen position every scroll frame and clamping a
/// `Transform.translate` offset — real CSS `position: sticky` (used for
/// `.showcase-stage` below) does that natively, so this port only needs
/// scroll math for *which project/image/tech-word is active*, not for
/// keeping the phone glued to the viewport. `@client` because it's the one
/// section that genuinely needs continuous scroll tracking; project data is
/// resolved server-side by ProjectsSection and passed in as plain maps
/// (not the ProjectItem class) since @client constructor params need to be
/// values simple enough for Jaspr to serialize for client hydration.
@client
class StickyProjectShowcase extends StatefulComponent {
  final List<Map<String, dynamic>> projects;

  const StickyProjectShowcase({super.key, required this.projects});

  @override
  State<StickyProjectShowcase> createState() => _StickyProjectShowcaseState();

  @css
  static List<StyleRule> get styles => [
    css('.sticky-showcase', [
      css('&').styles(position: Position.relative()),
    ]),
    css('.showcase-stage', [
      css('&').styles(
        position: Position.sticky(top: Unit.zero),
        height: 100.vh,
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.center,
        overflow: Overflow.hidden,
      ),
    ]),
    css('.showcase-bg', [
      css('&').styles(
        position: Position.absolute(top: Unit.zero, left: Unit.zero, right: Unit.zero, bottom: Unit.zero),
        zIndex: ZIndex(0),
        transition: Transition('background', duration: 800.ms),
        raw: {
          'background': 'radial-gradient(circle at 50% 50%, '
              'color-mix(in srgb, var(--accent) 15%, ${AppColors.background.value}) 0%, '
              '${AppColors.background.value} 70%)',
        },
      ),
    ]),
    css('.showcase-phone', [
      css('&').styles(position: Position.relative(), zIndex: ZIndex(1)),
    ]),
    css('.phone-frame', [
      css('&').styles(
        position: Position.relative(),
        width: 280.px,
        height: 580.px,
        padding: Padding.all(10.px),
        radius: BorderRadius.circular(2.75.rem),
        raw: {
          'background': 'linear-gradient(135deg, #555555 0%, #222222 40%, #111111 60%, #444444 100%)',
          // Black ambient shadow for depth, plus a soft glow tinted with the
          // active project's accent color underneath -- ties the phone
          // mockup into the same per-project color theme as the background
          // gradient and store button hovers instead of sitting on plain
          // black.
          'box-shadow': '0 30px 50px -10px rgba(0,0,0,0.5), '
              '0 20px 60px 0 color-mix(in srgb, var(--accent) 45%, transparent)',
          'transition': 'box-shadow 800ms',
        },
      ),
      // Sized to occupy roughly the same share of viewport height as on
      // desktop (~66%, measured) -- the previous 220x460 only reached ~57%,
      // making the phone feel noticeably less prominent on mobile even
      // though it's the same component playing the same role.
      css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile.px), [
        css('&').styles(width: 260.px, height: 540.px),
      ]),
    ]),
    css('.phone-body', [
      css('&').styles(
        position: Position.relative(),
        width: 100.percent,
        height: 100.percent,
        overflow: Overflow.hidden,
        backgroundColor: Colors.black,
        radius: BorderRadius.circular(2.25.rem),
      ),
    ]),
    css('.phone-screen', [
      css('&').styles(position: Position.absolute(top: Unit.zero, left: Unit.zero, right: Unit.zero, bottom: Unit.zero)),
      // Media starts invisible and only fades in once it actually has pixels
      // to show (`.media-loaded`, toggled on the img `load`/video
      // `loadeddata` event) -- previously this faded in on a fixed timer
      // regardless of whether the network image had actually arrived, so
      // slow-loading images still flashed blank/black underneath it.
      css('img, video').styles(
        width: 100.percent,
        height: 100.percent,
        opacity: 0,
        transition: Transition('opacity', duration: 300.ms),
        raw: {'object-fit': 'cover'},
      ),
      css('img.media-loaded, video.media-loaded').styles(opacity: 1),
    ]),
    css('.phone-loading', [
      css('&').styles(
        position: Position.absolute(top: Unit.zero, left: Unit.zero, right: Unit.zero, bottom: Unit.zero),
        raw: {
          // `Animation(count: double.infinity)` serializes to the invalid
          // CSS keyword "infinity" (not "infinite"), silently breaking the
          // whole shorthand -- write it out literally instead.
          'animation': 'phoneShimmer 1600ms ease-in-out infinite',
          'background': 'linear-gradient(110deg, '
              'color-mix(in srgb, var(--accent) 12%, #000000) 8%, '
              'color-mix(in srgb, var(--accent) 24%, #000000) 18%, '
              'color-mix(in srgb, var(--accent) 12%, #000000) 33%)',
          'background-size': '200% 100%',
        },
      ),
    ]),
    css.keyframes('phoneShimmer', {
      '0%': Styles(raw: {'background-position': '200% 0'}),
      '100%': Styles(raw: {'background-position': '-200% 0'}),
    }),
    // Two arcs chasing each other around a square track (each is a fully
    // rounded box whose visible region is animated via `inset`, tracing the
    // 4 sides in 8 steps) -- an explicit "this is loading" spinner on top of
    // the shimmer tint, since the tint alone read as just a color choice
    // rather than a loading indicator.
    css('.phone-spinner', [
      css('&').styles(
        position: Position.absolute(top: 50.percent, left: 50.percent),
        transform: Transform.translate(x: (-50).percent, y: (-50).percent),
        width: 65.px,
        height: 65.px,
        zIndex: ZIndex(1),
      ),
      css('span').styles(
        position: Position.absolute(),
        radius: BorderRadius.circular(50.px),
        raw: {
          'animation': 'lumaSpin 2500ms linear infinite',
          'box-shadow': 'inset 0 0 0 3px #ffffff',
        },
      ),
      css('span:last-child').styles(raw: {'animation-delay': '-1250ms'}),
    ]),
    // Stop animating (and hide) the loading layer once the sibling media has
    // actually loaded, instead of leaving the spinner spinning forever
    // underneath a now-visible image.
    css('.phone-screen:has(.media-loaded) .phone-loading').styles(display: Display.none),
    css.keyframes('lumaSpin', {
      '0%, 100%': Styles(raw: {'inset': '0 35px 35px 0'}),
      '12.5%': Styles(raw: {'inset': '0 35px 0 0'}),
      '25%': Styles(raw: {'inset': '35px 35px 0 0'}),
      '37.5%': Styles(raw: {'inset': '35px 0 0 0'}),
      '50%': Styles(raw: {'inset': '35px 0 0 35px'}),
      '62.5%': Styles(raw: {'inset': '0 0 0 35px'}),
      '75%': Styles(raw: {'inset': '0 0 35px 35px'}),
      '87.5%': Styles(raw: {'inset': '0 0 35px 0'}),
    }),
    css('.phone-placeholder', [
      css('&').styles(
        width: 100.percent,
        height: 100.percent,
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.center,
        backgroundColor: Color.variable('--accent'),
      ),
      css('span').styles(color: Colors.white.withValues(alpha: 0.5), fontSize: 4.rem),
    ]),
    css('.phone-island', [
      css('&').styles(
        position: Position.absolute(top: 12.px, left: 50.percent),
        transform: Transform.translate(x: (-50).percent),
        width: 90.px,
        height: 26.px,
        backgroundColor: Colors.black,
        radius: BorderRadius.circular(1.rem),
        zIndex: ZIndex(2),
      ),
    ]),
    css('.showcase-info', [
      css('&').styles(
        position: Position.absolute(left: 4.rem, top: 50.percent),
        transform: Transform.translate(y: (-50).percent),
        zIndex: ZIndex(1),
        maxWidth: 26.rem,
      ),
      // Full-width bottom scrim (matching the original's dedicated mobile
      // overlay) instead of just relocating the desktop block -- unshrunk
      // desktop font sizes plus a full, untruncated description made the
      // previous mobile layout massively overflow upward and cover the
      // phone mockup entirely.
      css.media(MediaQuery.screen(maxWidth: Breakpoints.tablet.px), [
        css('&').styles(
          position: Position.absolute(left: Unit.zero, right: Unit.zero, bottom: Unit.zero, top: Unit.expression('auto')),
          transform: Transform.none,
          maxWidth: Unit.expression('none'),
          padding: Padding.only(left: 1.5.rem, right: 1.5.rem, top: 5.rem, bottom: 2.rem),
          raw: {
            'background': 'linear-gradient(to top, rgba(0,0,0,0.85) 0%, '
                'rgba(0,0,0,0.65) 40%, rgba(0,0,0,0.25) 70%, transparent 100%)',
          },
        ),
      ]),
    ]),
    css('.info-title', [
      css('&').styles(
        color: AppColors.textPrimary,
        fontFamily: FontFamily.list([FontFamily('IBM Plex Mono'), FontFamilies.monospace]),
        fontSize: 2.5.rem,
        margin: Margin.only(bottom: 1.25.rem),
      ),
      css('.title-char').styles(
        display: .inlineBlock,
        opacity: 0,
        animation: Animation(name: 'techCharIn', duration: 220.ms, fillMode: AnimationFillMode.both),
      ),
      css('.title-char-space').styles(width: 0.5.rem),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.tablet.px), [
        css('&').styles(fontSize: 1.75.rem, margin: Margin.only(bottom: 0.75.rem)),
      ]),
    ]),
    css('.info-description', [
      css('&').styles(
        color: AppColors.textSecondary,
        fontFamily: FontFamily.list([FontFamily('JetBrains Mono'), FontFamilies.monospace]),
        fontSize: 1.rem,
        lineHeight: Unit.expression('1.6'),
        margin: Margin.only(bottom: 2.5.rem),
      ),
      css('.desc-word').styles(
        display: .inlineBlock,
        opacity: 0,
        animation: Animation(name: 'showcaseFadeIn', duration: 300.ms, fillMode: AnimationFillMode.both),
      ),
      // Truncate instead of overflowing -- the original mobile overlay
      // capped this at 6 lines with an ellipsis for the same reason.
      css.media(MediaQuery.screen(maxWidth: Breakpoints.tablet.px), [
        css('&').styles(
          fontSize: 0.85.rem,
          margin: Margin.only(bottom: 1.5.rem),
          raw: {
            'display': '-webkit-box',
            '-webkit-line-clamp': '5',
            '-webkit-box-orient': 'vertical',
            'overflow': 'hidden',
          },
        ),
      ]),
    ]),
    css('.info-links', [
      css('&').styles(display: Display.flex, gap: Gap.all(1.25.rem)),
      css('.store-btn').styles(
        position: Position.relative(),
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.center,
        width: 3.rem,
        height: 3.rem,
        radius: BorderRadius.circular(50.percent),
        border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.2), width: 1.px),
        color: AppColors.textPrimary,
        raw: {
          'transition': 'transform 200ms ease, background-color 200ms ease, '
              'border-color 200ms ease, box-shadow 200ms ease, color 200ms ease',
        },
      ),
      css('.store-btn:hover').styles(
        backgroundColor: AppColors.primary,
        color: Colors.black,
        border: Border.all(color: AppColors.primary, width: 1.px),
        transform: Transform.scale(1.12),
        raw: {'box-shadow': '0 0 20px 2px ${AppColors.primary.withValues(alpha: 0.5).value}'},
      ),
      // App Store's actual brand colors -- blue gradient fill, white mark --
      // instead of sharing the generic cyan/black hover with the Android
      // button, since that scheme doesn't read as "App Store" at all.
      css('.store-btn-ios:hover').styles(
        color: Colors.white,
        border: Border.all(color: const Color('#2ac0f5'), width: 1.px),
        raw: {
          'background': 'linear-gradient(135deg, #2ac0f5 0%, #1c54f7 100%)',
          'box-shadow': '0 0 20px 2px rgba(42, 192, 245, 0.5)',
        },
      ),
      css('.store-tooltip', [
        css('&').styles(
          position: Position.absolute(bottom: 100.percent, left: 50.percent),
          transform: Transform.translate(x: (-50).percent, y: (-6).px),
          margin: Margin.only(bottom: 0.5.rem),
          padding: Padding.symmetric(horizontal: 0.7.rem, vertical: 0.35.rem),
          radius: BorderRadius.circular(0.4.rem),
          backgroundColor: AppColors.surface,
          color: AppColors.textPrimary,
          fontFamily: FontFamily.list([FontFamily('JetBrains Mono'), FontFamilies.monospace]),
          fontSize: 0.7.rem,
          whiteSpace: WhiteSpace.noWrap,
          opacity: 0,
          zIndex: ZIndex(2),
          raw: {
            'pointer-events': 'none',
            'transition': 'opacity 200ms ease, transform 200ms ease',
            'box-shadow': '0 4px 12px rgba(0,0,0,0.4)',
          },
        ),
      ]),
      css('.store-btn:hover .store-tooltip').styles(
        opacity: 1,
        transform: Transform.translate(x: (-50).percent, y: Unit.zero),
      ),
      css('.store-icon', [
        css('&').styles(
          position: Position.absolute(),
          fontSize: 1.3.rem,
          raw: {'transition': 'opacity 200ms ease, transform 200ms ease'},
        ),
      ]),
      css('.icon-hover').styles(opacity: 0, transform: Transform.scale(0.6)),
      css('.store-btn:hover .icon-default').styles(opacity: 0, transform: Transform.scale(0.6)),
      css('.store-btn:hover .icon-hover').styles(opacity: 1, transform: Transform.scale(1)),
      // The real App Store "A" mark -- two crossed rounded strokes with a
      // heart-shaped flourish where they meet, and a crossbar wider than
      // the strokes with their bottom ends poking out past it. Built from
      // plain CSS shapes (not a hand-drawn SVG path) since this glyph has
      // too much fine detail to safely reproduce as a bezier path from
      // memory -- these proportions were dialed in against a reference
      // image of the actual icon.
      css('.appstore-glyph', [
        css('&').styles(
          // Explicit dead-center positioning instead of the "static
          // position frozen by position:absolute" trick the simpler svg
          // icons rely on -- at this glyph's larger size (2.7rem, vs the
          // other icons' 1.3rem) that trick left it visibly off-center.
          position: Position.absolute(top: 50.percent, left: 50.percent),
          raw: {
            'font-size': '1.8rem',
            'transform': 'translate(-50%, -50%) scale(0.6)',
          },
          width: 1.5.em,
          height: 1.5.em,
        ),
        css('.as-bar').styles(
          position: Position.absolute(),
          radius: BorderRadius.circular(999.px),
          backgroundColor: const Color('currentColor'),
        ),
        // Identical length/width for both legs, mirrored rotation from the
        // same origin point, so they meet symmetrically at the apex. Thick
        // relative to their length for a bold, solid look like the real icon.
        css('.as-bar-left, .as-bar-right').styles(
          position: Position.absolute(left: 0.615.em, top: 0.315.em),
          width: 0.27.em,
          height: 1.185.em,
          raw: {'transform-origin': 'top center'},
        ),
        css('.as-bar-left').styles(raw: {'transform': 'rotate(-36deg)'}),
        css('.as-bar-right').styles(raw: {'transform': 'rotate(36deg)'}),
        css('.as-bar-cross').styles(
          position: Position.absolute(left: 0.1575.em, top: 0.96.em),
          width: 1.185.em,
          height: 0.225.em,
        ),
        css('.as-leaf', [
          css('&').styles(
            position: Position.absolute(left: 0.51.em, top: 0.06.em),
            width: 0.48.em,
            height: 0.3.em,
          ),
          css('&::before, &::after').styles(
            content: '',
            position: Position.absolute(top: Unit.zero),
            width: 0.24.em,
            height: 0.285.em,
            backgroundColor: const Color('currentColor'),
            raw: {'border-radius': '0.165em 0.165em 0.165em 0.015em'},
          ),
          css('&::before').styles(
            position: Position.absolute(left: Unit.zero),
            raw: {'transform': 'rotate(-25deg)'},
          ),
          css('&::after').styles(
            position: Position.absolute(left: 0.12.em),
            raw: {'transform': 'rotate(25deg) scaleX(-1)'},
          ),
        ]),
      ]),
      css('.store-btn:hover .appstore-glyph').styles(
        raw: {'transform': 'translate(-50%, -50%) scale(1)'},
      ),
      css('.coming-soon').styles(
        color: AppColors.textSecondary,
        fontFamily: FontFamily.list([FontFamily('JetBrains Mono'), FontFamilies.monospace]),
        fontSize: 0.85.rem,
        padding: Padding.symmetric(horizontal: 1.rem, vertical: 0.6.rem),
        radius: BorderRadius.circular(1.5.rem),
        border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.2), width: 1.px),
      ),
    ]),
    css('.showcase-tech', [
      css('&').styles(
        // Anchored relative to the phone (not the viewport edge) and
        // left-aligned growing rightward -- matches the original's
        // `_buildRightTech`, which sat in a container left-aligned right
        // next to the phone, while the nav dots lived in their own
        // separate column near the viewport edge. Same vertical band as
        // .showcase-nav, but a different horizontal lane, so long nav
        // labels and the tech word don't compete for the same space.
        position: Position.absolute(top: 50.percent),
        raw: {'left': 'calc(50% + 190px)'},
        transform: Transform.translate(y: (-50).percent),
        zIndex: ZIndex(1),
        textAlign: TextAlign.left,
        maxWidth: 14.rem,
      ),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.tablet.px), [
        css('&').styles(display: Display.none),
      ]),
      css('.tech-label').styles(
        display: Display.block,
        color: AppColors.textSecondary,
        fontFamily: FontFamily.list([FontFamily('JetBrains Mono'), FontFamilies.monospace]),
        fontSize: 0.85.rem,
        letterSpacing: 2.px,
        margin: Margin.only(bottom: 1.25.rem),
      ),
      css('.tech-word').styles(
        display: Display.block,
        color: AppColors.textPrimary,
        fontFamily: FontFamily.list([FontFamily('IBM Plex Mono'), FontFamilies.monospace]),
        fontWeight: FontWeight.w700,
        fontSize: 2.5.rem,
      ),
      css('.tech-cursor').styles(
        display: .inlineBlock,
        width: 3.px,
        height: 2.5.rem,
        margin: Margin.only(left: 4.px),
        backgroundColor: AppColors.primary,
        raw: {
          'vertical-align': 'text-bottom',
          // See the .phone-loading comment -- `count: double.infinity`
          // serializes to the invalid "infinity" keyword, not "infinite".
          'animation': 'techCursorBlink 1000ms step-end infinite',
        },
      ),
    ]),
    css.keyframes('techCharIn', {
      '0%': Styles(opacity: 0, transform: Transform.translate(y: 4.px)),
      '100%': Styles(opacity: 1, transform: Transform.translate(y: 0.px)),
    }),
    css.keyframes('techCursorBlink', {
      '0%, 49%': Styles(opacity: 1),
      '50%, 100%': Styles(opacity: 0),
    }),
    css.keyframes('showcaseFadeIn', {
      '0%': Styles(opacity: 0),
      '100%': Styles(opacity: 1),
    }),
    css('.showcase-nav', [
      css('&').styles(
        position: Position.absolute(right: 1.5.rem, top: 50.percent),
        transform: Transform.translate(y: (-50).percent),
        zIndex: ZIndex(1),
        display: Display.flex,
        flexDirection: FlexDirection.column,
        alignItems: AlignItems.end,
        gap: Gap.all(0.75.rem),
      ),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.tablet.px), [
        css('&').styles(display: Display.none),
      ]),
      css('.nav-dot').styles(
        backgroundColor: Colors.transparent,
        border: Border.none,
        color: AppColors.textSecondary,
        fontFamily: FontFamily.list([FontFamily('Space Mono'), FontFamilies.monospace]),
        fontSize: 0.7.rem,
        letterSpacing: 1.px,
        cursor: Cursor.pointer,
        padding: Padding.symmetric(vertical: 0.25.rem),
        transition: Transition('color', duration: 200.ms),
      ),
      css('.nav-dot.active').styles(color: AppColors.primary, fontWeight: FontWeight.w700),
      css('.nav-dot:hover').styles(color: AppColors.primary),
    ]),
  ];
}

class _StickyProjectShowcaseState extends State<StickyProjectShowcase> {
  static const _rootId = 'sticky-project-showcase';
  static const _introHeight = 1400.0;
  static const _scrollPerImage = 800.0;

  int _activeIndex = 0;
  int _imageIndex = 0;

  // Typewriter for the tech-stack word: scroll picks *which* word should be
  // showing (same progress math as _activeIndex/_imageIndex), then this
  // types that word out one character at a time rather than just swapping
  // text instantly. If scroll moves to a new target word before the current
  // one finishes typing, the in-flight animation is abandoned in favor of
  // the new target (guarded by checking _techTargetIndex in _typeWordTick).
  int _techTargetIndex = 0;
  String _typedTech = '';
  int _typingCharIndex = 0;
  static const _typingSpeed = Duration(milliseconds: 90);

  // Tracks which keyed media elements have actually finished loading, so the
  // phone screen can show a loading indicator instead of a bare black
  // rectangle until each image/video has real pixels to display.
  final Set<String> _loadedKeys = {};

  // The loading indicator only appears if a load takes longer than 500ms
  // (most images are cached/fast enough that it would otherwise just flash
  // on screen for a frame or two, which reads as a glitch rather than a
  // loading state). These track, per key, whether that delay has already
  // been scheduled and whether it has elapsed.
  final Set<String> _loadingScheduled = {};
  final Set<String> _loadingRevealed = {};

  List<Map<String, dynamic>> get _projects => component.projects;

  @override
  void initState() {
    super.initState();
    listenScroll(_recompute);
    // Deferred (zero-duration timer, not a direct call) because
    // _typeWordTick calls setState, and calling setState synchronously
    // during initState -- before the first build has even happened --
    // isn't valid.
    if (_projects.isNotEmpty) {
      scheduleTimeout(Duration.zero, () => _typeWordTick(_activeIndex, _techTargetIndex));
    }
  }

  void _markLoaded(String key) {
    if (_loadedKeys.contains(key)) return;
    setState(() => _loadedKeys.add(key));
  }

  static const _mediaElementId = 'phone-media';

  void _scheduleLoadingReveal(String key) {
    if (_loadedKeys.contains(key) || _loadingScheduled.contains(key)) return;
    _loadingScheduled.add(key);
    // The element may have already finished loading before this Dart code
    // even runs -- the browser starts fetching the SSR'd <img src="..."> the
    // instant it parses the raw HTML, well before the deferred JS bundle
    // downloads and attaches the 'load' listener, so on a fast connection
    // that native event fires and is missed entirely. Check once, in a
    // zero-duration timer so it runs after this build's DOM patch has
    // landed, before falling back to the delayed-spinner/event flow.
    scheduleTimeout(Duration.zero, () {
      if (!mounted || _loadedKeys.contains(key)) return;
      if (isMediaLoaded(_mediaElementId)) {
        _markLoaded(key);
        return;
      }
      scheduleTimeout(const Duration(milliseconds: 500), () {
        if (!mounted || _loadedKeys.contains(key)) return;
        setState(() => _loadingRevealed.add(key));
      });
    });
  }

  bool _shouldShowLoading(String key) => !_loadedKeys.contains(key) && _loadingRevealed.contains(key);

  int _galleryCount(int i) => (_projects[i]['galleryImages'] as List?)?.length ?? 0;

  double _projectHeight(int i) => _introHeight + _galleryCount(i) * _scrollPerImage;

  double get _totalHeight {
    var total = 0.0;
    for (var i = 0; i < _projects.length; i++) {
      total += _projectHeight(i);
    }
    return total;
  }

  void _recompute() {
    if (_projects.isEmpty) return;
    final top = elementOffsetTop(_rootId);
    final relativeScroll = scrollY() - top;

    var index = 0;
    var sum = 0.0;
    var offset = 0.0;
    if (relativeScroll <= 0) {
      index = 0;
      offset = 0;
    } else {
      for (var i = 0; i < _projects.length; i++) {
        final h = _projectHeight(i);
        if (relativeScroll < sum + h) {
          index = i;
          offset = relativeScroll - sum;
          break;
        }
        sum += h;
        if (i == _projects.length - 1) {
          index = i;
          offset = h;
        }
      }
    }

    final galleryCount = _galleryCount(index);
    var imageIndex = 0;
    if (galleryCount > 0 && offset > _introHeight / 2) {
      final imageScroll = offset - _introHeight / 2;
      final totalImageScroll = galleryCount * _scrollPerImage;
      final progress = (imageScroll / totalImageScroll).clamp(0.0, 1.0);
      imageIndex = (progress * galleryCount).floor().clamp(0, galleryCount - 1);
    }

    final tech = (_projects[index]['tech'] as List).cast<String>();
    final projectProgress = (offset / _projectHeight(index)).clamp(0.0, 1.0);
    final techLimit = (projectProgress * tech.length).ceil().clamp(1, tech.length);
    final techIndex = techLimit - 1;

    if (index != _activeIndex || imageIndex != _imageIndex || techIndex != _techTargetIndex) {
      setState(() {
        _activeIndex = index;
        _imageIndex = imageIndex;
      });
      if (techIndex != _techTargetIndex) _startTypingWord(index, techIndex);
    }
  }

  void _startTypingWord(int projectIndex, int techIndex) {
    setState(() {
      _techTargetIndex = techIndex;
      _typedTech = '';
      _typingCharIndex = 0;
    });
    _typeWordTick(projectIndex, techIndex);
  }

  void _typeWordTick(int projectIndex, int techIndex) {
    // Bail if scroll picked a different project or word before this one
    // finished typing -- the newer _startTypingWord call already took over.
    if (!mounted || projectIndex != _activeIndex || techIndex != _techTargetIndex) return;
    final tech = (_projects[projectIndex]['tech'] as List).cast<String>();
    if (techIndex >= tech.length) return;
    final currentText = tech[techIndex];

    if (_typingCharIndex < currentText.length) {
      setState(() {
        _typedTech += currentText[_typingCharIndex];
        _typingCharIndex++;
      });
      scheduleTimeout(_typingSpeed, () => _typeWordTick(projectIndex, techIndex));
    }
  }

  void _scrollToProject(int index) {
    final top = elementOffsetTop(_rootId);
    var target = top;
    for (var i = 0; i < index; i++) {
      target += _projectHeight(i);
    }
    smoothScrollTo(target + 10);
  }

  @override
  Component build(BuildContext context) {
    if (_projects.isEmpty) return div([]);

    final project = _projects[_activeIndex];
    final accent = Color.value((project['color'] as int) & 0xFFFFFF);
    final galleryImages = (project['galleryImages'] as List?)?.cast<String>() ?? const <String>[];
    final videoUrl = project['videoUrl'] as String?;
    final androidUrl = project['androidStoreUrl'] as String?;
    final iosUrl = project['iosStoreUrl'] as String?;

    return div(
      id: _rootId,
      classes: 'sticky-showcase',
      styles: Styles(height: _totalHeight.px),
      [
        div(classes: 'showcase-stage', styles: Styles(raw: {'--accent': accent.value}), [
          div(classes: 'showcase-bg', []),
          div(classes: 'showcase-phone', [
            _buildPhone(project, videoUrl, galleryImages),
          ]),
          div(classes: 'showcase-info', [
            h3(
              key: ValueKey('title-$_activeIndex'),
              classes: 'info-title',
              [
                for (final (i, char) in (project['title'] as String).split('').indexed)
                  span(
                    classes: char == ' ' ? 'title-char title-char-space' : 'title-char',
                    styles: Styles(raw: {'animation-delay': '${i * 35}ms'}),
                    [if (char != ' ') .text(char)],
                  ),
              ],
            ),
            p(
              key: ValueKey('desc-$_activeIndex'),
              classes: 'info-description',
              [
                for (final (i, word) in (project['description'] as String).split(' ').indexed) ...[
                  if (i > 0) .text(' '),
                  span(
                    classes: 'desc-word',
                    styles: Styles(raw: {'animation-delay': '${i * 25}ms'}),
                    [.text(word)],
                  ),
                ],
              ],
            ),
            div(classes: 'info-links', [
              if (androidUrl != null)
                a(href: androidUrl, classes: 'store-btn', [
                  span(classes: 'store-tooltip', [.text('Google Play')]),
                  svg([
                    path(d: _androidLogoPath, fill: const Color('currentColor'), []),
                  ], viewBox: '0 0 24 24', width: 1.3.rem, height: 1.3.rem, classes: 'store-icon icon-default'),
                  svg([
                    path(d: _googlePlayPath, fill: const Color('currentColor'), []),
                  ], viewBox: '0 0 24 24', width: 1.3.rem, height: 1.3.rem, classes: 'store-icon icon-hover'),
                ]),
              if (iosUrl != null)
                // Material Symbols has no "Apple logo" icon (it's Google's
                // icon set) -- a real Apple silhouette reads as an actual
                // logo instead of a generic phone outline.
                a(href: iosUrl, classes: 'store-btn store-btn-ios', [
                  span(classes: 'store-tooltip', [.text('App Store')]),
                  svg([
                    path(d: _appleLogoPath, fill: const Color('currentColor'), []),
                  ], viewBox: '0 0 24 24', width: 1.3.rem, height: 1.3.rem, classes: 'store-icon icon-default'),
                  div(classes: 'store-icon icon-hover appstore-glyph', [
                    div(classes: 'as-bar as-bar-left', []),
                    div(classes: 'as-bar as-bar-right', []),
                    div(classes: 'as-bar as-bar-cross', []),
                    div(classes: 'as-leaf', []),
                  ]),
                ]),
              if (androidUrl == null && iosUrl == null) span(classes: 'coming-soon', [.text('Coming Soon')]),
            ]),
          ]),
          div(classes: 'showcase-tech', [
            span(classes: 'tech-label', [.text('TECHNOLOGIES')]),
            span(classes: 'tech-word', [
              .text(_typedTech),
              span(classes: 'tech-cursor', []),
            ]),
          ]),
          div(classes: 'showcase-nav', [
            for (final (i, p) in _projects.indexed)
              button(
                classes: i == _activeIndex ? 'nav-dot active' : 'nav-dot',
                attributes: const {'type': 'button'},
                events: {'click': (_) => _scrollToProject(i)},
                [.text((p['title'] as String).toUpperCase())],
              ),
          ]),
        ]),
      ],
    );
  }

  Component _buildPhone(Map<String, dynamic> project, String? videoUrl, List<String> galleryImages) {
    Component content;
    var showLoading = false;
    if (videoUrl != null) {
      // Keyed by the URL itself, not a per-project index -- an index like
      // 'img-0' collides across every project's first gallery image, so a
      // previously-loaded project would mark a brand new, still-loading
      // image as already loaded (revealing an empty/transparent element
      // over a shimmer that then never resolves).
      final key = videoUrl;
      _scheduleLoadingReveal(key);
      showLoading = _shouldShowLoading(key);
      content = video(
        id: _mediaElementId,
        key: ValueKey(key),
        src: videoUrl,
        autoplay: true,
        loop: true,
        muted: true,
        classes: _loadedKeys.contains(key) ? 'media-loaded' : null,
        attributes: const {'playsinline': ''},
        events: {'loadeddata': (_) => _markLoaded(key), 'error': (_) => _markLoaded(key)},
        [],
      );
    } else if (galleryImages.isNotEmpty) {
      final safeIndex = _imageIndex.clamp(0, galleryImages.length - 1);
      final key = galleryImages[safeIndex];
      _scheduleLoadingReveal(key);
      showLoading = _shouldShowLoading(key);
      content = img(
        id: _mediaElementId,
        key: ValueKey(key),
        src: galleryImages[safeIndex],
        alt: project['title'] as String,
        classes: _loadedKeys.contains(key) ? 'media-loaded' : null,
        events: {'load': (_) => _markLoaded(key), 'error': (_) => _markLoaded(key)},
      );
    } else {
      content = div(
        key: const ValueKey('placeholder'),
        classes: 'phone-placeholder',
        [span(classes: 'material-symbols-rounded', [.text('stacks')])],
      );
    }

    return div(classes: 'phone-frame', [
      div(classes: 'phone-body', [
        div(classes: 'phone-screen', [
          if (showLoading)
            div(classes: 'phone-loading', [
              div(classes: 'phone-spinner', [span([]), span([])]),
            ]),
          content,
        ]),
        div(classes: 'phone-island', []),
      ]),
    ]);
  }
}
