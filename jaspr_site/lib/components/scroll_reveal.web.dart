import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Reveal-on-scroll, as progressive enhancement: the server-rendered page
/// shows everything, and only here, once the script runs, are the elements
/// still below the fold hidden (by adding `reveal-ready` to <html>, see the
/// `.reveal` rules in constants/theme.dart) and then revealed one by one as
/// they scroll into view. Elements already on screen are marked revealed
/// first, so nothing that is visible flickers out and back in. Visitors who
/// asked for reduced motion keep the page as rendered.
void observeReveals() {
  if (web.window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;

  final elements = web.document.querySelectorAll('.reveal');
  final viewportHeight = web.window.innerHeight;
  final pending = <web.Element>[];
  for (var i = 0; i < elements.length; i++) {
    final element = elements.item(i) as web.Element;
    final rect = element.getBoundingClientRect();
    if (rect.top < viewportHeight && rect.bottom > 0) {
      element.classList.add('revealed');
    } else {
      pending.add(element);
    }
  }

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
  for (final element in pending) {
    observer.observe(element);
  }

  web.document.documentElement?.classList.add('reveal-ready');
}
