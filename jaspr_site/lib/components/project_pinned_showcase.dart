import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/motion_css.dart';
import '../constants/theme.dart';
import 'pinned_helpers.vm.dart' if (dart.library.js_interop) 'pinned_helpers.web.dart';
import 'project_showcase.vm.dart' if (dart.library.js_interop) 'project_showcase.web.dart';
import 'case_study_link.dart';
import 'cta_link.dart';
import 'featured_label.dart';
import 'project_view.dart';
import 'shot_gallery.dart';
import 'store_buttons.dart';

/// V2-E: the section stays pinned on screen. Scrolling does not move the
/// page down the screen; each step of scroll switches to the next project
/// in place: the phone cross-fades to that project's screenshots, which play
/// on their own like a short video (with pause and manual controls), and the
/// title and description are typed out.
///
/// Every project's text is in the server-rendered HTML (only the active
/// project is visible). Visitors who asked for reduced motion get no
/// autoplay and no cross-fades. Tablets and phones get plain stacked cards
/// with the manual gallery instead of a pinned stage.
///
/// Scroll distance per project, in viewport heights. 0.85 made eight
/// projects cost about 7,000 px of scrolling on a desktop.
const _segmentVh = 0.65;

/// Tags shown per project before the rest fold into "+N".
const _maxTags = 6;

@client
class ProjectPinnedShowcase extends StatefulComponent {
  final List<Map<String, dynamic>> projects;

  /// True on the Projects page, where project titles sit right under the
  /// page's h1 and become h2s (h3s under the home page's "Projects" h2).
  final bool standalone;

  const ProjectPinnedShowcase({super.key, required this.projects, this.standalone = false});

  @override
  State<ProjectPinnedShowcase> createState() => _ProjectPinnedShowcaseState();

