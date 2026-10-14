import 'package:jaspr/jaspr.dart';

import '../components/page_meta.dart';
import '../constants/home_layout.dart';
import '../sections/about_brief_section.dart';
import '../sections/about_section.dart';
import '../sections/contact_section.dart';
import '../sections/expertise_section.dart';
import '../sections/experience_section.dart';
import '../sections/hero_section.dart';
import '../sections/projects_section.dart';
import '../sections/testimonials_section.dart';
import '../sections/why_choose_me_section.dart';

class Home extends StatelessComponent {
  /// Which structure to render. Defaults to [homeLayout]; tests can pass
  /// another one explicitly.
  final HomeLayout layout;

  const Home({super.key, this.layout = homeLayout});

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      const PageMeta(
        path: '/',
        title: 'Mohamed Adel - Flutter Developer Portfolio',
        description:
            'Mohamed Adel, Flutter developer in Cairo with 3+ years shipping iOS and Android apps. Gomla and Stock: 10,000+ downloads each. Download the CV or get in touch.',
      ),
      ...sections(layout),
    ]);
  }

  /// The page's sections, top to bottom. Public so tests can check the order
  /// without fetching anything.
  static List<Component> sections(HomeLayout layout) => switch (layout) {
    HomeLayout.v1 => const [
      HeroSection(layout: HomeLayout.v1),
      AboutSection(),
      ExpertiseSection(),
      WhyChooseMeSection(),
      ExperienceSection(),
      ProjectsSection(),
      TestimonialsSection(),
      ContactSection(),
    ],
    // The proof (Projects) comes straight after the promise (Hero). About sits
    // after Experience: the apps and the jobs they came from read as one
    // story, and the skills recap is there for whoever wants to check the
    // stack before the testimonials and the contact form.
    HomeLayout.v2 => const [
      HeroSection(layout: HomeLayout.v2),
      ProjectsSection(),
      ExperienceSection(),
      AboutBriefSection(),
      TestimonialsSection(),
      ContactSection(),
    ],
  };
}
