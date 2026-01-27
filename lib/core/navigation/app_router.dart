import 'package:flutter/material.dart';
import '../../core/navigation/page_transitions.dart';
import '../../features/hero/presentation/pages/hero_section.dart';
import '../../features/about/presentation/pages/about_page.dart';
import '../../features/experience/presentation/pages/experience_page.dart';
import '../../features/projects/presentation/pages/projects_page.dart';
import '../../features/contact/presentation/pages/contact_page.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        // Special case: Hero is the Home (no wrapper needed as it handles its own internal structure
        // usually, but here we just render the Section wrapped in a Page/Scaffold logic
        // or just the HeroSection itself if adapted).
        // Since HeroSection currently assumes it's part of a scroll, we might need a wrapper
        // OR we modify HeroSection to be a standalone landing page.
        // Let's assume we update HeroSection to work standalone.
        return MaterialPageRoute(builder: (_) => const _HomeWrapper());

      case '/about':
        return CodingTransition(page: const AboutPage());

      case '/experience':
        return CodingTransition(page: const ExperiencePage());

      case '/projects':
        return CodingTransition(page: const ProjectsPage());

      case '/contact':
        return CodingTransition(page: const ContactPage());

      default:
        return MaterialPageRoute(builder: (_) => const _HomeWrapper());
    }
  }
}

class _HomeWrapper extends StatefulWidget {
  const _HomeWrapper();

  @override
  State<_HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<_HomeWrapper> {
  final _scrollController = ScrollController();
  final _notifier = ValueNotifier<double>(0.0);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      _notifier.value = _scrollController.offset;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: SizedBox(
          height: MediaQuery.of(context).size.height, // Full screen only
          child: HeroSection(
            scrollOffsetListenable: _notifier,
            onViewProjects: () => Navigator.pushNamed(context, '/projects'),
            onContactMe: () => Navigator.pushNamed(context, '/contact'),
            // We'll update HeroSection to add more callbacks or just buttons
          ),
        ),
      ),
    );
  }
}
