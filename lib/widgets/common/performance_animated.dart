import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/device_utils.dart';

/// A wrapper that conditionally applies animations based on device capability.
/// On low-spec devices, the child is rendered without animations.
class PerformanceAnimated extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final bool fadeIn;
  final bool slideFromBottom;
  final bool scaleIn;

  const PerformanceAnimated({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 600),
    this.delay = Duration.zero,
    this.fadeIn = true,
    this.slideFromBottom = false,
    this.scaleIn = false,
  });

  @override
  Widget build(BuildContext context) {
    final isLowSpec = DeviceUtils.isLowSpecDevice(context);

    if (isLowSpec) {
      // Return child without animations on low-spec devices
      return child;
    }

    // Apply animations on capable devices using flutter_animate chaining
    Animate animated = child.animate(delay: delay);

    if (fadeIn) {
      animated = animated.fadeIn(duration: duration);
    }

    if (slideFromBottom) {
      animated = animated.slideY(
        begin: 0.2,
        end: 0,
        duration: duration,
      );
    }

    if (scaleIn) {
      animated = animated.scale(
        begin: const Offset(0.8, 0.8),
        end: const Offset(1, 1),
        duration: duration,
        curve: Curves.easeOutBack,
      );
    }

    return animated;
  }
}

/// Extension to easily disable animations on low-spec devices
extension PerformanceAnimate on Widget {
  /// Returns the widget without animation if on low-spec device
  Widget animateIfCapable(BuildContext context) {
    if (DeviceUtils.isLowSpecDevice(context)) {
      return this;
    }
    return animate();
  }
}
