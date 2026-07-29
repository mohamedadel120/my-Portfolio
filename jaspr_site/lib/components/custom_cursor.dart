import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import 'custom_cursor.vm.dart' if (dart.library.js_interop) 'custom_cursor.web.dart';

/// Ported from the Flutter app's `AdaptiveCursor` -- a circle that follows
/// the mouse and grows/glows over interactive elements, replacing the system
/// cursor on desktop. Mounted once at the root; renders one overlay div and
/// hands positioning off to plain JS (see custom_cursor.web.dart) rather than
/// driving it through Dart state on every `mousemove`.
@client
class CustomCursor extends StatefulComponent {
  const CustomCursor({super.key});

  @override
  State<CustomCursor> createState() => _CustomCursorState();

  @css
  static List<StyleRule> get styles => [
    css('.custom-cursor', [
      css('&').styles(
        display: Display.none,
        position: Position.fixed(top: Unit.zero, left: Unit.zero),
        width: 12.px,
        height: 12.px,
        radius: BorderRadius.circular(50.percent),
        backgroundColor: AppColors.primary,
        zIndex: ZIndex(9999),
        raw: {
          'pointer-events': 'none',
          'transition': 'width 200ms ease-out, height 200ms ease-out, '
              'background-color 200ms ease-out, border 200ms ease-out, box-shadow 200ms ease-out',
        },
      ),
    ]),
    css('body.custom-cursor-active', [
      css('&').styles(raw: {'cursor': 'none'}),
      css('.custom-cursor').styles(display: Display.block),
    ]),
    css('.custom-cursor.pointer', [
      css('&').styles(
        width: 50.px,
        height: 50.px,
        backgroundColor: AppColors.primary.withValues(alpha: 0.15),
        border: Border.all(color: AppColors.primary, width: 2.px),
        raw: {'box-shadow': '0 0 15px 2px ${AppColors.primary.withValues(alpha: 0.4).value}'},
      ),
    ]),
  ];
}

class _CustomCursorState extends State<CustomCursor> {
  static const _cursorId = 'custom-cursor';

  @override
  void initState() {
    super.initState();
    initCustomCursor(_cursorId);
  }

  @override
  Component build(BuildContext context) {
    return div(id: _cursorId, classes: 'custom-cursor', []);
  }
}
