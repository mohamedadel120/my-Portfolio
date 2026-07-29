import 'dart:async';
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

void scheduleTimeout(Duration duration, void Function() callback) {
  Timer(duration, callback);
}

// The browser starts fetching an SSR'd <img src="..."> the moment it parses
// the raw HTML -- well before the deferred Jaspr/JS bundle finishes
// downloading and hydrates, which is when the 'load' event listener actually
// gets attached. On a fast enough connection the image finishes loading
// before that listener exists, so the native 'load' event fires and is
// permanently missed. This lets callers check completion directly instead
// of relying solely on that event.
bool isMediaLoaded(String id) {
  final el = web.document.getElementById(id);
  if (el == null) return false;
  if (el.isA<web.HTMLImageElement>()) {
    final img = el as web.HTMLImageElement;
    return img.complete && img.naturalWidth > 0;
  }
  if (el.isA<web.HTMLVideoElement>()) {
    return (el as web.HTMLVideoElement).readyState >= 2;
  }
  return false;
}
