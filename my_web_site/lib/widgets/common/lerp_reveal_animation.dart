import 'package:flutter/material.dart';

/// Lerp Elements - Staggered smooth animations with delays
/// Like Locomotive Scroll's lerp effect
class LerpRevealAnimation extends StatefulWidget {
  final Widget child;
  final double scrollOffset;
  final double sectionStartOffset;
  final int index;
  final double viewportHeight;
  final Duration delay;
  final double speed; // Speed multiplier (1x, 2x, etc.)

  const LerpRevealAnimation({
    super.key,
    required this.child,
    required this.scrollOffset,
    required this.sectionStartOffset,
    required this.index,
    required this.viewportHeight,
    this.delay = const Duration(milliseconds: 0),
    this.speed = 1.0,
  });

  @override
  State<LerpRevealAnimation> createState() => _LerpRevealAnimationState();
}

class _LerpRevealAnimationState extends State<LerpRevealAnimation> {
  double _maxScroll = 0.0;

  @override
  void initState() {
    super.initState();
    _maxScroll = widget.scrollOffset;
  }

  @override
  void didUpdateWidget(LerpRevealAnimation oldWidget) {
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

    // Calculate reveal point with delay
    final delayOffset = widget.delay.inMilliseconds * 0.2;
    final itemPosition = widget.sectionStartOffset + (widget.index * widget.viewportHeight * 0.2) + delayOffset;
    
    // Start revealing earlier - 1.0 viewport before item, but animate faster
    final revealStart = itemPosition - (widget.viewportHeight * 1.0);
    final revealEnd = revealStart + (widget.viewportHeight * 0.5); // Faster reveal

    // Calculate progress based on max scroll (sticky)
    double progress = 0.0;
    if (_maxScroll >= revealEnd) {
      progress = 1.0;
    } else if (_maxScroll > revealStart) {
      progress = ((_maxScroll - revealStart) / (revealEnd - revealStart)).clamp(0.0, 1.0);
    }

    // Apply speed multiplier
    progress = (progress * widget.speed).clamp(0.0, 1.0);
    
    // Apply smooth easing (lerp)
    progress = _smoothLerp(progress);

    return Opacity(
      opacity: progress,
      child: Transform.translate(
        offset: Offset(0, 80 * (1.0 - progress)), // More dramatic slide
        child: Transform.scale(
          scale: 0.8 + (0.2 * progress), // More dramatic scale (0.8 to 1.0)
          child: Transform.rotate(
            angle: (1.0 - progress) * 0.05, // Subtle rotation (about 3 degrees)
            child: widget.child,
          ),
        ),
      ),
    );
  }

  double _smoothLerp(double t) {
    if (t <= 0) return 0.0;
    if (t >= 1) return 1.0;
    // Smooth step function for lerp effect
    return t * t * (3.0 - 2.0 * t);
  }
}

/// Staggered reveal for multiple items (like cards in a row)
class StaggeredLerpReveal extends StatelessWidget {
  final List<Widget> children;
  final double scrollOffset;
  final double sectionStartOffset;
  final double viewportHeight;
  final Duration baseDelay;
  final double staggerDelay; // Delay between each item

  const StaggeredLerpReveal({
    super.key,
    required this.children,
    required this.scrollOffset,
    required this.sectionStartOffset,
    required this.viewportHeight,
    this.baseDelay = const Duration(milliseconds: 0),
    this.staggerDelay = 100.0, // milliseconds
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;
        final delay = baseDelay + Duration(milliseconds: (staggerDelay * index).round());
        
        return Padding(
          padding: EdgeInsets.only(bottom: index < children.length - 1 ? 20 : 0),
          child: LerpRevealAnimation(
            scrollOffset: scrollOffset,
            sectionStartOffset: sectionStartOffset,
            index: index,
            viewportHeight: viewportHeight,
            delay: delay,
            child: child,
          ),
        );
      }).toList(),
    );
  }
}

/// Word-by-word text reveal (Lerp by letter/word)
class LerpTextReveal extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;
  final double scrollOffset;
  final double sectionStartOffset;
  final double viewportHeight;
  final Duration delay;
  final Duration wordDelay; // Delay between each word

  const LerpTextReveal({
    super.key,
    required this.text,
    this.style,
    this.textAlign = TextAlign.left,
    required this.scrollOffset,
    required this.sectionStartOffset,
    required this.viewportHeight,
    this.delay = const Duration(milliseconds: 0),
    this.wordDelay = const Duration(milliseconds: 30),
  });

  @override
  State<LerpTextReveal> createState() => _LerpTextRevealState();
}

class _LerpTextRevealState extends State<LerpTextReveal> {
  double _maxScroll = 0.0;

  @override
  void initState() {
    super.initState();
    _maxScroll = widget.scrollOffset;
  }

  @override
  void didUpdateWidget(LerpTextReveal oldWidget) {
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

    final delayOffset = widget.delay.inMilliseconds * 0.2;
    final revealStart = widget.sectionStartOffset - (widget.viewportHeight * 1.0) + delayOffset;
    final revealEnd = revealStart + (widget.viewportHeight * 0.5); // Faster reveal

    double baseProgress = 0.0;
    if (_maxScroll >= revealEnd) {
      baseProgress = 1.0;
    } else if (_maxScroll > revealStart) {
      baseProgress = ((_maxScroll - revealStart) / (revealEnd - revealStart)).clamp(0.0, 1.0);
    }

    final words = widget.text.split(' ');
    final totalWords = words.length;
    final wordDelayMs = widget.wordDelay.inMilliseconds;

    return RichText(
      textAlign: widget.textAlign,
      text: TextSpan(
        children: words.asMap().entries.map((entry) {
          final wordIndex = entry.key;
          final word = entry.value;
          
          // Calculate when this word should appear
          final wordStartProgress = (wordIndex * wordDelayMs) / (totalWords * wordDelayMs + widget.viewportHeight * 0.4);
          final wordEndProgress = ((wordIndex + 1) * wordDelayMs) / (totalWords * wordDelayMs + widget.viewportHeight * 0.4);
          
          final wordProgress = ((baseProgress - wordStartProgress) / (wordEndProgress - wordStartProgress)).clamp(0.0, 1.0);
          final wordOpacity = _smoothLerp(wordProgress);

          return TextSpan(
            text: wordIndex < words.length - 1 ? '$word ' : word,
            style: (widget.style ?? const TextStyle()).copyWith(
              color: (widget.style?.color ?? Colors.white).withOpacity(wordOpacity),
            ),
          );
        }).toList(),
      ),
    );
  }

  double _smoothLerp(double t) {
    if (t <= 0) return 0.0;
    if (t >= 1) return 1.0;
    return t * t * (3.0 - 2.0 * t);
  }
}
