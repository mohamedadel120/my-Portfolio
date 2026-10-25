import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:jaspr_router/jaspr_router.dart';

import 'components/custom_cursor.dart';
import 'components/header.dart';
import 'components/scroll_reveal.dart';
import 'components/visit_tracker.dart';
import 'components/project_view.dart';
import 'constants/site_design.dart';
import 'constants/theme_direction.dart';
import 'd/d_pages.dart';
import 'data/profile_repository.dart';
import 'pages/project_case_study.dart';
import 'sections/projects_section.dart';
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

    if (isDesignD) return _designD(hero.cvUrl);

    // One case study page per project, at a fixed address each: a static
    // build only generates routes it can list, so `/projects/:slug` (a
    // path parameter) would not be pre-rendered.
    final projects = await fetchProjectMaps();
    final count = projects.length;

    return div(classes: 'app-shell', [
      Header(cvUrl: hero.cvUrl),
      const ScrollReveal(),
      const VisitTracker(),
      // Today's look only. The new directions keep the system cursor: it is
      // instant, respects the visitor's own cursor size and contrast settings,
      // and never hides what is under it.
      if (!isCalm) const CustomCursor(),
      // Page content lives in <main> so screen readers can jump past the nav.
      main_([
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
            for (final (i, project) in projects.indexed)
              Route(
                path: '/projects/${project['slug']}',
                title: ProjectCaseStudy.pageTitle(ProjectView.fromMap(project)),
                builder: (context, state) => ProjectCaseStudy(
                  project: project,
                  // The list wraps around, so the last project leads back to the first.
                  previous: count > 1 ? projects[(i - 1 + count) % count] : null,
                  next: count > 1 ? projects[(i + 1) % count] : null,
                ),
              ),
            Route(
              path: '/contact',
              title: 'Contact - Mohamed Adel, Flutter Developer',
              builder: (context, state) => const Contact(),
            ),
          ],
        ),
      ]),
    ]);
  }

  /// Design D: the same addresses, its own pages (lib/d/). Every route gets
  /// the shell (progress line, header, footer); case study pages mark
  /// PROJECTS as the current section.
  Future<Component> _designD(String cvUrl) async {
    final projects = await fetchDProjects();
    final count = projects.length;
    Component page(Component content, [String? current]) => dShell(cvUrl: cvUrl, content: content, current: current);
    return div(classes: 'app-shell', [
      const VisitTracker(),
      Router(
        routes: [
          Route(path: '/', title: 'Mohamed Adel - Flutter Developer Portfolio', builder: (context, state) => page(const DHome())),
          Route(path: '/about', title: 'About - Mohamed Adel, Flutter Developer', builder: (context, state) => page(const DSection(DSectionPage.about), 'about')),
          Route(path: '/projects', title: 'Projects - Mohamed Adel, Flutter Developer', builder: (context, state) => page(const DSection(DSectionPage.projects), 'projects')),
          for (final (i, p) in projects.indexed)
            Route(
              path: '/projects/${p.slug}',
              title: DCaseStudyPage.pageTitle(p),
              builder: (context, state) => page(
                DCaseStudyPage(
                  project: p,
                  // The list wraps around, so the last project leads back to the first.
                  previous: count > 1 ? projects[(i - 1 + count) % count] : null,
                  next: count > 1 ? projects[(i + 1) % count] : null,
                ),
                'projects',
              ),
            ),
          Route(path: '/contact', title: 'Contact - Mohamed Adel, Flutter Developer', builder: (context, state) => page(const DSection(DSectionPage.contact), 'contact')),
        ],
      ),
    ]);
  }
}