  @css
  static List<StyleRule> get styles => [
    // `clip` (not `hidden`) keeps the sticky children working while making
    // sure nothing pinned can hang out over the next section.
    css('.pp', [
      css('&').styles(position: Position.relative(), raw: {'height': 'calc(var(--n) * ${(_segmentVh * 100).round()}dvh + 100dvh)', 'overflow': 'clip'}),
    ]),
    css('.pp.pp-narrow', [css('&').styles(raw: {'height': 'auto'})]),
    // The counter, the project list and the skip link: a layer over the whole
    // pinned stage, so they leave the screen together with it. (They used to
    // sit on their own zero-height sticky layer, which stayed pinned for a
    // screen after the stage had scrolled away and floated over the next
    // section.) Being absolutely positioned it takes no grid cell; only its
    // controls take clicks.
    css('.pp-chrome', [
      css('&').styles(
        position: Position.absolute(top: Unit.zero, left: Unit.zero, right: Unit.zero, bottom: Unit.zero),
        zIndex: ZIndex(5),
        raw: {'pointer-events': 'none'},
      ),
      css('& > *').styles(raw: {'pointer-events': 'auto'}),
    ]),
    css('.pp-nav', [
      css('&').styles(
        position: Position.absolute(right: 1.5.rem),
        display: Display.flex,
        flexDirection: FlexDirection.column,
        alignItems: AlignItems.end,
        gap: Gap.all(0.15.rem),
        margin: Margin.zero,
        padding: Padding.zero,
        raw: {'top': '50dvh', 'transform': 'translateY(-50%)', 'list-style': 'none'},
      ),
    ]),
    css('.pp-nav-item', [
      css('&').styles(
        minHeight: 2.rem,
        padding: Padding.symmetric(horizontal: 0.75.rem),
        border: Border.none,
        radius: BorderRadius.circular(0.5.rem),
        backgroundColor: Colors.transparent,
        color: AppColors.textTertiary,
        cursor: Cursor.pointer,
        fontFamily: AppFonts.body,
        fontSize: AppType.size(TypeStep.label, was: 0.75.rem),
        textAlign: TextAlign.right,
        raw: {'transition': 'color 160ms ease'},
      ),
      css('&:focus-visible').styles(raw: {'outline': '2px solid ${AppColors.primary.value}', 'outline-offset': '2px'}),
      css('&[aria-current="true"]').styles(color: AppColors.primary, fontWeight: FontWeight.w700),
    ]),
    RawMediaRule.hoverCapable([
      css('.pp-nav-item:hover').styles(color: AppColors.textPrimary),
    ]),
    // The featured project is marked in the list too.
    css('.pp-nav-star', [
      css('&').styles(
        display: Display.inlineBlock,
        width: 0.9.rem,
        height: 0.9.rem,
        margin: Margin.only(right: 0.35.rem),
        overflow: Overflow.hidden,
        color: AppColors.primary,
        fontSize: 0.9.rem,
        raw: {'line-height': '1', 'vertical-align': '-0.1em', 'font-variation-settings': "'FILL' 1"},
      ),
    ]),
    css('.pp-skip', [
      css('&').styles(
        position: Position.absolute(right: 1.5.rem),
        display: Display.inlineFlex,
        alignItems: AlignItems.center,
        minHeight: 2.5.rem,
        padding: Padding.symmetric(horizontal: 1.rem),
        radius: BorderRadius.circular(0.5.rem),
        border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.25), width: 1.px),
        backgroundColor: AppColors.background.withValues(alpha: 0.8),
        color: AppColors.textPrimary,
        textDecoration: TextDecoration.none,
        fontSize: AppType.size(TypeStep.small, was: 0.8.rem),
        // Below the fixed header (it used to sit half under it).
        raw: {'top': '7.5rem', 'backdrop-filter': 'blur(6px)'},
      ),
      css('&:focus-visible').styles(raw: {'outline': '2px solid ${AppColors.primary.value}', 'outline-offset': '2px'}),
      // A keyboard shortcut: hidden until it receives focus from the Tab key,
      // like any skip link, but still read by screen readers.
      css('&:not(:focus-visible)').styles(raw: {
        'clip-path': 'inset(50%)',
        'width': '1px',
        'height': '1px',
        'min-height': '0',
        'padding': '0',
        'border': '0',
        'overflow': 'hidden',
        'white-space': 'nowrap',
      }),
    ]),
    // Which project out of how many. Only below 1200px, where the project list
    // on the right is hidden (the list already shows it on wider screens), and
    // at the bottom of the stage, clear of the fixed header.
    css('.pp-counter', [
      css('&').styles(
        position: Position.absolute(left: 2.rem, bottom: 1.25.rem),
        display: Display.none,
        color: AppColors.textSecondary,
        fontFamily: themed(null, calm: AppFonts.of(FontRole.accent, was: AppFonts.jetBrainsMono)),
        fontSize: AppType.size(TypeStep.small, was: 0.85.rem),
        raw: {'font-variant-numeric': 'tabular-nums', 'white-space': 'nowrap'},
      ),
    ]),
    // The pinned stage. Information on the left, the phone on the right of it.
    css('.pp-stage', [
      css('&').styles(
        position: Position.sticky(top: Unit.zero),
        display: Display.grid,
        alignItems: AlignItems.center,
        gap: Gap.all(3.rem),
        overflow: Overflow.hidden,
        raw: {
          'height': '100dvh',
          'grid-template-columns': 'minmax(0, 26rem) minmax(0, 1fr)',
          // Clears the fixed navigation bar (about 6.5rem) at any window height.
          'padding': '7rem 12rem 1.5rem 4rem',
          'background': 'radial-gradient(circle at 65% 50%, color-mix(in srgb, var(--accent) ${lit(16, light: 8)}%, ${AppColors.background.value}) 0%, ${AppColors.background.value} 65%)',
          'transition': 'background 600ms ease',
        },
      ),
    ]),
    // A readable tint of the app's own colour for buttons, progress and focus
    // (the raw colour can be very dark).
    css('.pp-stage, .pp-phone').styles(raw: {'--accent-fg': AppColors.accentText}),
    // Short windows (laptops, browsers with toolbars): tighter type and gaps so
    // the text never needs more room than there is.
    RawMediaRule('(max-height: 820px)', [
      css('.pp .pp-stage').styles(raw: {'padding-top': '6.25rem', 'gap': '2rem'}),
      css('.pp .pp-info').styles(raw: {'gap': '0.65rem'}),
      css('.pp .pp-tech li').styles(raw: {'font-size': '0.72rem', 'padding': '0.2rem 0.55rem'}),
    ]),
    // Tablets and small windows (768px to 1199px wide): the project list on
    // the right gives way to the counter, gutters shrink and the phone column
    // takes only the room it needs, so text and phone both fit side by side.
    RawMediaRule('(max-width: 1199px)', [
      css('.pp .pp-nav').styles(display: Display.none),
      css('.pp .pp-stage').styles(raw: {
        'padding': '7rem 2rem 1.5rem 2rem',
        'gap': '1.5rem',
        'grid-template-columns': 'minmax(0, 1fr) auto',
      }),
      css('.pp .pp-media').styles(raw: {'--h': 'min(26rem, 52dvh)'}),
      css('.pp .pp-deck').styles(raw: {'gap': '0.6rem'}),
      css('.pp .pp-btn').styles(raw: {'width': '2.4rem', 'height': '2.4rem'}),
      css('.pp .pp-counter').styles(raw: {'left': '2rem', 'display': 'block'}),
      css('.pp .pp-skip').styles(raw: {'right': '2rem'}),
    ]),
    RawMediaRule('(max-height: 680px)', [
      css('.pp .pp-description').styles(raw: {'line-height': '1.5'}),
      css('.pp .pp-stage').styles(raw: {'padding-top': '5.75rem'}),
    ]),
    // All projects' information sits in one grid cell; only the active one shows.
    css('.pp-infos', [
      css('&').styles(display: Display.grid, raw: {'min-width': '0'}),
    ]),
    css('.pp-info', [
      css('&').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        raw: {
          'gap': 'clamp(0.6rem, 1.7dvh, 1.1rem)',
          // Safety net: if a very long text still does not fit, the column
          // scrolls instead of running under the navigation bar.
          'max-height': 'calc(100dvh - 5.75rem)',
          'overflow-y': 'auto',
          'scrollbar-width': 'thin',
          // A scrolling box clips everything outside it, which cut the store
          // buttons' tooltips off at the left edge. The padding gives them
          // room; the negative margin keeps the text where it was.
          'padding': '2.5rem 0 0.5rem 2.5rem',
          'margin': '-2.5rem 0 -0.5rem -2.5rem',
          'grid-area': '1 / 1',
          'min-width': '0',
          // Switching projects is a short crossfade with a slight rise: the
          // visitor sees it every time they scroll, so it stays quick and
          // never makes the text unreadable (it used to be typed out again,
          // character by character, on every switch).
          'opacity': '0',
          'visibility': 'hidden',
          'transform': 'translateY(8px)',
          'transition': 'opacity 150ms ease-out, transform 150ms ease-out, visibility 0s linear 150ms',
        },
      ),
      css('&[data-active="true"]').styles(raw: {
        'opacity': '1',
        'visibility': 'visible',
        'transform': 'none',
        'transition': 'opacity 220ms cubic-bezier(0.23, 1, 0.32, 1), transform 220ms cubic-bezier(0.23, 1, 0.32, 1)',
      }),
    ]),
    css('.pp-title', [
      css('&').styles(
        color: AppColors.textPrimary,
        fontSize: Unit.expression('clamp(1.5rem, min(3.2vw, 5.4dvh), 2.6rem)'),
        lineHeight: Unit.expression('1.12'),
      ),
    ]),
    css('.pp-meta', [css('&').styles(margin: Margin.zero, color: AppColors.textTertiary, fontSize: AppType.size(TypeStep.small, was: 0.85.rem))]),
    css('.pp-description', [
      css('&').styles(
        margin: Margin.zero,
        color: AppColors.textSecondary,
        lineHeight: Unit.expression('1.62'),
        maxWidth: Unit.expression('65ch'),
        raw: {'overflow-wrap': 'break-word', 'font-size': 'clamp(0.82rem, 2dvh, 1rem)'},
      ),
    ]),
    // In the pinned stage a long description stops at four lines, so the
    // store buttons and the call to action always stay in view; the whole
    // text is one click away on the case study ("Read the case study" sits
    // right under it).
    css('.pp-info .pp-description').styles(raw: {
      'display': '-webkit-box',
      '-webkit-box-orient': 'vertical',
      '-webkit-line-clamp': '4',
      'line-clamp': '4',
      'overflow': 'hidden',
    }),
    // The "+N" chip for tags that did not fit.
    css('.pp-tech li.pp-tech-more').styles(color: AppColors.textSecondary, raw: {'border-style': 'dashed'}),
    // The tags follow the text in a short stagger.
    MotionRule.allowed([
      css('.pp-info[data-active="true"] .pp-tech li').styles(raw: {'animation': 'ppIn 260ms cubic-bezier(0.23, 1, 0.32, 1) both', 'animation-delay': 'calc(var(--k) * 30ms + 120ms)'}),
    ]),
    css.keyframes('ppIn', {
      'from': Styles(opacity: 0, transform: Transform.translate(y: 6.px)),
      'to': Styles(opacity: 1, transform: Transform.translate(y: 0.px)),
    }),
    css('.pp-tech', [
      css('&').styles(display: Display.flex, flexWrap: FlexWrap.wrap, gap: Gap.all(0.45.rem), margin: Margin.zero, padding: Padding.zero, raw: {'list-style': 'none'}),
      css('li').styles(
        padding: Padding.symmetric(horizontal: 0.7.rem, vertical: 0.3.rem),
        radius: BorderRadius.circular(0.5.rem),
        border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.18), width: 1.px),
        color: AppColors.textPrimary,
        fontFamily: themed(null, calm: AppFonts.of(FontRole.accent, was: AppFonts.jetBrainsMono)),
        fontSize: AppType.size(TypeStep.label, was: 0.78.rem),
      ),
    ]),
    // Store buttons (the round originals) and the call to action share a row.
    css('.pp-links', [
      css('&').styles(display: Display.flex, flexWrap: FlexWrap.wrap, alignItems: AlignItems.center, gap: Gap.all(1.rem)),
      css('.info-links').styles(gap: Gap.all(0.85.rem)),
    ]),
    // Phone column.
    css('.pp-media', [
      css('&').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        alignItems: AlignItems.center,
        gap: Gap.all(0.75.rem),
        raw: {'min-width': '0', '--h': 'min(30rem, 54dvh)', '--w': 'calc(var(--h) * 9 / 19.5)'},
      ),
    ]),
    css('.pp-phones', [css('&').styles(display: Display.grid)]),
    css('.pp-phone', [
      css('&').styles(
        position: Position.relative(),
        padding: Padding.all(10.px),
        radius: BorderRadius.circular(2.75.rem),
        raw: {
          'grid-area': '1 / 1',
          'width': 'calc(var(--w) + 20px)',
          'background': 'linear-gradient(135deg, #555555 0%, #222222 40%, #111111 60%, #444444 100%)',
          'box-shadow': lit(
            '0 30px 50px -10px rgba(0,0,0,0.5), 0 20px 60px 0 color-mix(in srgb, var(--accent) 45%, transparent)',
            light: '0 40px 70px -30px rgba(22,23,26,0.45), 0 24px 60px -10px color-mix(in srgb, var(--accent) 30%, transparent)',
          ),
          'opacity': '0',
          'visibility': 'hidden',
          'transform': 'scale(0.96)',
          'transition': 'opacity 400ms ease, transform 400ms cubic-bezier(0.23, 1, 0.32, 1), visibility 0s linear 400ms',
        },
      ),
      css('&[data-active="true"]').styles(raw: {'opacity': '1', 'visibility': 'visible', 'transform': 'scale(1)', 'transition': 'opacity 400ms ease, transform 400ms cubic-bezier(0.23, 1, 0.32, 1)'}),
    ]),
    css('.pp-island', [
      css('&').styles(
        position: Position.absolute(top: 20.px, left: 50.percent),
        width: 5.rem,
        height: 1.6.rem,
        radius: BorderRadius.circular(1.rem),
        backgroundColor: Colors.black,
        zIndex: ZIndex(2),
        raw: {'transform': 'translateX(-50%)', 'pointer-events': 'none'},
      ),
    ]),
    css('.pp-screen', [
      css('&').styles(
        position: Position.relative(),
        overflow: Overflow.hidden,
        radius: BorderRadius.circular(2.25.rem),
        backgroundColor: Colors.black,
        // While a screenshot loads the light look shows a soft tint of the
        // app's colour instead of a black slab.
        raw: {'height': 'var(--h)', if (isLight) 'background': 'color-mix(in srgb, var(--accent) 16%, ${AppColors.surfaceLight.value})'},
      ),
      // A demo video fills the screen; its first frame shows before play.
      css('video').styles(
        position: Position.absolute(top: Unit.zero, left: Unit.zero),
        width: 100.percent,
        height: 100.percent,
        raw: {'object-fit': 'contain', 'background': '#0f1012'},
      ),
    ]),
    // A project with neither screenshots nor a video: an intentional card in
    // the app's colour, not an empty phone.
    css('.pp-empty', [
      css('&').styles(
        position: Position.absolute(top: Unit.zero, left: Unit.zero, right: Unit.zero, bottom: Unit.zero),
        display: Display.flex,
        flexDirection: FlexDirection.column,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.center,
        gap: Gap.all(0.6.rem),
        padding: Padding.all(1.5.rem),
        textAlign: TextAlign.center,
        raw: {'background': 'color-mix(in srgb, var(--accent) 22%, ${AppColors.surface.value})'},
      ),
      css('.pp-empty-icon').styles(
        width: 2.5.rem,
        height: 2.5.rem,
        overflow: Overflow.hidden,
        fontSize: 2.5.rem,
        raw: {'line-height': '1', 'color': 'var(--accent-fg)'},
      ),
      css('.pp-empty-title').styles(margin: Margin.zero, color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 1.05.rem),
      css('.pp-empty-text').styles(margin: Margin.zero, color: AppColors.textSecondary, fontSize: 0.85.rem),
    ]),
    // Screenshots are stacked and cross-fade, like the frames of a video.
    css('.pp-shot', [
      css('&').styles(
        position: Position.absolute(top: Unit.zero, left: Unit.zero),
        width: 100.percent,
        height: 100.percent,
        raw: {'object-fit': 'cover', 'opacity': '0', 'transition': 'opacity 500ms ease'},
      ),
      css('&[data-current="true"]').styles(raw: {'opacity': '1'}),
    ]),
    // Previous / phone / next on one row: the arrows sit beside the phone.
    css('.pp-deck', [
      css('&').styles(display: Display.flex, alignItems: AlignItems.center, justifyContent: JustifyContent.center, gap: Gap.all(1.rem)),
    ]),
    css('.pp-btn', [
      css('&').styles(
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.center,
        width: 2.9.rem,
        height: 2.9.rem,
        padding: Padding.zero,
        radius: BorderRadius.circular(50.percent),
        backgroundColor: AppColors.background.withValues(alpha: 0.6),
        cursor: Cursor.pointer,
        raw: {
          'flex': '0 0 auto',
          'color': 'var(--accent-fg)',
          'border': '1.5px solid color-mix(in srgb, var(--accent-fg) 60%, transparent)',
          'box-shadow': '0 0 18px -4px color-mix(in srgb, var(--accent) 60%, transparent)',
          'transition': 'transform 160ms cubic-bezier(0.23, 1, 0.32, 1), background-color 160ms ease, color 160ms ease',
        },
      ),
      css('&:active').styles(transform: Transform.scale(0.94)),
      css('&:focus-visible').styles(raw: {'outline': '2px solid var(--accent-fg)', 'outline-offset': '3px'}),
    ]),
    RawMediaRule.hoverCapable([
      css('.pp-btn:hover').styles(raw: {'background-color': 'var(--accent-fg)', 'color': lit('#000000', light: '#ffffff')}),
    ]),
    // Tap anywhere on the screen to pause the screenshots; tap again to play.
    css('.pp-tap', [
      css('&').styles(position: Position.absolute(top: Unit.zero, left: Unit.zero, right: Unit.zero, bottom: Unit.zero), zIndex: ZIndex(1), cursor: Cursor.pointer),
    ]),
    css('.pp-paused', [
      css('&').styles(
        position: Position.absolute(top: 45.percent, left: 50.percent),
        zIndex: ZIndex(2),
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.center,
        width: 4.rem,
        height: 4.rem,
        radius: BorderRadius.circular(50.percent),
        backgroundColor: Colors.black.withValues(alpha: 0.55),
        color: Colors.white,
        raw: {'transform': 'translate(-50%, -50%)', 'pointer-events': 'none', 'backdrop-filter': 'blur(4px)'},
      ),
      css('span').styles(fontSize: 2.4.rem),
    ]),
    // Player bar over the bottom of the screen, like a video.
    css('.pp-hud', [
      css('&').styles(
        position: Position.absolute(left: Unit.zero, right: Unit.zero, bottom: Unit.zero),
        zIndex: ZIndex(3),
        display: Display.flex,
        alignItems: AlignItems.center,
        gap: Gap.all(0.45.rem),
        raw: {'padding': '2.2rem 0.8rem 1.1rem', 'background': 'linear-gradient(to top, rgba(0,0,0,0.72), transparent)', 'pointer-events': 'none'},
      ),
    ]),
    css('.pp-hud-btn', [
      css('&').styles(
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.center,
        width: 1.9.rem,
        height: 1.9.rem,
        padding: Padding.zero,
        border: Border.none,
        radius: BorderRadius.circular(50.percent),
        backgroundColor: Colors.white.withValues(alpha: 0.18),
        cursor: Cursor.pointer,
        raw: {'flex': '0 0 auto', 'color': 'var(--accent-fg)', 'pointer-events': 'auto'},
      ),
      css('span').styles(fontSize: 1.2.rem),
      css('&:focus-visible').styles(raw: {'outline': '2px solid var(--accent-fg)', 'outline-offset': '2px'}),
    ]),
    // Story-style progress: one segment per screenshot, the current one fills
    // over the time it is shown.
    css('.pp-segs', [
      css('&').styles(display: Display.flex, alignItems: AlignItems.center, gap: Gap.all(0.2.rem), raw: {'flex': '1 1 0', 'min-width': '0', 'pointer-events': 'auto'}),
    ]),
    css('.pp-seg', [
      css('&').styles(
        position: Position.relative(),
        height: 2.rem,
        padding: Padding.zero,
        border: Border.none,
        backgroundColor: Colors.transparent,
        display: Display.block,
        raw: {'flex': '1 1 0', 'min-width': '0'},
      ),
      css('&:focus-visible').styles(raw: {'outline': '2px solid var(--accent-fg)', 'outline-offset': '1px'}),
      css('&::before').styles(
        content: '',
        position: Position.absolute(left: Unit.zero, right: Unit.zero),
        height: 4.px,
        radius: BorderRadius.circular(2.px),
        backgroundColor: Colors.white.withValues(alpha: 0.32),
        raw: {'top': '50%', 'transform': 'translateY(-50%)'},
      ),
      css('&[data-done="true"]::before').styles(raw: {'background-color': 'var(--accent-fg)'}),
    ]),
    css('.pp-seg-fill', [
      css('&').styles(
        position: Position.absolute(left: Unit.zero),
        height: 4.px,
        radius: BorderRadius.circular(2.px),
        raw: {'background-color': 'var(--accent-fg)', 'top': '50%', 'transform': 'translateY(-50%)', 'width': '0%'},
      ),
      css('&[data-run="true"]').styles(raw: {'animation': 'ppFill var(--ms) linear forwards'}),
      css('&[data-static="true"]').styles(raw: {'width': '100%'}),
    ]),
    css.keyframes('ppFill', {
      'from': Styles(raw: {'width': '0%'}),
      'to': Styles(raw: {'width': '100%'}),
    }),
    css('.pp-count', [
      css('&').styles(color: Colors.white, fontSize: 0.72.rem, raw: {'font-variant-numeric': 'tabular-nums', 'white-space': 'nowrap', 'flex': '0 0 auto'}),
    ]),
    MotionRule.reduced([
      css('.pp-info, .pp-phone, .pp-shot, .pp-stage, .pp-btn').styles(raw: {'transition': 'none'}),
    ]),
    // Tablets and phones: stacked cards, no pinning.
    css('.pp-card', [
      css('&').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        gap: Gap.all(1.25.rem),
        padding: Padding.symmetric(vertical: 2.5.rem),
        raw: {'border-top': '1px solid color-mix(in srgb, var(--accent) 60%, transparent)'},
      ),
      css('.gal').styles(raw: {'--h': '24rem'}),
    ]),
  ];
}

