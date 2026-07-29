import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:jaspr_router/jaspr_router.dart';

import 'components/custom_cursor.dart';
import 'components/header.dart';
import 'components/scroll_reveal.dart';
import 'data/profile_repository.dart';
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
class App extends AsyncStatelessComponent {
  const App({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    // Fetched here (not inside Header itself) because Header is a @client
    // island mounted once at the root, outside the router -- same
    // profile_info/main document HeroSection already reads for name/title,
    // just also pulling cvUrl this time so the nav's "DOWNLOAD CV" button
    // has a real link instead of the placeholder href="#" it shipped with.
    final hero = await fetchHeroData();

    return div(classes: 'app-shell', [
      Header(cvUrl: hero.cvUrl),
      const ScrollReveal(),
      const CustomCursor(),
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
