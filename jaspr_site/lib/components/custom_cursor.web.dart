import 'dart:js_interop';

import 'package:web/web.dart' as web;

const _interactiveSelector = 'a, button, input, textarea, select, label, '
    '[role="button"], .nav-dot, .store-btn, .nav-item';

/// Mouse-follower cursor, ported from the Flutter app's `AdaptiveCursor`
/// (MouseRegion + ValueNotifier driving an AnimatedPositioned overlay).
/// Updates the cursor element directly via the DOM instead of routing every
/// `mousemove` through Dart/Jaspr state -- same reason the original bypassed
/// `setState` with a `ValueNotifier`: per-pixel framework rebuilds would be
/// far more work than the effect needs.
///
/// Skips entirely on touch devices (no hover-capable, fine-pointer input),
/// mirroring the original's mobile/tablet `MediaQuery` check -- and leaves
/// the system cursor untouched until this confirms desktop input, so a
/// slow-to-hydrate client component never leaves the page cursor-less.
void initCustomCursor(String cursorId) {
  if (!web.window.matchMedia('(hover: hover) and (pointer: fine)').matches) {
    return;
  }

  final el = web.document.getElementById(cursorId) as web.HTMLElement?;
  if (el == null) return;

  web.document.body!.classList.add('custom-cursor-active');

  web.document.addEventListener(
    'mousemove',
    (web.MouseEvent e) {
      el.style.transform = 'translate3d(${e.clientX}px, ${e.clientY}px, 0)';
    }.toJS,
  );

  web.document.addEventListener(
    'mouseover',
    (web.MouseEvent e) {
      final target = e.target;
      if (target == null || !target.isA<web.Element>()) return;
      if ((target as web.Element).closest(_interactiveSelector) != null) {
        el.classList.add('pointer');
      }
    }.toJS,
  );

  web.document.addEventListener(
    'mouseout',
    (web.MouseEvent e) {
      final target = e.target;
      if (target == null || !target.isA<web.Element>()) return;
      if ((target as web.Element).closest(_interactiveSelector) != null) {
        el.classList.remove('pointer');
      }
    }.toJS,
  );
}
