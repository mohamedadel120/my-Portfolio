import 'package:web/web.dart' as web;

/// `KeyboardEvent.key` of a DOM event, or '' when it is not a keyboard event.
String keyOf(dynamic event) => event is web.KeyboardEvent ? event.key : '';

/// Horizontal client position of a pointer event, or 0 for other events.
double pointerX(dynamic event) => event is web.PointerEvent ? event.clientX.toDouble() : 0;
