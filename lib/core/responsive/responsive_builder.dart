import 'package:flutter/material.dart';
import 'responsive_breakpoints.dart';

class ResponsiveBuilder extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery instead of LayoutBuilder to prevent layout re-entrancy
    // when ResponsiveBuilder is used inside ValueListenableBuilder scroll listeners
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < ResponsiveBreakpoints.mobile) {
      return mobile;
    } else if (screenWidth < ResponsiveBreakpoints.tablet) {
      return tablet ?? mobile;
    } else {
      return desktop;
    }
  }
}