class _ProjectPinnedShowcaseState extends State<ProjectPinnedShowcase> {
  static const _rootId = 'pinned-showcase';

  /// How long each screenshot is shown while playing.
  static const _shotMs = 2200;

  late final List<ProjectView> _views = [for (final p in component.projects) ProjectView.fromMap(p)];

  int _active = 0;
  int _shot = 0;
  bool _playing = true;
  bool _inView = false;
  bool _narrow = false;
  bool _reduce = false;

  /// Highest screenshot index rendered so far for each project, so images are
  /// only added as they are about to be shown.
  final Map<int, int> _reach = {};

  int _shotToken = 0;
  int _cycle = 0;

  bool get _effects => !_reduce && !_narrow;
  int get _n => _views.length;

  @override
  void initState() {
    super.initState();
    _reduce = prefersReducedMotion();
    _narrow = isNarrowScreen();
    listenScroll(_recompute);
    // Deferred: setState must not run before the first build completes.
    scheduleTimeout(Duration.zero, () {
      _recompute();
      _restartShots();
    });
  }

  void _recompute() {
    if (!mounted || _n == 0) return;
    final narrow = isNarrowScreen();
    if (narrow != _narrow) {
      setState(() => _narrow = narrow);
      _restartShots();
      return;
    }
    if (narrow) return;

    final vh = viewportHeight();
    final segment = vh * _segmentVh;
    final relative = scrollY() - elementOffsetTop(_rootId);
    final index = (relative / segment).floor().clamp(0, _n - 1);
    final inView = relative > -vh && relative < segment * _n + vh;

    if (index != _active) {
      setState(() {
        _active = index;
        _shot = 0;
        _inView = inView;
      });
      _restartShots();
    } else if (inView != _inView) {
      setState(() => _inView = inView);
      _restartShots();
    }
  }

