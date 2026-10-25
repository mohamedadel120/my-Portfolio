import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/motion_css.dart';
import '../constants/theme.dart';
import 'shot_gallery.vm.dart' if (dart.library.js_interop) 'shot_gallery.web.dart';

/// Screenshot gallery: the current screenshot is shown large and centred with
/// its neighbours peeking in at the sides. Visitors move through it any way
/// they expect to:
///
/// * the previous / next buttons,
/// * clicking a neighbouring screenshot or a dot,
/// * swiping or dragging sideways,
/// * the Left / Right arrow keys (the gallery is focusable).
///
/// Every image is in the server-rendered HTML, so without JavaScript the
/// first screenshots are still visible and indexable.
class ShotGalleryView extends StatefulComponent {
  final String title;
  final List<String> images;

  /// The gallery is above the fold, so load the first screenshots right away.
  final bool eagerFirst;

  const ShotGalleryView({super.key, required this.title, required this.images, this.eagerFirst = false});

  @override
  State<ShotGalleryView> createState() => _ShotGalleryState();

  @css
  static List<StyleRule> get styles => [
    css('.gal', [
      css('&').styles(
        position: Position.relative(),
        display: Display.flex,
        flexDirection: FlexDirection.column,
        alignItems: AlignItems.center,
        gap: Gap.all(0.5.rem),
        raw: {'--h': '30rem', '--w': 'calc(var(--h) * 9 / 19.5)'},
      ),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile.px), [
        css('&').styles(raw: {'--h': '24rem'}),
      ]),
    ]),
    // Previous button, phone, next button on one row.
    css('.gal-stage', [
      css('&').styles(
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.center,
        gap: Gap.all(1.25.rem),
        maxWidth: 100.percent,
      ),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile.px), [
        css('&').styles(gap: Gap.all(0.6.rem)),
      ]),
    ]),
    // The phone body: dark bezel, accent glow, and a notch.
    css('.gal-device', [
      css('&').styles(
        position: Position.relative(),
        padding: Padding.all(10.px),
        radius: BorderRadius.circular(2.75.rem),
        raw: {
          'flex': '0 0 auto',
          'width': 'calc(var(--w) + 20px)',
          'background': 'linear-gradient(135deg, #555555 0%, #222222 40%, #111111 60%, #444444 100%)',
          'box-shadow': lit(
            '0 30px 50px -10px rgba(0,0,0,0.5), 0 20px 60px 0 color-mix(in srgb, var(--accent, ${AppColors.primary.value}) 40%, transparent)',
            light: '0 40px 70px -30px rgba(22,23,26,0.45), 0 24px 60px -10px color-mix(in srgb, var(--accent, ${AppColors.primary.value}) 28%, transparent)',
          ),
        },
      ),
    ]),
    css('.gal-island', [
      css('&').styles(
        position: Position.absolute(top: 20.px, left: 50.percent),
        width: 5.rem,
        height: 1.6.rem,
        radius: BorderRadius.circular(1.rem),
        backgroundColor: Colors.black,
        zIndex: ZIndex(2),
        raw: {'transform': 'translateX(-50%)', 'pointer-events': 'none'},
      ),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile.px), [
        css('&').styles(width: 4.rem, height: 1.35.rem),
      ]),
    ]),
    // The screen: clips the strip of screenshots so only one shows.
    css('.gal-viewport', [
      css('&').styles(
        overflow: Overflow.hidden,
        radius: BorderRadius.circular(2.25.rem),
        backgroundColor: Colors.black,
        raw: {'touch-action': 'pan-y', 'user-select': 'none', 'height': 'var(--h)', 'cursor': 'grab'},
      ),
      css('&:active').styles(raw: {'cursor': 'grabbing'}),
      css('&:focus-visible').styles(raw: {'outline': '2px solid ${AppColors.primary.value}', 'outline-offset': '3px'}),
    ]),
    css('.gal-track', [
      css('&').styles(
        display: Display.flex,
        height: 100.percent,
        raw: {
          'width': 'max-content',
          'transform': 'translateX(calc(-1 * var(--i) * var(--w)))',
          'transition': 'transform 380ms cubic-bezier(0.23, 1, 0.32, 1)',
        },
      ),
    ]),
    css('.gal-slide', [
      css('&').styles(width: Unit.expression('var(--w)'), height: 100.percent, raw: {'flex': '0 0 auto'}),
      css('img').styles(
        width: 100.percent,
        height: 100.percent,
        raw: {'object-fit': 'cover', 'display': 'block', 'pointer-events': 'none'},
      ),
    ]),
    css('.gal-btn', [
      css('&').styles(
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.center,
        width: 3.rem,
        height: 3.rem,
        padding: Padding.zero,
        radius: BorderRadius.circular(50.percent),
        border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.3), width: 1.px),
        backgroundColor: AppColors.background.withValues(alpha: 0.85),
        color: AppColors.textPrimary,
        cursor: Cursor.pointer,
        raw: {
          'flex': '0 0 auto',
          'transition': 'transform 160ms cubic-bezier(0.23, 1, 0.32, 1), background-color 160ms ease, opacity 160ms ease',
        },
      ),
      css('&:active').styles(transform: Transform.scale(0.94)),
      css('&:focus-visible').styles(raw: {'outline': '2px solid ${AppColors.primary.value}', 'outline-offset': '2px'}),
      // Kept in the layout (so the phone never shifts) but invisible at the ends.
      css('&[disabled]').styles(raw: {'opacity': '0', 'pointer-events': 'none'}),
      // 44 px on phones: the minimum comfortable touch target.
      css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile.px), [
        css('&').styles(width: 2.75.rem, height: 2.75.rem),
      ]),
    ]),
    RawMediaRule.hoverCapable([
      css('.gal-btn:hover').styles(backgroundColor: AppColors.primary, color: AppColors.onPrimary),
    ]),
    css('.gal-footer', [
      css('&').styles(
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.center,
        gap: Gap.all(1.rem),
        margin: Margin.only(top: 0.25.rem),
      ),
    ]),
    css('.gal-dots', [
      css('&').styles(display: Display.flex, alignItems: AlignItems.center, flexWrap: FlexWrap.wrap, justifyContent: JustifyContent.center),
    ]),
    // Each dot is a 36 x 44 px hit area around a small visible mark (it was
    // 32 x 32, small for a thumb).
    css('.gal-dot', [
      css('&').styles(
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.center,
        width: 2.25.rem,
        height: 2.75.rem,
        padding: Padding.zero,
        border: Border.none,
        backgroundColor: Colors.transparent,
        cursor: Cursor.pointer,
      ),
      css('&:focus-visible').styles(raw: {'outline': '2px solid ${AppColors.primary.value}', 'outline-offset': '-2px', 'border-radius': '0.5rem'}),
      // Always 1.5rem wide; the clip shows an 8 px dot, and the current one
      // opens to the full pill. Clipping repaints only, while animating
      // width would re-run layout on every frame.
      css('span').styles(
        width: 1.5.rem,
        height: 0.5.rem,
        radius: BorderRadius.circular(0.25.rem),
        backgroundColor: AppColors.textPrimary.withValues(alpha: 0.3),
        raw: {'clip-path': 'inset(0 0.5rem round 0.25rem)', 'transition': 'clip-path 220ms cubic-bezier(0.23, 1, 0.32, 1), background-color 220ms ease'},
      ),
      css('&[aria-current="true"] span').styles(backgroundColor: AppColors.primary, raw: {'clip-path': 'inset(0 0 round 0.25rem)'}),
    ]),
    css('.gal-count', [
      css('&').styles(
        color: AppColors.textSecondary,
        fontSize: AppType.size(TypeStep.small, was: 0.85.rem),
        raw: {'font-variant-numeric': 'tabular-nums', 'white-space': 'nowrap'},
      ),
    ]),
    // Scrubbable progress bar used when there are too many screenshots for
    // dots. `--p` is the filled share of the track.
    css('.gal-range', [
      css('&').styles(
        height: 2.rem,
        margin: Margin.zero,
        backgroundColor: Colors.transparent,
        cursor: Cursor.pointer,
        raw: {'-webkit-appearance': 'none', 'appearance': 'none', 'width': 'min(16rem, 55vw)', 'flex': '0 1 auto'},
      ),
      css('&:focus-visible').styles(raw: {'outline': '2px solid ${AppColors.primary.value}', 'outline-offset': '2px', 'border-radius': '0.5rem'}),
      css('&::-webkit-slider-runnable-track').styles(
        height: 4.px,
        radius: BorderRadius.circular(2.px),
        raw: {'background': 'linear-gradient(to right, ${AppColors.primary.value} var(--p, 0%), ${AppColors.textPrimary.withValues(alpha: 0.2).value} var(--p, 0%))'},
      ),
      css('&::-moz-range-track').styles(
        height: 4.px,
        radius: BorderRadius.circular(2.px),
        raw: {'background': 'linear-gradient(to right, ${AppColors.primary.value} var(--p, 0%), ${AppColors.textPrimary.withValues(alpha: 0.2).value} var(--p, 0%))'},
      ),
      css('&::-webkit-slider-thumb').styles(
        width: 1.rem,
        height: 1.rem,
        radius: BorderRadius.circular(50.percent),
        border: Border.none,
        backgroundColor: AppColors.primary,
        raw: {'-webkit-appearance': 'none', 'appearance': 'none', 'margin-top': '-6px'},
      ),
      css('&::-moz-range-thumb').styles(
        width: 1.rem,
        height: 1.rem,
        radius: BorderRadius.circular(50.percent),
        border: Border.none,
        backgroundColor: AppColors.primary,
      ),
    ]),
    MotionRule.reduced([
      css('.gal-track, .gal-slide, .gal-dot span, .gal-btn').styles(raw: {'transition': 'none'}),
    ]),
  ];
}

