import 'package:flutter/widgets.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Reports whether [child]'s subtree is currently within the viewport, so
/// callers can stop infinite-looping animations (flutter_animate `.repeat()`,
/// raw `AnimationController`s) from ticking forever once scrolled away.
class VisibilityPause extends StatefulWidget {
  final Object visibilityKey;
  final Widget Function(BuildContext context, bool isVisible) builder;

  const VisibilityPause({
    super.key,
    required this.visibilityKey,
    required this.builder,
  });

  @override
  State<VisibilityPause> createState() => _VisibilityPauseState();
}

class _VisibilityPauseState extends State<VisibilityPause> {
  // Assume visible until the first callback fires, so above-the-fold content
  // (e.g. the hero) animates immediately instead of flashing a static frame.
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: ValueKey(widget.visibilityKey),
      onVisibilityChanged: (info) {
        final visible = info.visibleFraction > 0;
        if (visible != _isVisible && mounted) {
          setState(() => _isVisible = visible);
        }
      },
      child: widget.builder(context, _isVisible),
    );
  }
}
