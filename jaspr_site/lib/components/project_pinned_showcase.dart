import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/motion_css.dart';
import '../constants/theme.dart';
import 'pinned_helpers.vm.dart' if (dart.library.js_interop) 'pinned_helpers.web.dart';
import 'project_showcase.vm.dart' if (dart.library.js_interop) 'project_showcase.web.dart';
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
/// project is visible). Typed text is a visual copy: the full text stays in
/// the document for screen readers and search engines. Visitors who asked for
/// reduced motion get no typing, no autoplay and no cross-fades. Tablets and
/// phones get plain stacked cards with the manual gallery instead of a pinned
/// stage.
@client
class ProjectPinnedShowcase extends StatefulComponent {
  final List<Map<String, dynamic>> projects;

  const ProjectPinnedShowcase({super.key, required this.projects});

  @override
  State<ProjectPinnedShowcase> createState() => _ProjectPinnedShowcaseState();

  @css
  static List<StyleRule> get styles => [
    css('.pp', [
      css('&').styles(position: Position.relative(), raw: {'height': 'calc(var(--n) * 85dvh + 100dvh)'}),
    ]),
    css('.pp.pp-narrow', [css('&').styles(raw: {'height': 'auto'})]),
    css('.pp-chrome', [
      css('&').styles(position: Position.sticky(top: Unit.zero), height: Unit.zero, zIndex: ZIndex(5)),
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
        fontFamily: FontFamily.list([AppFonts.body, FontFamilies.monospace]),
        fontSize: 0.75.rem,
        textAlign: TextAlign.right,
        raw: {'transition': 'color 160ms ease'},
      ),
      css('&:focus-visible').styles(raw: {'outline': '2px solid ${AppColors.primary.value}', 'outline-offset': '2px'}),
      css('&[aria-current="true"]').styles(color: AppColors.primary, fontWeight: FontWeight.w700),
    ]),
    RawMediaRule.hoverCapable([
      css('.pp-nav-item:hover').styles(color: AppColors.textPrimary),
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
        fontSize: 0.8.rem,
        raw: {'top': '6rem', 'backdrop-filter': 'blur(6px)'},
      ),
      css('&:focus-visible').styles(raw: {'outline': '2px solid ${AppColors.primary.value}', 'outline-offset': '2px'}),
    ]),
    css('.pp-counter', [
      css('&').styles(
        position: Position.absolute(left: 2.rem),
        color: AppColors.textSecondary,
        fontSize: 0.85.rem,
        raw: {'top': '6.4rem', 'font-variant-numeric': 'tabular-nums', 'white-space': 'nowrap'},
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
          'background': 'radial-gradient(circle at 65% 50%, color-mix(in srgb, var(--accent) 16%, ${AppColors.background.value}) 0%, ${AppColors.background.value} 65%)',
          'transition': 'background 600ms ease',
        },
      ),
    ]),
    // A readable tint of the app's own colour for buttons, progress and focus
    // (the raw colour can be very dark).
    css('.pp-stage, .pp-phone').styles(raw: {'--accent-fg': 'color-mix(in srgb, var(--accent) 62%, #ffffff)'}),
    // Short windows (laptops, browsers with toolbars): tighter type and gaps so
    // the text never needs more room than there is.
    RawMediaRule('(max-height: 820px)', [
      css('.pp-stage').styles(raw: {'padding-top': '6.25rem', 'gap': '2rem'}),
      css('.pp-info').styles(raw: {'gap': '0.65rem'}),
      css('.pp-tech li').styles(raw: {'font-size': '0.72rem', 'padding': '0.2rem 0.55rem'}),
    ]),
    RawMediaRule('(max-height: 680px)', [
      css('.pp-description').styles(raw: {'line-height': '1.5'}),
      css('.pp-stage').styles(raw: {'padding-top': '5.75rem'}),
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
          'max-height': 'calc(100dvh - 8.75rem)',
          'overflow-y': 'auto',
          'scrollbar-width': 'thin',
          'grid-area': '1 / 1',
          'min-width': '0',
          'opacity': '0',
          'visibility': 'hidden',
          'transition': 'opacity 250ms ease, visibility 0s linear 250ms',
        },
      ),
      css('&[data-active="true"]').styles(raw: {'opacity': '1', 'visibility': 'visible', 'transition': 'opacity 250ms ease'}),
    ]),
    css('.pp-title', [
      css('&').styles(
        color: AppColors.textPrimary,
        fontSize: Unit.expression('clamp(1.5rem, min(3.2vw, 5.4dvh), 2.6rem)'),
        lineHeight: Unit.expression('1.12'),
      ),
    ]),
    css('.pp-meta', [css('&').styles(margin: Margin.zero, color: AppColors.textTertiary, fontSize: 0.85.rem)]),
    css('.pp-description', [
      css('&').styles(
        margin: Margin.zero,
        color: AppColors.textSecondary,
        lineHeight: Unit.expression('1.62'),
        maxWidth: Unit.expression('65ch'),
        raw: {'overflow-wrap': 'break-word', 'font-size': 'clamp(0.82rem, 2dvh, 1rem)'},
      ),
    ]),
    // Visually hidden full text, kept for screen readers while the visible
    // copy is being typed.
    css('.pp-sr', [
      css('&').styles(
        position: Position.absolute(),
        width: 1.px,
        height: 1.px,
        overflow: Overflow.hidden,
        raw: {'clip': 'rect(0 0 0 0)', 'clip-path': 'inset(50%)', 'white-space': 'nowrap'},
      ),
    ]),
    // The invisible full-length copy reserves the final height, so the
    // layout does not jump as the typed text grows.
    css('.pp-typed', [css('&').styles(position: Position.relative(), display: Display.block)]),
    css('.pp-typed-ghost', [css('&').styles(raw: {'visibility': 'hidden', 'display': 'block'})]),
    css('.pp-typed-live', [css('&').styles(position: Position.absolute(top: Unit.zero, left: Unit.zero, right: Unit.zero))]),
    css('.pp-caret', [
      css('&').styles(
        display: Display.inlineBlock,
        width: 2.px,
        height: 1.em,
        margin: Margin.only(left: 2.px),
        backgroundColor: AppColors.primary,
        raw: {'vertical-align': 'text-bottom'},
      ),
    ]),
    MotionRule.allowed([
      css('.pp-caret').styles(raw: {'animation': 'ppBlink 900ms steps(1) infinite'}),
      css('.pp-info[data-active="true"] .pp-tech li').styles(raw: {'animation': 'ppIn 320ms cubic-bezier(0.23, 1, 0.32, 1) both', 'animation-delay': 'calc(var(--k) * 45ms + 350ms)'}),
    ]),
    css.keyframes('ppBlink', {
      '0%, 100%': Styles(opacity: 1),
      '50%': Styles(opacity: 0),
    }),
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
        fontSize: 0.78.rem,
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
          'box-shadow': '0 30px 50px -10px rgba(0,0,0,0.5), 0 20px 60px 0 color-mix(in srgb, var(--accent) 45%, transparent)',
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
        raw: {'height': 'var(--h)'},
      ),
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
      css('.pp-btn:hover').styles(raw: {'background-color': 'var(--accent-fg)', 'color': '#000000'}),
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
        cursor: Cursor.pointer,
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

  /// Scroll distance for each project, in viewport heights.
  static const _segmentVh = 0.85;

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

  int _typedTitle = -1; // -1 = show the full text
  int _typedDesc = -1;
  int _typeToken = 0;
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
      _startTyping(_active);
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
      _startTyping(index);
      _restartShots();
    } else if (inView != _inView) {
      setState(() => _inView = inView);
      _restartShots();
    }
  }

  // ---- typing ----

  void _startTyping(int index) {
    _typeToken++;
    if (!_effects) {
      setState(() {
        _typedTitle = -1;
        _typedDesc = -1;
      });
      return;
    }
    setState(() {
      _typedTitle = 0;
      _typedDesc = 0;
    });
    _typeTitle(_typeToken, index);
  }

  void _typeTitle(int token, int index) {
    if (!mounted || token != _typeToken) return;
    final length = _views[index].title.length;
    if (_typedTitle < length) {
      setState(() => _typedTitle++);
      scheduleTimeout(const Duration(milliseconds: 26), () => _typeTitle(token, index));
    } else {
      _typeDescription(token, index);
    }
  }

  void _typeDescription(int token, int index) {
    if (!mounted || token != _typeToken) return;
    final length = _views[index].description.length;
    // About one second however long the description is.
    final step = (length / 55).ceil().clamp(2, 14);
    if (_typedDesc < length) {
      setState(() => _typedDesc = (_typedDesc + step).clamp(0, length));
      scheduleTimeout(const Duration(milliseconds: 18), () => _typeDescription(token, index));
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
                  [.text(view.title)],
                ),
              ]),
          ]),
        ]),
        div(
          classes: 'pp-stage',
          styles: Styles(raw: {'--accent': _views[_active].accentHex}),
          [
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

  /// Text that is typed out while it is the active project's: a hidden copy
  /// reserves the full height, the visible copy grows, and the full text is
  /// always available to assistive technology.
  Component _typed(String full, int typedLength, bool active, {bool showCaret = false}) {
    if (!active || typedLength < 0 || typedLength >= full.length && !showCaret) return .text(full);
    final shown = full.substring(0, typedLength.clamp(0, full.length));
    return span(classes: 'pp-typed', [
      span(classes: 'pp-sr', [.text(full)]),
      span(classes: 'pp-typed-ghost', attributes: {'aria-hidden': 'true'}, [.text(full)]),
      span(classes: 'pp-typed-live', attributes: {'aria-hidden': 'true'}, [
        .text(shown),
        if (showCaret) span(classes: 'pp-caret', []),
      ]),
    ]);
  }

  Component _info(ProjectView view, int index) {
    final active = index == _active;
    final titleTyping = active && _typedTitle >= 0 && _typedTitle < view.title.length;
    final descTyping = active && !titleTyping && _typedDesc >= 0 && _typedDesc < view.description.length;

    return div(
      classes: 'pp-info',
      attributes: {'data-active': '$active', if (!active) 'aria-hidden': 'true'},
      [
        h3(classes: 'pp-title', [_typed(view.title, _typedTitle, active, showCaret: titleTyping)]),
        if (view.downloads.isNotEmpty) p(classes: 'pp-meta', [.text(view.downloads)]),
        FeaturedLabel(view),
        p(classes: 'pp-description', [_typed(view.description, _typedDesc, active, showCaret: descTyping)]),
        if (view.tech.isNotEmpty)
          ul(classes: 'pp-tech', attributes: {'aria-label': 'Technologies'}, [
            for (final (k, item) in view.tech.indexed) li(styles: Styles(raw: {'--k': '$k'}), [.text(item)]),
          ]),
        div(classes: 'pp-links', [
          StoreButtons(view, focusable: active),
          CtaLink(focusable: active),
        ]),
      ],
    );
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
    // Inactive projects keep only their first image in the page (so it is
    // indexed); the active one adds the next screenshot ahead of time.
    final rendered = images.isEmpty ? 0 : (active ? (_reach[index] ?? 0) + 1 : 1);

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
                'loading': index == 0 && j == 0 ? 'eager' : 'lazy',
                'decoding': 'async',
                'draggable': 'false',
              },
            ),
          if (images.isEmpty && view.videoUrl != null)
            video(src: view.videoUrl!, controls: true, muted: true, attributes: const {'playsinline': '', 'preload': 'none'}, []),
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
        div(classes: 'pp-segs', attributes: {'role': 'group', 'aria-label': 'Screenshots'}, [
          for (var i = 0; i < count; i++)
            button(
              classes: 'pp-seg',
              attributes: {'type': 'button', 'aria-label': 'Screenshot ${i + 1} of $count', 'aria-current': i == _shot ? 'true' : 'false', 'data-done': '${i < _shot}'},
              events: {'click': (_) => _goShot(i)},
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
        h3(id: 'pp-card-title-$index', classes: 'pp-title', [.text(view.title)]),
        if (view.downloads.isNotEmpty) p(classes: 'pp-meta', [.text(view.downloads)]),
        if (view.images.isNotEmpty) ShotGalleryView(title: view.title, images: view.images, eagerFirst: index == 0),
        FeaturedLabel(view),
        p(classes: 'pp-description', [.text(view.description)]),
        if (view.tech.isNotEmpty)
          ul(classes: 'pp-tech', attributes: {'aria-label': 'Technologies'}, [
            for (final item in view.tech) li([.text(item)]),
          ]),
        div(classes: 'pp-links', [StoreButtons(view), const CtaLink()]),
      ],
    );
  }
}
