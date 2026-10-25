import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import '../components/contact_form.dart';
import '../components/page_meta.dart';
import '../data/contact_repository.dart';
import '../data/experience_repository.dart';
import '../data/profile_repository.dart';
import '../data/projects_repository.dart';
import '../sections/projects_section.dart' show projectMaps;
import 'd_markup.dart';
import 'd_project.dart';

/// Every project, in the site's order, with the same page addresses the
/// rest of the site uses (projectMaps adds the unique slugs).
Future<List<DProject>> fetchDProjects() async {
  final items = await fetchProjects();
  final maps = projectMaps(items);
  return [for (final (i, item) in items.indexed) DProject(item, maps[i]['slug'] as String)];
}

/// The home page: hero, projects, experience, about, contact.
class DHome extends AsyncStatelessComponent {
  const DHome({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final projects = await fetchDProjects();
    final jobs = await fetchExperiences();
    final about = await fetchAboutData();
    final contact = await fetchContactData();
    return Component.fragment([
      const PageMeta(
        path: '/',
        title: 'Mohamed Adel - Flutter Developer Portfolio',
        description:
            'Mohamed Adel, Flutter developer in Cairo with 3+ years shipping iOS and Android apps. Gomla and Stock: 10,000+ downloads each. Download the CV or get in touch.',
      ),
      RawText([
        dHero(scene: heroProject(projects), location: contact.location.isEmpty ? 'Cairo, Egypt' : contact.location),
        dProjects(projects),
        dExperience(jobs),
        dAbout(about),
        dContact(contact, formKey: web3FormsAccessKey),
      ].join('\n')),
    ]);
  }
}

/// /projects, /about and /contact: one section each, titled with the page's h1.
enum DSectionPage { projects, about, contact }

class DSection extends AsyncStatelessComponent {
  final DSectionPage page;
  const DSection(this.page, {super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final (meta, html) = switch (page) {
      DSectionPage.projects => (
        const PageMeta(path: '/projects', title: 'Projects - Mohamed Adel, Flutter Developer', description: 'Flutter apps by Mohamed Adel for Android and iOS, with their real screens, stacks and store listings.'),
        dProjects(await fetchDProjects(), standalone: true),
      ),
      DSectionPage.about => (
        const PageMeta(path: '/about', title: 'About - Mohamed Adel, Flutter Developer', description: 'Mohamed Adel, Flutter developer in Cairo: experience, skills and the stack behind the apps.'),
        '${dAbout(await fetchAboutData(), standalone: true)}\n${dExperience(await fetchExperiences())}',
      ),
      DSectionPage.contact => (
        const PageMeta(path: '/contact', title: 'Contact - Mohamed Adel, Flutter Developer', description: 'Get in touch with Mohamed Adel about a Flutter app for Android and iOS.'),
        dContact(await fetchContactData(), formKey: web3FormsAccessKey, standalone: true),
      ),
    };
    return Component.fragment([meta, RawText(html)]);
  }
}

/// One project's case study page.
class DCaseStudyPage extends StatelessComponent {
  final DProject project;
  final DProject? previous;
  final DProject? next;
  const DCaseStudyPage({required this.project, this.previous, this.next, super.key});

  static String pageTitle(DProject p) => '${p.title} case study - Mohamed Adel';

  @override
  Component build(BuildContext context) {
    final p = project;
    final first = p.overview.split(RegExp(r'(?<=\.)\s')).first;
    return Component.fragment([
      PageMeta(path: '/projects/${p.slug}', title: pageTitle(p), description: first.length > 160 ? '${first.substring(0, 157)}...' : first),
      RawText(dCaseStudy(p, prev: previous, next: next)),
    ]);
  }
}

/// The page shell around every route: progress line, header, footer.
Component dShell({required String cvUrl, required Component content, String? current}) => Component.fragment([
  RawText(dHeader(cvUrl: cvUrl, current: current)),
  main_([content]),
  RawText(dFooter()),
]);
