import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/motion_css.dart';
import '../constants/theme.dart';
import 'shot_strip.vm.dart' if (dart.library.js_interop) 'shot_strip.web.dart';

/// A horizontally scrolling row of screenshots with previous / next buttons.
///
/// The browser's own horizontal scrollbar (white track with arrow buttons on
/// Windows) is hidden; the buttons, trackpad / touch swiping, the keyboard
/// (the row is a focusable region, arrow keys scroll it) and the edge fade
/// are the controls. Without JavaScript the row still scrolls by swipe or
/// keyboard and every image is in the HTML.
@client
class ShotStrip extends StatefulComponent {
  final String id;
  final String title;
  final List<String> images;

  /// Load the first image immediately (it is above the fold); the rest lazily.
  final bool eagerFirst;

  const ShotStrip({super.key, required this.id, required this.title, required this.images, this.eagerFirst = false});

  @override
  State<ShotStrip> createState() => _ShotStripState();

  @css
  static List<StyleRule> get styles => [
    css('.strip', [
      css('&').styles(position: Position.relative()),
    ]),
    css('.strip-row', [
      css('&').styles(
        display: Display.flex,
        gap: Gap.all(1.25.rem),
        raw: {
          'overflow-x': 'auto',
          'scroll-snap-type': 'x proximity',
          'overscroll-behavior-x': 'contain',
          'scrollbar-width': 'none',
          '-ms-overflow-style': 'none',
          'padding-block': '0.25rem',
        },
      ),
      css('&::-webkit-scrollbar').styles(display: Display.none),
      css('&:focus-visible').styles(raw: {'outline': '2px solid ${AppColors.primary.value}', 'outline-offset': '4px'}),
    ]),
    // Edge fades only where there is more to see, so the first and last
    // screenshots are never dimmed at rest.
    css('.strip[data-more-end="true"] .strip-row', [
      css('&').styles(raw: {
        '-webkit-mask-image': 'linear-gradient(to right, #000 calc(100% - 4rem), transparent)',
        'mask-image': 'linear-gradient(to right, #000 calc(100% - 4rem), transparent)',
      }),
    ]),
    css('.strip[data-more-start="true"] .strip-row', [
      css('&').styles(raw: {
        '-webkit-mask-image': 'linear-gradient(to left, #000 calc(100% - 4rem), transparent)',
        'mask-image': 'linear-gradient(to left, #000 calc(100% - 4rem), transparent)',
      }),
    ]),
    css('.strip[data-more-start="true"][data-more-end="true"] .strip-row', [
      css('&').styles(raw: {
        '-webkit-mask-image': 'linear-gradient(to right, transparent, #000 4rem, #000 calc(100% - 4rem), transparent)',
        'mask-image': 'linear-gradient(to right, transparent, #000 4rem, #000 calc(100% - 4rem), transparent)',
      }),
    ]),
    css('.strip-shot', [
      css('&').styles(
        height: 30.rem,
        radius: BorderRadius.circular(1.rem),
        border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.12), width: 1.px),
        backgroundColor: AppColors.surface,
        raw: {
          'aspect-ratio': '9 / 19.5',
          'flex': '0 0 auto',
          'object-fit': 'cover',
          'scroll-snap-align': 'start',
        },
      ),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile.px), [
        css('&').styles(height: 24.rem),
      ]),
    ]),
    css('.strip-btn', [
      css('&').styles(
        position: Position.absolute(top: 50.percent),
        zIndex: ZIndex(2),
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.center,
        width: 2.75.rem,
        height: 2.75.rem,
        padding: Padding.zero,
        radius: BorderRadius.circular(50.percent),
        border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.25), width: 1.px),
        backgroundColor: AppColors.background.withValues(alpha: 0.82),
        color: AppColors.textPrimary,
        cursor: Cursor.pointer,
        raw: {
          'transform': 'translateY(-50%)',
          'backdrop-filter': 'blur(6px)',
          'transition': 'transform 160ms cubic-bezier(0.23, 1, 0.32, 1), background-color 160ms ease',
        },
      ),
      css('&:active').styles(raw: {'transform': 'translateY(-50%) scale(0.95)'}),
      css('&:focus-visible').styles(raw: {'outline': '2px solid ${AppColors.primary.value}', 'outline-offset': '2px'}),
      css('&[hidden]').styles(display: Display.none),
      css('&.prev').styles(raw: {'left': '0.5rem'}),
      css('&.next').styles(raw: {'right': '0.5rem'}),
    ]),
    // Hover effects only where a real pointer exists, so taps on phones
    // don't leave a stuck hover state.
    RawMediaRule.hoverCapable([
      css('.strip-btn:hover').styles(backgroundColor: AppColors.primary, color: AppColors.background),
    ]),
    // Phones swipe; the buttons would only cover the screenshots.
    css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile.px), [
      css('.strip-btn').styles(display: Display.none),
    ]),
  ];
}

class _ShotStripState extends State<ShotStrip> {
  bool _atStart = true;
  bool _atEnd = false;

  String get _rowId => '${component.id}-row';

  @override
  void initState() {
    super.initState();
    // Deferred: setState must not run before the first build completes.
    scheduleTick(() {
      listenElementScroll(_rowId, _sync);
      _sync();
    });
  }

  void _sync() {
    if (!mounted) return;
    final edges = scrollEdges(_rowId);
    if (edges.atStart != _atStart || edges.atEnd != _atEnd) {
      setState(() {
        _atStart = edges.atStart;
        _atEnd = edges.atEnd;
      });
    }
  }

  @override
  Component build(BuildContext context) {
    final images = component.images;
    final single = images.length < 2;

    return div(
      classes: 'strip',
      attributes: {'data-more-start': '${!_atStart}', 'data-more-end': '${!_atEnd && !single}'},
      [
        if (!single)
          button(
            classes: 'strip-btn prev',
            attributes: {
              'type': 'button',
              'aria-label': 'Previous ${component.title} screenshots',
              if (_atStart) 'hidden': '',
            },
            events: {'click': (_) => scrollElementBy(_rowId, -0.8)},
            [span(classes: 'material-symbols-rounded', [.text('chevron_left')])],
          ),
        div(
          id: _rowId,
          classes: 'strip-row',
          attributes: {'role': 'region', 'aria-label': '${component.title} screenshots', 'tabindex': '0'},
          [
            for (final (i, src) in images.indexed)
              img(
                src: src,
                alt: '${component.title} screenshot ${i + 1} of ${images.length}',
                classes: 'strip-shot',
                attributes: {'loading': component.eagerFirst && i == 0 ? 'eager' : 'lazy', 'decoding': 'async'},
              ),
          ],
        ),
        if (!single)
          button(
            classes: 'strip-btn next',
            attributes: {
              'type': 'button',
              'aria-label': 'Next ${component.title} screenshots',
              if (_atEnd) 'hidden': '',
            },
            events: {'click': (_) => scrollElementBy(_rowId, 0.8)},
            [span(classes: 'material-symbols-rounded', [.text('chevron_right')])],
          ),
      ],
    );
  }
}