class _ShotGalleryState extends State<ShotGalleryView> {
  static const _swipeDistance = 40.0;

  // Above this many screenshots the dots would wrap onto several rows.
  static const _maxDots = 8;

  int _index = 0;
  double? _dragStartX;

  int get _last => component.images.length - 1;

  void _go(int index) {
    final next = index.clamp(0, _last);
    if (next != _index) setState(() => _index = next);
  }

  void _onKey(dynamic event) {
    switch (keyOf(event)) {
      case 'ArrowLeft':
        _go(_index - 1);
      case 'ArrowRight':
        _go(_index + 1);
      case 'Home':
        _go(0);
      case 'End':
        _go(_last);
    }
  }

  void _onPointerUp(dynamic event) {
    final start = _dragStartX;
    _dragStartX = null;
    if (start == null) return;
    final delta = pointerX(event) - start;
    if (delta <= -_swipeDistance) _go(_index + 1);
    if (delta >= _swipeDistance) _go(_index - 1);
  }


  @override
  Component build(BuildContext context) {
    final images = component.images;
    final title = component.title;
    if (images.isEmpty) return div([]);
    final several = images.length > 1;

    final prev = button(
      classes: 'gal-btn',
      attributes: {'type': 'button', 'aria-label': 'Previous screenshot', if (_index == 0) 'disabled': ''},
      events: {'click': (_) => _go(_index - 1)},
      [span(classes: 'material-symbols-rounded', [.text('chevron_left')])],
    );
    final next = button(
      classes: 'gal-btn',
      attributes: {'type': 'button', 'aria-label': 'Next screenshot', if (_index == _last) 'disabled': ''},
      events: {'click': (_) => _go(_index + 1)},
      [span(classes: 'material-symbols-rounded', [.text('chevron_right')])],
    );

    return div(
      classes: 'gal',
      attributes: {'role': 'group', 'aria-roledescription': 'carousel', 'aria-label': '$title screenshots'},
      [
        div(classes: 'gal-stage', [
          if (several) prev,
          // The phone: the current screenshot is shown on its screen and the
          // others slide in from the sides, like swiping through the app.
          div(classes: 'gal-device', [
            div(classes: 'gal-island', []),
            div(
              classes: 'gal-viewport',
              // A plain div may not carry aria-label; as a group it can.
              attributes: {'tabindex': '0', 'role': 'group', 'aria-label': '$title screenshots. Use the left and right arrow keys to browse.'},
              events: {
                'keydown': _onKey,
                'pointerdown': (e) => _dragStartX = pointerX(e),
                'pointerup': _onPointerUp,
                'pointercancel': (_) => _dragStartX = null,
              },
              [
                div(classes: 'gal-track', styles: Styles(raw: {'--i': '$_index'}), [
                  for (final (i, src) in images.indexed)
                    div(
                      classes: 'gal-slide',
                      // Screenshots other than the current one are hidden from
                      // screen readers so they are not all announced at once.
                      attributes: {'aria-hidden': i == _index ? 'false' : 'true'},
                      [
                        img(
                          src: src,
                          alt: '$title screenshot ${i + 1} of ${images.length}',
                          attributes: {
                            // The current screenshot and its neighbours load
                            // right away so a step never shows an empty
                            // screen; the rest wait until needed.
                            'loading': (i - _index).abs() <= 1 && (component.eagerFirst || _index > 0) ? 'eager' : 'lazy',
                            'decoding': 'async',
                            'draggable': 'false',
                          },
                        ),
                      ],
                    ),
                ]),
              ],
            ),
          ]),
          if (several) next,
        ]),
        if (several)
          div(classes: 'gal-footer', [
            if (images.length > _maxDots)
              // Too many screenshots for dots (they wrap into rows): a
              // scrubbable progress bar instead.
              input(
                classes: 'gal-range',
                type: InputType.range,
                attributes: {
                  'min': '0',
                  'max': '$_last',
                  'step': '1',
                  'value': '$_index',
                  'aria-label': 'Screenshot ${_index + 1} of ${images.length}',
                },
                styles: Styles(raw: {'--p': '${(_index / _last * 100).toStringAsFixed(1)}%'}),
                events: {'input': (e) => _go(inputValue(e) ?? _index)},
              )
            else
              div(classes: 'gal-dots', [
                for (var i = 0; i < images.length; i++)
                  button(
                    classes: 'gal-dot',
                    attributes: {
                      'type': 'button',
                      'aria-label': 'Go to screenshot ${i + 1}',
                      'aria-current': i == _index ? 'true' : 'false',
                    },
                    events: {'click': (_) => _go(i)},
                    [span([])],
                  ),
              ]),
            span(classes: 'gal-count', attributes: {'aria-live': 'polite'}, [.text('${_index + 1} / ${images.length}')]),
          ]),
      ],
    );
  }
}

