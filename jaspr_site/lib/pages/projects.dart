import 'package:jaspr/jaspr.dart';

import '../components/page_meta.dart';
import '../sections/projects_section.dart';

/// Ported from `ProjectsPage`/`FeaturePageWrapper` — standalone direct-link
/// route showing just this one section.
class Projects extends StatelessComponent {
  const Projects({super.key});

  @override
  Component build(BuildContext context) => Component.fragment(const [
    PageMeta(
      path: '/projects',
      title: 'Projects - Mohamed Adel, Flutter Developer',
      description:
          'Flutter apps shipped by Mohamed Adel, including Stock (10,000+ downloads, 4.8 stars) and Gomla, live on Google Play and the App Store.',
    ),
    ProjectsSection(standalone: true),
  ]);
}
