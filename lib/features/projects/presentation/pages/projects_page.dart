import 'package:flutter/material.dart';
import '../../../../core/navigation/feature_page_wrapper.dart';
import 'projects_section.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Projects Section expects sectionStartOffset = viewportHeight * 4
    // We must pass a virtual offset of 4 * H
    return FeaturePageWrapper(
      title: 'Projects',
      virtualOffset: MediaQuery.of(context).size.height * 4,
      builder: (context, scrollOffsetListenable) {
        return ProjectsSection(
          scrollOffsetListenable: scrollOffsetListenable,
        );
      },
    );
  }
}
