import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class DeviceUtils {
  // Static flag to force performance mode (can be set by user preference)
  static bool forcePerformanceMode = false;

  // Check if device is low-spec based on multiple factors
  static bool isLowSpecDevice(BuildContext context) {
    if (forcePerformanceMode) return true;

    final size = MediaQuery.of(context).size;
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;

    // Low-spec conditions:
    // 1. Very small screens (likely budget phones)
    // 2. Mobile-sized screens (all mobiles should use performance mode)
    // 3. High pixel ratios on small screens (demanding on GPU)
    // 4. Web on mobile (Flutter web on mobile is resource-intensive)
    final isSmallScreen = size.width < 600;
    final isVerySmallScreen = size.width < 450 || size.shortestSide < 400;
    final isHighDpiSmallScreen = pixelRatio > 2.5 && size.width < 800;
    final isMobileWeb = kIsWeb && isMobile(size.width);

    return isVerySmallScreen ||
        isHighDpiSmallScreen ||
        isMobileWeb ||
        isSmallScreen;
  }

  // Check if animations should be reduced (more aggressive than isLowSpec)
  static bool shouldReduceAnimations(BuildContext context) {
    if (forcePerformanceMode) return true;
    final size = MediaQuery.of(context).size;
    // Reduce animations on all mobile devices and tablets
    return isMobile(size.width) || isTablet(size.width);
  }

  // Responsive breakpoints
  static bool isExtraSmall(double width) => width < 480;
  static bool isMobile(double width) => width < 768;
  static bool isTablet(double width) => width >= 768 && width < 1024;
  static bool isDesktop(double width) => width >= 1024;

  // Adaptive values based on screen size
  static double getHorizontalPadding(double width) {
    if (isExtraSmall(width)) return 16.0;
    if (isMobile(width)) return 24.0;
    if (isTablet(width)) return 40.0;
    return 60.0;
  }

  static double getVerticalPadding(double width) {
    if (isExtraSmall(width)) return 40.0;
    if (isMobile(width)) return 60.0;
    if (isTablet(width)) return 80.0;
    return 100.0;
  }
}
