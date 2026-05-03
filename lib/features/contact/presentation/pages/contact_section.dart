import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/responsive/responsive_builder.dart';
import 'mobile/contact_mobile_view.dart';
import 'desktop/contact_desktop_view.dart';

class ContactSection extends StatelessWidget {
  final ValueListenable<double> scrollOffsetListenable;

  const ContactSection({
    super.key,
    required this.scrollOffsetListenable,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobile:
          ContactMobileView(scrollOffsetListenable: scrollOffsetListenable),
      tablet: ContactMobileView(
          scrollOffsetListenable: scrollOffsetListenable), // Reuse mobile
      desktop:
          ContactDesktopView(scrollOffsetListenable: scrollOffsetListenable),
    );
  }
}
