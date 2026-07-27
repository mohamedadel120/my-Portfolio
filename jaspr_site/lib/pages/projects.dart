import 'package:jaspr/jaspr.dart';

import '../sections/projects_section.dart';

/// Ported from `ProjectsPage`/`FeaturePageWrapper` — standalone direct-link
/// route showing just this one section.
class Projects extends StatelessComponent {
  const Projects({super.key});

  @override
  Component build(BuildContext context) => const ProjectsSection();
}
