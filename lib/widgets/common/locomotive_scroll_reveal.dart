import 'package:flutter/material.dart';

enum ScrollDirection {
  up, // Slide up (default)
  down, // Slide down
  left, // Slide from left
  right, // Slide from right
}

class LocomotiveProgressiveReveal extends StatefulWidget {
  final Widget title;
  final Widget details;
  final double scrollOffset;
  final double sectionStartOffset;
  final int index;
  final double viewportHeight;
  final double spacing;
  final ScrollDirection scrollDirection; // New: direction for scroll animation

  const LocomotiveProgressiveReveal({
    super.key,
    required this.title,
    required this.details,
    required this.scrollOffset,
    required this.sectionStartOffset,
    required this.index,
    required this.viewportHeight,
    this.spacing = 20.0,
    this.scrollDirection = ScrollDirection.up, // Default: slide up
  });

  @override
  State<LocomotiveProgressiveReveal> createState() =>
      _LocomotiveProgressiveRevealState();
}

class _LocomotiveProgressiveRevealState
    extends State<LocomotiveProgressiveReveal> {
  double _maxScroll = 0.0;

  @override
  void initState() {
    super.initState();
    _maxScroll = widget.scrollOffset;
  }

  @override
  void didUpdateWidget(LocomotiveProgressiveReveal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.scrollOffset > _maxScroll) {
      setState(() {
        _maxScroll = widget.scrollOffset;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.scrollOffset > _maxScroll) {
      _maxScroll = widget.scrollOffset;
    }

    // Items appear with spacing for sequential reveal
    final itemPosition =
        widget.sectionStartOffset +
        (widget.index * widget.viewportHeight * 0.1);

    // Title animation: starts much earlier, completes much earlier - APPEAR IN SECTION
    final titleStart =
        widget.sectionStartOffset -
        (widget.viewportHeight * 0.3); // Start well before section
    final titleEnd =
        itemPosition -
        (widget.viewportHeight * 0.1); // Complete before item reaches position

    // Details animation: starts right after title starts, completes quickly
    final detailsStart =
        titleStart + (widget.viewportHeight * 0.1); // Start soon after title
    final detailsEnd = itemPosition; // Complete when item reaches position

    // Calculate progress based on MAX scroll (sticky) - progress from 0 to 1
    double titleProgress = 0.0;
    if (_maxScroll >= titleEnd) {
      titleProgress = 1.0;
    } else if (_maxScroll > titleStart) {
      final range = titleEnd - titleStart;
      if (range > 0) {
        titleProgress = ((_maxScroll - titleStart) / range).clamp(0.0, 1.0);
      } else {
        titleProgress = _maxScroll >= titleStart ? 1.0 : 0.0;
      }
    }

    double detailsProgress = 0.0;
    if (_maxScroll >= detailsEnd) {
      detailsProgress = 1.0;
    } else if (_maxScroll > detailsStart) {
      final range = detailsEnd - detailsStart;
      if (range > 0) {
        detailsProgress = ((_maxScroll - detailsStart) / range).clamp(0.0, 1.0);
      } else {
        detailsProgress = _maxScroll >= detailsStart ? 1.0 : 0.0;
      }
    }

    // Calculate offset based on scroll direction - LARGE distance for visible animation
    Offset getTitleOffset(double progress) {
      // Start far off-screen, move to center as progress increases
      final distance =
          300.0 *
          (1.0 - progress); // Large distance for visible slide animation
      switch (widget.scrollDirection) {
        case ScrollDirection.left:
          return Offset(-distance, 0);
        case ScrollDirection.right:
          return Offset(distance, 0);
        case ScrollDirection.down:
          return Offset(0, distance);
        case ScrollDirection.up:
          return Offset(0, -distance);
      }
    }

    Offset getDetailsOffset(double progress) {
      // Start far off-screen, move to center as progress increases
      final distance =
          350.0 *
          (1.0 - progress); // Large distance for visible slide animation
      switch (widget.scrollDirection) {
        case ScrollDirection.left:
          return Offset(-distance, 0);
        case ScrollDirection.right:
          return Offset(distance, 0);
        case ScrollDirection.down:
          return Offset(0, distance);
        case ScrollDirection.up:
          return Offset(0, -distance);
      }
    }

    // Make opacity fade in quickly - elements become visible early
    // Start at 30% opacity so elements are visible during slide, reach 100% quickly
    final titleOpacity = (0.3 + (titleProgress * 0.7)).clamp(0.0, 1.0);
    final detailsOpacity = (0.3 + (detailsProgress * 0.8)).clamp(0.0, 1.0);

    // Wrap in ClipRect to prevent clipping during slide-in animation
    return ClipRect(
      clipBehavior: Clip.none, // Allow content to slide in from off-screen
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Opacity(
            opacity: titleOpacity,
            child: Transform.translate(
              offset: getTitleOffset(titleProgress),
              child: widget.title,
            ),
          ),
          SizedBox(height: widget.spacing),
          Opacity(
            opacity: detailsOpacity,
            child: Transform.translate(
              offset: getDetailsOffset(detailsProgress),
              child: widget.details,
            ),
          ),
        ],
      ),
    );
  }
}