  // ---- screenshots ----

  bool get _autoplay => _effects && _playing && _inView;

  /// The screenshots keep playing while the pointer rests on the phone; they
  /// only stop when the visitor taps the screen (or the pause button) and
  /// resume the same way.
  void _togglePlay() {
    if (!_effects) return;
    _playing = !_playing;
    _restartShots();
  }

  void _restartShots() {
    _shotToken++;
    setState(() => _cycle++);
    final images = _views[_active].images;
    if (!_autoplay || images.length < 2) return;
    final token = _shotToken;
    scheduleTimeout(const Duration(milliseconds: _shotMs), () => _advance(token));
  }

  void _advance(int token) {
    if (!mounted || token != _shotToken) return;
    final count = _views[_active].images.length;
    setState(() {
      _shot = (_shot + 1) % count;
      _cycle++;
    });
    scheduleTimeout(const Duration(milliseconds: _shotMs), () => _advance(token));
  }

  void _goShot(int index) {
    setState(() => _shot = index.clamp(0, _views[_active].images.length - 1));
    _restartShots();
  }

  void _stepShot(int delta) {
    final count = _views[_active].images.length;
    if (count < 2) return;
    _goShot((_shot + delta) % count);
  }

  void _goToProject(int index) {
    final vh = viewportHeight();
    smoothScrollTo(elementOffsetTop(_rootId) + index * vh * _segmentVh + 4);
  }

