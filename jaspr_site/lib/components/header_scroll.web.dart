import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Real browser implementation — only compiled in for the client/web target.
void listenForScroll(void Function(bool scrolled) onChange) {
  var wasScrolled = false;
  web.window.addEventListener(
    'scroll',
    (web.Event _) {
      final scrolled = web.window.scrollY > 40;
      if (scrolled != wasScrolled) {
        wasScrolled = scrolled;
        onChange(scrolled);
      }
    }.toJS,
  );
}
