import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart' as web;

/// `KeyboardEvent.key` of a DOM event, or '' when it is not a keyboard event.
String keyOf(dynamic event) {
  final js = event as JSAny?;
  return js.isA<web.KeyboardEvent>() ? (js as web.KeyboardEvent).key : '';
}

/// Horizontal client position of a pointer event, or 0 for other events.
///
/// Read as a JS number: browsers report fractional positions (for example
/// 337.8) on high-precision pointers, which `PointerEvent.clientX` (typed
/// `int` in package:web) rejects at runtime.
double pointerX(dynamic event) {
  final js = event as JSAny?;
  if (!js.isA<web.PointerEvent>()) return 0;
  return ((js as JSObject).getProperty('clientX'.toJS) as JSNumber).toDartDouble;
}

/// Numeric value of the `<input>` that fired [event], or null.
int? inputValue(dynamic event) {
  final target = ((event as JSAny?) as JSObject?)?.getProperty('target'.toJS) as JSObject?;
  final value = target?.getProperty('value'.toJS) as JSString?;
  return value == null ? null : int.tryParse(value.toDart);
}
