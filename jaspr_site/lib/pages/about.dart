import 'package:jaspr/jaspr.dart';

import '../sections/about_section.dart';

/// Ported from `AboutPage`/`FeaturePageWrapper` — standalone direct-link
/// route showing just this one section (matches the Flutter app's own
/// per-section standalone pages).
class About extends StatelessComponent {
  const About({super.key});

  @override
  Component build(BuildContext context) => const AboutSection();
}
