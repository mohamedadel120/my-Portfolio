import 'package:jaspr/jaspr.dart';

import '../components/page_meta.dart';
import '../sections/about_section.dart';
import '../sections/contact_section.dart';
import '../sections/expertise_section.dart';
import '../sections/experience_section.dart';
import '../sections/hero_section.dart';
import '../sections/projects_section.dart';
import '../sections/testimonials_section.dart';
import '../sections/why_choose_me_section.dart';

class Home extends StatelessComponent {
  const Home({super.key});

  @override
  Component build(BuildContext context) {
    return Component.fragment(const [
      PageMeta(
        path: '/',
        title: 'Mohamed Adel - Flutter Developer Portfolio',
        description:
            'Mohamed Adel, Flutter developer in Cairo with 3+ years shipping iOS and Android apps. Stock: 10,000+ downloads, 4.8 stars. Download the CV or get in touch.',
      ),
      HeroSection(),
      AboutSection(),
      ExpertiseSection(),
      WhyChooseMeSection(),
      ExperienceSection(),
      ProjectsSection(),
      TestimonialsSection(),
      ContactSection(),
    ]);
  }
}
