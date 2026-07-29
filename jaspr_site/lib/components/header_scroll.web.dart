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

String? _computeActiveSection(List<String> ids) {
  // A section counts as "active" once its top has scrolled up past the
  // fixed header's height -- last one past that line wins, matching how
  // scrollspy navs conventionally decide "which section are we in".
  const threshold = 150.0;
  String? active;
  for (final id in ids) {
    final el = web.document.getElementById(id);
    if (el == null) continue;
    if (el.getBoundingClientRect().top <= threshold) active = id;
  }
  return active;
}

/// Fires on every scroll tick (unlike [listenForScroll], which only fires
/// when the scrolled/not-scrolled boundary is crossed) since which section
/// counts as "active" can change continuously as the user scrolls. Only
/// finds matching sections on `/` -- the other routes (/about, /projects,
/// /contact) don't have these ids in their DOM, so this harmlessly never
/// reports an active link there.
void listenForActiveSection(List<String> ids, void Function(String?) onChange) {
  String? last;
  void check() {
    final active = _computeActiveSection(ids);
    if (active != last) {
      last = active;
      onChange(active);
    }
  }

  web.window.addEventListener(
    'scroll',
    (web.Event _) {
      check();
    }.toJS,
    <String, JSAny?>{'passive': true.toJS}.jsify() as JSAny,
  );
  check();
}
