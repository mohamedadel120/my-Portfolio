import 'dart:js_interop';

import 'package:web/web.dart' as web;

double scrollY() => web.window.scrollY;

double elementOffsetTop(String id) {
  final el = web.document.getElementById(id);
  if (el == null) return 0;
  return el.getBoundingClientRect().top + web.window.scrollY;
}

void listenScroll(void Function() callback) {
  web.window.addEventListener(
    'scroll',
    (web.Event _) {
      callback();
    }.toJS,
    <String, JSAny?>{'passive': true.toJS}.jsify() as JSAny,
  );
}

void smoothScrollTo(double y) {
  web.window.scrollTo(
    web.ScrollToOptions(top: y, behavior: 'smooth'),
  );
}
