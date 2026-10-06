import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

void listenElementScroll(String id, void Function() callback) {
  web.document.getElementById(id)?.addEventListener(
    'scroll',
    (web.Event _) {
      callback();
    }.toJS,
    <String, JSAny?>{'passive': true.toJS}.jsify() as JSAny,
  );
}

/// Whether the strip is scrolled fully to its left / right edge (1px of
/// tolerance for sub-pixel scroll positions).
({bool atStart, bool atEnd}) scrollEdges(String id) {
  final el = web.document.getElementById(id);
  if (el == null) return (atStart: true, atEnd: true);
  final max = el.scrollWidth - el.clientWidth;
  return (atStart: el.scrollLeft <= 1, atEnd: el.scrollLeft >= max - 1);
}

/// Scrolls the strip by [fraction] of its visible width (negative = left).
/// Instant for visitors who asked for reduced motion.
void scrollElementBy(String id, double fraction) {
  final el = web.document.getElementById(id);
  if (el == null) return;
  final reduce = web.window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  el.scrollBy(web.ScrollToOptions(left: el.clientWidth * fraction, behavior: reduce ? 'auto' : 'smooth'));
}

void scheduleTick(void Function() callback) {
  Timer(Duration.zero, callback);
}