  // ---- build ----

  @override
  Component build(BuildContext context) {
    if (_n == 0) return div([]);

    if (_narrow) {
      return div(classes: 'pp pp-narrow', attributes: {'role': 'region', 'aria-label': 'Projects'}, [
        for (final (i, view) in _views.indexed) _card(view, i),
      ]);
    }

    return div(
      id: _rootId,
      classes: 'pp',
      styles: Styles(raw: {'--n': '$_n'}),
      attributes: {'role': 'region', 'aria-label': 'Projects'},
      [
        div(
          classes: 'pp-stage',
          styles: Styles(raw: {'--accent': _views[_active].accentHex}),
          [
            // Inside the pinned stage so the counter, list and skip link
            // arrive and leave together with it.
            div(classes: 'pp-chrome', [
              a(href: '#contact', classes: 'pp-skip', [.text('Skip to contact')]),
              span(classes: 'pp-counter', attributes: {'aria-hidden': 'true'}, [.text('Project ${_active + 1} / $_n')]),
              ul(classes: 'pp-nav', attributes: {'aria-label': 'Jump to project'}, [
                for (final (i, view) in _views.indexed)
                  li([
                    button(
                      classes: 'pp-nav-item',
                      attributes: {'type': 'button', 'aria-current': i == _active ? 'true' : 'false'},
                      events: {'click': (_) => _goToProject(i)},
                      [
                        if (view.featured)
                          span(classes: 'material-symbols-rounded pp-nav-star', attributes: {'aria-hidden': 'true'}, [.text('star')]),
                        .text(view.title),
                      ],
                    ),
                  ]),
              ]),
            ]),
            div(classes: 'pp-infos', [for (final (i, view) in _views.indexed) _info(view, i)]),
            div(classes: 'pp-media', [
              div(classes: 'pp-deck', [
                if (_views[_active].images.length > 1) _arrow(-1),
                div(classes: 'pp-phones', [for (final (i, view) in _views.indexed) _phone(view, i)]),
                if (_views[_active].images.length > 1) _arrow(1),
              ]),
            ]),
          ],
        ),
      ],
    );
  }

