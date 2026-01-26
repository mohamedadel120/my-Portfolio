import 'package:flutter/material.dart';
import '../../../../core/navigation/feature_page_wrapper.dart';
import 'about_section.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    // About Section typically 1.0 * H (directly after Hero)
    return FeaturePageWrapper(
      title: 'About',
      virtualOffset: MediaQuery.of(context).size.height * 1.0,
      builder: (context, scrollOffsetListenable) {
        return AboutSection(
          scrollOffsetListenable: scrollOffsetListenable,
        );
      },
    );
  }
}
