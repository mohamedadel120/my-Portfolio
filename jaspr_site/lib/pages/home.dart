import 'package:jaspr/jaspr.dart';

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