  // h2 on the Projects page (under its h1), h3 on the home page.
  Component _title(String text, {String? id}) => component.standalone
      ? h2(id: id, classes: 'pp-title', attributes: const {'dir': 'auto'}, [.text(text)])
      : h3(id: id, classes: 'pp-title', attributes: const {'dir': 'auto'}, [.text(text)]);

  Component _info(ProjectView view, int index) {
    final active = index == _active;

    return div(
      classes: 'pp-info',
      attributes: {'data-active': '$active', if (!active) 'aria-hidden': 'true'},
      [
        // dir="auto": an Arabic title or description lays out right to left.
        _title(view.title),
        if (view.downloads.isNotEmpty) p(classes: 'pp-meta', [.text(view.downloads)]),
        FeaturedLabel(view),
        p(classes: 'pp-description', attributes: const {'dir': 'auto'}, [.text(view.description)]),
        CaseStudyLink(view, focusable: active),
        if (view.tech.isNotEmpty) techList(view.tech),
        div(classes: 'pp-links', [
          StoreButtons(view, focusable: active),
          CtaLink(focusable: active),
        ]),
      ],
    );
  }

  /// The first [_maxTags] technologies, then one "+N" chip whose tooltip and
  /// accessible name list the rest (the case study shows them all).
  static Component techList(List<String> tech) {
    final shown = tech.take(_maxTags).toList();
    final rest = tech.skip(_maxTags).toList();
    return ul(classes: 'pp-tech', attributes: {'aria-label': 'Technologies'}, [
      for (final (k, item) in shown.indexed) li(styles: Styles(raw: {'--k': '$k'}), [.text(item)]),
      if (rest.isNotEmpty)
        li(
          classes: 'pp-tech-more',
          styles: Styles(raw: {'--k': '${shown.length}'}),
          attributes: {'title': rest.join(', '), 'aria-label': 'and ${rest.length} more: ${rest.join(', ')}'},
          [.text('+${rest.length}')],
        ),
    ]);
  }

