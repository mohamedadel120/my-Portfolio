import 'package:jaspr/jaspr.dart';

import '../components/page_meta.dart';
import '../sections/about_section.dart';

/// Ported from `AboutPage`/`FeaturePageWrapper` — standalone direct-link
/// route showing just this one section (matches the Flutter app's own
/// per-section standalone pages).
class About extends StatelessComponent {
  const About({super.key});

  @override
  Component build(BuildContext context) => Component.fragment(const [
    PageMeta(
      path: '/about',
      title: 'About - Mohamed Adel, Flutter Developer',
      description:
          'About Mohamed Adel, a Cairo-based Flutter developer with 3+ years building cross-platform iOS and Android apps with Clean Architecture and Bloc.',
    ),
    AboutSection(standalone: true),
  ]);
}
