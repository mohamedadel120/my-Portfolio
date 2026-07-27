import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import 'components/header.dart';
import 'components/scroll_reveal.dart';
import 'pages/home.dart';
import 'pages/about.dart';
import 'pages/projects.dart';
import 'pages/contact.dart';

/// Root routing skeleton (Phase 0). `/` is the single-page scroll experience
/// (hero -> about -> expertise -> experience -> projects -> contact, same UX
/// as the Flutter site today); `/about`, `/projects`, `/contact` are real
/// routes so each pre-renders as its own static HTML file — better for
/// direct links/SEO than the Flutter SPA, which serves the same shell for
/// every route. Page content for each is filled in during later phases.
class App extends StatelessComponent {
  const App({super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'app-shell', [
      const Header(),
      const ScrollReveal(),
      Router(
        routes: [
          Route(
            path: '/',
            title: 'Mohamed Adel - Flutter Developer Portfolio',
            builder: (context, state) => const Home(),
          ),
          Route(
            path: '/about',
            title: 'About - Mohamed Adel, Flutter Developer',
            builder: (context, state) => const About(),
          ),
          Route(
            path: '/projects',
            title: 'Projects - Mohamed Adel, Flutter Developer',
            builder: (context, state) => const Projects(),
          ),
          Route(
            path: '/contact',
            title: 'Contact - Mohamed Adel, Flutter Developer',
            builder: (context, state) => const Contact(),
          ),
        ],
      ),
    ]);
  }
}
