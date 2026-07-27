import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Sets up an IntersectionObserver that adds `.revealed` to any `.reveal`
/// element once it scrolls into view, then stops watching it (one-shot
/// reveal, not a repeating effect). See constants/theme.dart for the
/// `.reveal`/`.reveal.revealed` CSS transition these toggle between.
void observeReveals() {
  final observer = web.IntersectionObserver(
    ((JSArray<web.IntersectionObserverEntry> entries, web.IntersectionObserver obs) {
      for (final entry in entries.toDart) {
        if (entry.isIntersecting) {
          entry.target.classList.add('revealed');
          obs.unobserve(entry.target);
        }
      }
    }).toJS,
    web.IntersectionObserverInit(threshold: 0.15.toJS, rootMargin: '0px 0px -50px 0px'),
  );

  final elements = web.document.querySelectorAll('.reveal');
  for (var i = 0; i < elements.length; i++) {
    observer.observe(elements.item(i) as web.Element);
  }
}