  Component _phone(ProjectView view, int index) {
    final active = index == _active;
    final images = view.images;
    final current = active ? _shot.clamp(0, images.isEmpty ? 0 : images.length - 1) : 0;
    if (active && images.isNotEmpty) {
      final previous = _reach[index] ?? 0;
      final needed = (current + 1).clamp(0, images.length - 1);
      if (needed > previous) _reach[index] = needed;
    }
    // The active project adds the next screenshot ahead of time; its two
    // neighbours keep their first one ready so a project switch never shows
    // an empty screen. Projects further away render no image yet: all the
    // phones sit stacked in view, so `loading="lazy"` cannot hold them back,
    // and on a phone they all downloaded before anything else (some are
    // multi-megabyte PNGs). Every screenshot stays indexable on the case
    // study pages.
    final near = (index - _active).abs() <= 1;
    final rendered = images.isEmpty ? 0 : (active ? (_reach[index] ?? 0) + 1 : (near ? 1 : 0));

    return div(
      classes: 'pp-phone',
      styles: Styles(raw: {'--accent': view.accentHex}),
      attributes: {'data-active': '$active', if (!active) 'aria-hidden': 'true'},
      [
        div(classes: 'pp-island', []),
        div(classes: 'pp-screen', [
          for (var j = 0; j < rendered; j++)
            img(
              src: images[j],
              alt: '${view.title} screenshot ${j + 1} of ${images.length}',
              classes: 'pp-shot',
              attributes: {
                'data-current': '${active && j == current}',
                // Below the hero on every layout now, so nothing here is
                // needed for the first screen.
                'loading': 'lazy',
                'decoding': 'async',
                'draggable': 'false',
              },
            ),
          // `#t=0.1` with metadata preload shows the video's first frame
          // instead of a black box until play.
          if (images.isEmpty && view.videoUrl != null)
            video(src: '${view.videoUrl!}#t=0.1', controls: true, muted: true, attributes: {'playsinline': '', 'preload': 'metadata', 'aria-label': '${view.title} demo video'}, []),
          if (images.isEmpty && view.videoUrl == null)
            div(classes: 'pp-empty', [
              span(classes: 'material-symbols-rounded pp-empty-icon', attributes: {'aria-hidden': 'true'}, [.text('phone_android')]),
              p(classes: 'pp-empty-title', [.text(view.title)]),
              p(classes: 'pp-empty-text', [.text('No screenshots yet')]),
            ]),
          if (active && images.length > 1) ...[
            // Mouse and touch convenience only: the pause button below is the
            // keyboard- and screen-reader-accessible control.
            if (_effects) div(classes: 'pp-tap', attributes: {'aria-hidden': 'true'}, events: {'click': (_) => _togglePlay()}, []),
            if (_effects && !_playing)
              div(classes: 'pp-paused', attributes: {'aria-hidden': 'true'}, [span(classes: 'material-symbols-rounded', [.text('play_arrow')])]),
            _controls(view),
          ],
        ]),
      ],
    );
  }

