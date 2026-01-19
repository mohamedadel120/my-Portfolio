import 'package:flutter/material.dart';

/// Progressive scroll reveal animation
/// Shows title first, then reveals details as you scroll down
/// Similar to experience section but with progressive reveal
class ProgressiveScrollReveal extends StatelessWidget {
  final Widget title;
  final Widget details;
  final double scrollOffset;
  final double sectionStartOffset;
  final int index; // Index of the item in the list
  final double viewportHeight;
  final Duration titleDelay;
  final Duration detailsDelay;

  const ProgressiveScrollReveal({
    super.key,
    required this.title,
    required this.details,
    required this.scrollOffset,
    required this.sectionStartOffset,
    required this.index,
    required this.viewportHeight,
    this.titleDelay = const Duration(milliseconds: 0),
    this.detailsDelay = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    // Calculate when this item enters the viewport
    final itemStartOffset = sectionStartOffset + (index * viewportHeight * 0.6);
    
    // Title appears when item is about to enter viewport
    final titleTriggerPoint = itemStartOffset - viewportHeight * 0.3;
    final titleDistance = scrollOffset - titleTriggerPoint;
    final titleProgress = (titleDistance / (viewportHeight * 0.4)).clamp(0.0, 1.0);
    final titleOpacity = titleProgress;
    final titleTranslateY = 30 * (1.0 - titleProgress);
    
    // Details appear after title is visible (with delay based on scroll)
    final detailsTriggerPoint = titleTriggerPoint + (viewportHeight * 0.2);
    final detailsDistance = scrollOffset - detailsTriggerPoint;
    final detailsProgress = (detailsDistance / (viewportHeight * 0.5)).clamp(0.0, 1.0);
    final detailsOpacity = detailsProgress;
    final detailsTranslateY = 40 * (1.0 - detailsProgress);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title - appears first
        Opacity(
          opacity: titleOpacity,
          child: Transform.translate(
            offset: Offset(0, titleTranslateY),
            child: title,
          ),
        ),
        // Details - appears after scrolling more
        if (detailsOpacity > 0.1)
          Opacity(
            opacity: detailsOpacity,
            child: Transform.translate(
              offset: Offset(0, detailsTranslateY),
              child: details,
            ),
          ),
      ],
    );
  }
}

/// Enhanced progressive reveal with smooth animations
/// Items appear progressively and stay visible once shown (sticky reveal)
class SmoothProgressiveReveal extends StatefulWidget {
  final Widget title;
  final Widget details;
  final double scrollOffset;
  final double sectionStartOffset;
  final int index;
  final double viewportHeight;
  final double spacing;

  const SmoothProgressiveReveal({
    super.key,
    required this.title,
    required this.details,
    required this.scrollOffset,
    required this.sectionStartOffset,
    required this.index,
    required this.viewportHeight,
    this.spacing = 20.0,
  });

  @override
  State<SmoothProgressiveReveal> createState() => _SmoothProgressiveRevealState();
}

class _SmoothProgressiveRevealState extends State<SmoothProgressiveReveal> {
  double _maxTitleProgress = 0.0;
  double _maxDetailsProgress = 0.0;

  @override
  Widget build(BuildContext context) {
    // Each item takes about 60% of viewport height
    final itemHeight = widget.viewportHeight * 0.6;
    final itemStartOffset = widget.sectionStartOffset + (widget.index * itemHeight);
    
    // Title trigger: when item is 40% up the viewport
    final titleTrigger = itemStartOffset - widget.viewportHeight * 0.4;
    final titleDistance = widget.scrollOffset - titleTrigger;
    final titleRange = widget.viewportHeight * 0.3;
    final titleRawProgress = (titleDistance / titleRange).clamp(0.0, 1.0);
    final titleProgress = _easeOutCubic(titleRawProgress);
    
    // Details trigger: starts when title is 50% visible
    final detailsTrigger = titleTrigger + (titleRange * 0.5);
    final detailsDistance = widget.scrollOffset - detailsTrigger;
    final detailsRange = widget.viewportHeight * 0.4;
    final detailsRawProgress = (detailsDistance / detailsRange).clamp(0.0, 1.0);
    final detailsProgress = _easeOutCubic(detailsRawProgress);
    
    // Update max progress - items stay visible once shown (sticky reveal)
    if (titleProgress > _maxTitleProgress) {
      _maxTitleProgress = titleProgress;
    }
    if (detailsProgress > _maxDetailsProgress) {
      _maxDetailsProgress = detailsProgress;
    }
    
    // Use max progress to ensure items stay visible once shown
    final finalTitleProgress = _maxTitleProgress;
    final finalDetailsProgress = _maxDetailsProgress;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title with smooth reveal - stays visible once shown
        Opacity(
          opacity: finalTitleProgress,
          child: Transform.translate(
            offset: Offset(0, 30 * (1.0 - finalTitleProgress)),
            child: Transform.scale(
              scale: 0.9 + (0.1 * finalTitleProgress),
              child: widget.title,
            ),
          ),
        ),
        SizedBox(height: widget.spacing),
        // Details with smooth reveal - stays visible once shown
        Opacity(
          opacity: finalDetailsProgress,
          child: Transform.translate(
            offset: Offset(0, 40 * (1.0 - finalDetailsProgress)),
            child: Transform.scale(
              scale: 0.95 + (0.05 * finalDetailsProgress),
              child: widget.details,
            ),
          ),
        ),
      ],
    );
  }
  
  double _easeOutCubic(double t) {
    return 1.0 - (1.0 - t) * (1.0 - t) * (1.0 - t);
  }
}
