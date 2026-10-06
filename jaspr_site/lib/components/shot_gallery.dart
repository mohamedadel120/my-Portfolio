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
        raw: {'--h': '30rem', '--w': 'calc(var(--h) * 9 / 19.5)', '--gap': '1.25rem'},
      ),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile.px), [
        css('&').styles(raw: {'--h': '24rem', '--gap': '0.9rem'}),
      ]),
    ]),
    css('.gal-viewport', [
      css('&').styles(
        overflow: Overflow.hidden,
        padding: Padding.symmetric(vertical: 1.rem),
        raw: {
          'touch-action': 'pan-y',
          'user-select': 'none',
          '-webkit-mask-image': 'linear-gradient(to right, transparent, #000 10%, #000 90%, transparent)',
          'mask-image': 'linear-gradient(to right, transparent, #000 10%, #000 90%, transparent)',
        },
      ),
      css('&:focus-visible').styles(raw: {'outline': '2px solid ${AppColors.primary.value}', 'outline-offset': '2px'}),
    ]),
    // The track is as wide as all slides; `margin-left: 50%` puts its left
    // edge at the viewport centre and the translate pulls the current slide
    // back so it sits exactly in the middle.
    css('.gal-track', [
      css('&').styles(
        display: Display.flex,
        gap: Gap.all(Unit.expression('var(--gap)')),
        width: Unit.expression('max-content'),
        raw: {
          'margin-left': '50%',
          'transform': 'translateX(calc(-1 * (var(--i) * (var(--w) + var(--gap)) + var(--w) / 2)))',
          'transition': 'transform 380ms cubic-bezier(0.23, 1, 0.32, 1)',
        },
      ),
    ]),
    css('.gal-slide', [
      css('&').styles(
        width: Unit.expression('var(--w)'),
        height: Unit.expression('var(--h)'),
        padding: Padding.zero,
        border: Border.none,
        backgroundColor: Colors.transparent,
        cursor: Cursor.pointer,
        raw: {
          'flex': '0 0 auto',
          'transform': 'scale(0.86)',
          'opacity': '0.45',
          'transition': 'transform 380ms cubic-bezier(0.23, 1, 0.32, 1), opacity 380ms ease',
        },
      ),
      css('&[aria-current="true"]').styles(cursor: Cursor.defaultCursor, raw: {'transform': 'scale(1)', 'opacity': '1'}),
      css('&:focus-visible').styles(raw: {'outline': '2px solid ${AppColors.primary.value}', 'outline-offset': '4px', 'border-radius': '1.25rem'}),
      css('img').styles(
        width: 100.percent,
        height: 100.percent,
        radius: BorderRadius.circular(1.25.rem),
        border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.14), width: 1.px),
        backgroundColor: AppColors.surface,
        raw: {'object-fit': 'cover', 'display': 'block', 'pointer-events': 'none'},
      ),
    ]),
    css('.gal-btn', [
      css('&').styles(
        position: Position.absolute(top: 50.percent),
        zIndex: ZIndex(2),
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
          'margin-top': '-1.5rem',
          'backdrop-filter': 'blur(6px)',
          'transition': 'transform 160ms cubic-bezier(0.23, 1, 0.32, 1), background-color 160ms ease, opacity 160ms ease',
        },
      ),
      css('&:active').styles(transform: Transform.scale(0.94)),
      css('&:focus-visible').styles(raw: {'outline': '2px solid ${AppColors.primary.value}', 'outline-offset': '2px'}),
      css('&[disabled]').styles(raw: {'opacity': '0', 'pointer-events': 'none'}),
      css('&.prev').styles(raw: {'left': '0.5rem'}),
      css('&.next').styles(raw: {'right': '0.5rem'}),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile.px), [
        css('&').styles(width: 2.5.rem, height: 2.5.rem, raw: {'margin-top': '-1.25rem'}),
      ]),
    ]),
    RawMediaRule.hoverCapable([
      css('.gal-btn:hover').styles(backgroundColor: AppColors.primary, color: AppColors.background),
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
    // Each dot is a 2rem hit area around a small visible mark.
    css('.gal-dot', [
      css('&').styles(
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.center,
        width: 2.rem,
        height: 2.rem,
        padding: Padding.zero,
        border: Border.none,
        backgroundColor: Colors.transparent,
        cursor: Cursor.pointer,
      ),
      css('&:focus-visible').styles(raw: {'outline': '2px solid ${AppColors.primary.value}', 'outline-offset': '-2px', 'border-radius': '0.5rem'}),
      css('span').styles(
        width: 0.5.rem,
        height: 0.5.rem,
        radius: BorderRadius.circular(0.25.rem),
        backgroundColor: AppColors.textPrimary.withValues(alpha: 0.3),
        raw: {'transition': 'width 220ms cubic-bezier(0.23, 1, 0.32, 1), background-color 220ms ease'},
      ),
      css('&[aria-current="true"] span').styles(width: 1.5.rem, backgroundColor: AppColors.primary),
    ]),
    css('.gal-count', [
      css('&').styles(
        color: AppColors.textSecondary,
        fontSize: 0.85.rem,
        raw: {'font-variant-numeric': 'tabular-nums', 'min-width': '3.5rem'},
      ),
    ]),
    MotionRule.reduced([
      css('.gal-track, .gal-slide, .gal-dot span, .gal-btn').styles(raw: {'transition': 'none'}),
    ]),
  ];
}

