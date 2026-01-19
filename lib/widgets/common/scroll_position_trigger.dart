import 'package:flutter/material.dart';

enum ScrollPosition {
  start,
  middle,
  end,
}

/// Widget that triggers callbacks at specific scroll positions
/// Similar to data-scroll-position in Locomotive Scroll
class ScrollPositionTrigger extends StatelessWidget {
  final Widget child;
  final double scrollOffset;
  final double sectionStartOffset;
  final double viewportHeight;
  final ScrollPosition enterPosition; // When to trigger on enter
  final ScrollPosition leavePosition; // When to trigger on leave
  final VoidCallback? onEnter;
  final VoidCallback? onLeave;
  final bool repeat; // Whether to repeat triggers when scrolling back

  const ScrollPositionTrigger({
    super.key,
    required this.child,
    required this.scrollOffset,
    required this.sectionStartOffset,
    required this.viewportHeight,
    this.enterPosition = ScrollPosition.start,
    this.leavePosition = ScrollPosition.end,
    this.onEnter,
    this.onLeave,
    this.repeat = false,
  });

  double _getPositionOffset(ScrollPosition position) {
    switch (position) {
      case ScrollPosition.start:
        return 0.0;
      case ScrollPosition.middle:
        return 0.5;
      case ScrollPosition.end:
        return 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final relativeScroll = scrollOffset - sectionStartOffset;
    final enterOffset = _getPositionOffset(enterPosition) * viewportHeight;
    final leaveOffset = _getPositionOffset(leavePosition) * viewportHeight;
    
    // Trigger callbacks (in a real implementation, you'd use a StatefulWidget
    // to track previous state and avoid multiple triggers)
    if (relativeScroll >= enterOffset && relativeScroll < enterOffset + 10) {
      // Small threshold to avoid multiple triggers
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onEnter?.call();
      });
    }
    
    if (relativeScroll >= leaveOffset && relativeScroll < leaveOffset + 10) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onLeave?.call();
      });
    }

    return child;
  }
}