  Component _arrow(int delta) {
    return button(
      classes: 'pp-btn',
      attributes: {'type': 'button', 'aria-label': delta < 0 ? 'Previous screenshot' : 'Next screenshot'},
      events: {'click': (_) => _stepShot(delta)},
      [span(classes: 'material-symbols-rounded', [.text(delta < 0 ? 'chevron_left' : 'chevron_right')])],
    );
  }

  /// The player bar over the bottom of the screen: pause / play, one segment
  /// per screenshot (or a position bar when there are many) and the count.
  Component _controls(ProjectView view) {
    final count = view.images.length;
    final useSegments = count <= 12;

    return div(classes: 'pp-hud', [
      if (_effects)
        button(
          classes: 'pp-hud-btn',
          attributes: {'type': 'button', 'aria-label': _playing ? 'Pause screenshots' : 'Play screenshots', 'aria-pressed': '${!_playing}'},
          events: {'click': (_) => _togglePlay()},
          [span(classes: 'material-symbols-rounded', [.text(_playing ? 'pause' : 'play_arrow')])],
        ),
      if (useSegments)
        // Progress only: the segments are too small to be reliable touch
        // targets, so stepping is done with the arrows beside the phone (and
        // the count reads out the position).
        div(classes: 'pp-segs', attributes: {'aria-hidden': 'true'}, [
          for (var i = 0; i < count; i++)
            span(
              classes: 'pp-seg',
              attributes: {'data-done': '${i < _shot}'},
              [
                if (i == _shot)
                  span(
                    key: ValueKey('fill-$_active-$_cycle'),
                    classes: 'pp-seg-fill',
                    styles: Styles(raw: {'--ms': '${_shotMs}ms'}),
                    attributes: {'data-run': '$_autoplay', 'data-static': '${!_autoplay}'},
                    [],
                  ),
              ],
            ),
        ])
      else
        // Too many screenshots for segments: a simple position bar.
        div(classes: 'pp-segs', [
          div(classes: 'pp-seg', attributes: {'aria-hidden': 'true'}, [
            span(classes: 'pp-seg-fill', styles: Styles(raw: {'width': '${((_shot + 1) / count * 100).toStringAsFixed(1)}%'}), []),
          ]),
        ]),
      span(classes: 'pp-count', attributes: {'aria-live': 'off'}, [.text('${_shot + 1} / $count')]),
    ]);
  }

  /// Phones and tablets: the project as a plain card with the manual gallery.
  Component _card(ProjectView view, int index) {
    return section(
      classes: 'pp-card',
      styles: Styles(raw: {'--accent': view.accentHex}),
      attributes: {'aria-labelledby': 'pp-card-title-$index'},
      [
        _title(view.title, id: 'pp-card-title-$index'),
        if (view.downloads.isNotEmpty) p(classes: 'pp-meta', [.text(view.downloads)]),
        if (view.images.isNotEmpty) ShotGalleryView(title: view.title, images: view.images, eagerFirst: index == 0),
        FeaturedLabel(view),
        p(classes: 'pp-description', attributes: const {'dir': 'auto'}, [.text(view.description)]),
        CaseStudyLink(view),
        if (view.tech.isNotEmpty) _ProjectPinnedShowcaseState.techList(view.tech),
        div(classes: 'pp-links', [StoreButtons(view), const CtaLink()]),
      ],
    );
  }
}
