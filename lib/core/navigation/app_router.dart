import 'package:flutter/material.dart';
import '../../core/navigation/page_transitions.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/about/presentation/pages/about_page.dart';
import '../../features/experience/presentation/pages/experience_page.dart';
import '../../features/projects/presentation/pages/projects_page.dart';
import '../../features/contact/presentation/pages/contact_page.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        // Single Page Layout - All sections in one scrollable view
        return MaterialPageRoute(builder: (_) => const HomePage());

      case '/about':
        return CodingTransition(page: const AboutPage());

      case '/experience':
        return CodingTransition(page: const ExperiencePage());

      case '/projects':
        return CodingTransition(page: const ProjectsPage());

      case '/contact':
        return CodingTransition(page: const ContactPage());

      default:
        return MaterialPageRoute(builder: (_) => const HomePage());
    }
  }
}