class _ShotGalleryState extends State<ShotGalleryView> {
  static const _swipeDistance = 40.0;

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

    return div(
      classes: 'gal',
      attributes: {'role': 'group', 'aria-roledescription': 'carousel', 'aria-label': '$title screenshots'},
      [
        div(
          classes: 'gal-viewport',
          attributes: {'tabindex': '0', 'aria-label': '$title screenshots. Use the left and right arrow keys to browse.'},
          events: {
            'keydown': _onKey,
            'pointerdown': (e) => _dragStartX = pointerX(e),
            'pointerup': _onPointerUp,
            'pointercancel': (_) => _dragStartX = null,
          },
          [
            div(classes: 'gal-track', styles: Styles(raw: {'--i': '$_index'}), [
              for (final (i, src) in images.indexed)
                button(
                  classes: 'gal-slide',
                  attributes: {
                    'type': 'button',
                    'aria-label': 'Screenshot ${i + 1} of ${images.length}',
                    'aria-current': i == _index ? 'true' : 'false',
                    'tabindex': '-1',
                  },
                  events: {'click': (_) => _go(i)},
                  [
                    img(
                      src: src,
                      alt: '$title screenshot ${i + 1} of ${images.length}',
                      attributes: {
                        // The current screenshot and its neighbours load
                        // right away so a step never shows an empty frame;
                        // the rest wait until needed.
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
        if (images.length > 1) ...[
          button(
            classes: 'gal-btn prev',
            attributes: {'type': 'button', 'aria-label': 'Previous screenshot', if (_index == 0) 'disabled': ''},
            events: {'click': (_) => _go(_index - 1)},
            [span(classes: 'material-symbols-rounded', [.text('chevron_left')])],
          ),
          button(
            classes: 'gal-btn next',
            attributes: {'type': 'button', 'aria-label': 'Next screenshot', if (_index == _last) 'disabled': ''},
            events: {'click': (_) => _go(_index + 1)},
            [span(classes: 'material-symbols-rounded', [.text('chevron_right')])],
          ),
          div(classes: 'gal-footer', [
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
      ],
    );
  }
}

/// Entry point for server-rendered pages: a hydrated [ShotGalleryView].
///
/// Jaspr does not allow a client component inside another client component,
/// so components that are already `@client` (the stage showcase) use
/// [ShotGalleryView] directly instead of this wrapper.
@client
class ShotGallery extends StatelessComponent {
  final String title;
  final List<String> images;
  final bool eagerFirst;

  const ShotGallery({super.key, required this.title, required this.images, this.eagerFirst = false});

  @override
  Component build(BuildContext context) => ShotGalleryView(title: title, images: images, eagerFirst: eagerFirst);
}
