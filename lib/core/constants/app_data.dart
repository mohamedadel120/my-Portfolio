import 'package:flutter/material.dart';
import '../../models/why_choose_me_reason.dart';
import '../../models/testimonial.dart';
import 'app_colors.dart';

class AppData {
  // Projects data moved to features/projects/data/datasources/project_local_data_source.dart
  // Experience data moved to features/experience/data/datasources/experience_local_data_source.dart

  static const String name = 'Mohamed Adel';
  static const String title = 'Flutter Developer';
  static const String subtitle = '3+ Years Experience';
  static const String description =
      'Building Scalable Cross-Platform Mobile Applications';
  static const String professionalSummary =
      'Flutter Developer with 3+ years of experience in designing and deploying scalable, cross-platform mobile applications. Proficient in clean architecture, state management (Bloc/Provider), and API integrations. Proven ability to deliver high-performing applications with 10,000+ downloads and 4.8-star ratings on Google Play.';

  static const String email = 'muhammed.adel611@gmail.com';
  static const String phone = '+201000490576';
  static const String location =
      '5 helme Soliman street El Mataria Cairo, Egypt';
  static const String cvUrl =
      'https://drive.google.com/file/d/1TTitZq8kB_JfxM2A9MpHiysMYy0hJxOV/view?usp=drive_link';

  // Why Choose Me reasons
  static const List<WhyChooseMeReason> whyChooseMeReasons = [
    WhyChooseMeReason(
      title: 'Clean & Maintainable Code',
      description:
          'I write clean, well-documented code following best practices and design patterns. Your codebase will be maintainable, scalable, and easy for your team to understand and extend.',
      icon: Icons.code_rounded,
      color: AppColors.primary,
    ),
    WhyChooseMeReason(
      title: 'Performance Optimization',
      description:
          'I optimize apps for speed and efficiency. Reduced load times by 20-30% in multiple projects, ensuring smooth user experiences even with complex features.',
      icon: Icons.speed_rounded,
      color: AppColors.secondary,
    ),
    WhyChooseMeReason(
      title: 'Cross-Platform Expertise',
      description:
          'Build once, deploy everywhere. I specialize in Flutter development, delivering native-quality apps for both iOS and Android from a single codebase.',
      icon: Icons.phone_android_rounded,
      color: AppColors.primary,
    ),
    WhyChooseMeReason(
      title: 'Proven Track Record',
      description:
          '10,000+ downloads, 4.8-star ratings, and successful projects across various industries. I deliver results that matter to your business.',
      icon: Icons.star_rounded,
      color: AppColors.secondary,
    ),
    WhyChooseMeReason(
      title: 'Modern Architecture',
      description:
          'I implement clean architecture, MVVM, and proper state management (Bloc/Riverpod) to ensure your app is scalable, testable, and future-proof.',
      icon: Icons.architecture_rounded,
      color: AppColors.primary,
    ),
    WhyChooseMeReason(
      title: 'Team Collaboration',
      description:
          'I work seamlessly with teams, communicate clearly, and manage code effectively. Your team will enjoy working with me, and the code will be easy to maintain.',
      icon: Icons.people_rounded,
      color: AppColors.secondary,
    ),
  ];

  // Testimonials/Opinions
  static const List<Testimonial> testimonials = [
    Testimonial(
      name: 'Ahmed Hassan',
      role: 'Project Manager',
      company: 'Stock Tech',
      opinion:
          'Mohamed is an exceptional Flutter developer. His code is clean, well-organized, and follows best practices. He consistently delivered high-quality work on time and was always proactive in suggesting improvements. Working with him was a pleasure, and the apps he built achieved great success with 10,000+ downloads.',
      rating: 5.0,
    ),
    Testimonial(
      name: 'Sarah Mohamed',
      role: 'Tech Lead',
      company: 'Gomla',
      opinion:
          'Mohamed\'s approach to code management is outstanding. He writes maintainable code that our team can easily understand and extend. His use of clean architecture and proper state management made our app scalable and performant. He reduced our app load time by 25%, which significantly improved user experience.',
      rating: 5.0,
    ),
    Testimonial(
      name: 'Omar Ali',
      role: 'CEO',
      company: 'The First-Agency',
      opinion:
          'Working with Mohamed has been fantastic. He\'s not just a developer, but a problem solver. His ability to manage complex projects, communicate effectively with the team, and deliver on time is remarkable. The apps he built for us have been highly successful, and we continue to work with him on new projects.',
      rating: 5.0,
    ),
    Testimonial(
      name: 'Jane Doe',
      role: 'Senior Tech Lead',
      company: 'TechFlow Systems',
      opinion:
          'Mohamed\'s code is exceptionally clean and maintainable. He delivered features ahead of schedule with remarkable speed and quality. His expertise in Clean Architecture truly sets him apart as a senior-level Flutter developer.',
      rating: 5.0,
    ),
  ];
}
