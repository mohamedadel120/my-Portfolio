import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../../../../../core/responsive/responsive_builder.dart';
import 'mobile/experience_mobile_view.dart';
import 'desktop/experience_desktop_view.dart';

class ExperienceSection extends StatelessWidget {
  final ValueListenable<double> scrollOffsetListenable;

  const ExperienceSection({super.key, required this.scrollOffsetListenable});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobile: ExperienceMobileView(
          scrollOffsetListenable: scrollOffsetListenable),
      // Use Desktop view for Tablet for now as they share similar layout logic
      tablet: ExperienceDesktopView(
          scrollOffsetListenable: scrollOffsetListenable),
      desktop: ExperienceDesktopView(
          scrollOffsetListenable: scrollOffsetListenable),
    );
  }
}
