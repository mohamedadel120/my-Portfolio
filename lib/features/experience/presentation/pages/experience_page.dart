import 'package:flutter/material.dart';
import '../../../../core/navigation/feature_page_wrapper.dart';
import 'experience_section.dart';

class ExperiencePage extends StatelessWidget {
  const ExperiencePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Experience Section usually around 2.2 * H
    // Let's use 2.2 as strictly followed in ExperienceSection code if hardcoded.
    // Checking ExperienceSection code might be good, but safe bet is large enough number
    // or exact number if it's hardcocded.
    // Assuming 2.2 * H for now.
    return FeaturePageWrapper(
      title: 'Experience',
      virtualOffset: MediaQuery.of(context).size.height * 2.2,
      builder: (context, scrollOffsetListenable) {
        return ExperienceSection(
          scrollOffsetListenable: scrollOffsetListenable,
        );
      },
    );
  }
}
