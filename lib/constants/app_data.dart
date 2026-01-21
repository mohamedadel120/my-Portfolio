import 'package:flutter/material.dart';
import '../models/project.dart';
import '../models/experience.dart';
import '../models/why_choose_me_reason.dart';
import '../models/testimonial.dart';
import '../gen/assets.gen.dart';
import 'app_colors.dart';

class AppData {
  static final List<Project> projects = [
    Project(
      title: 'Gomla Mobile App',
      description:
          'A comprehensive e-commerce solution built with clean architecture principles. Features seamless Firebase backend integration, secure payment processing, and intuitive user experience. This app successfully reached 5,000+ downloads with outstanding 4.8-star ratings, demonstrating reliability and user satisfaction.',
      tech: [
        'Flutter',
        'Firebase',
        'Riverpod',
        'Clean Architecture',
        'Payment Gateway',
      ],
      color: const Color(0xFF00D9FF),
      downloads: '10,000+',
      logoUrl: Assets.images.gomla.logo.path,
      galleryImages: [
        Assets.images.gomla.image1.path,
        Assets.images.gomla.image2.path,
        Assets.images.gomla.image3.path,
        Assets.images.gomla.image4.path,
      ],
      androidStoreUrl:
          'https://play.google.com/store/apps/details?id=com.gomla.store',
      iosStoreUrl: 'https://apps.apple.com/eg/app/go-gomla/id6742806281',
    ),
    Project(
      title: 'Stock Mobile App',
      description:
          'A powerful B2B inventory management platform designed for businesses to efficiently track and manage their stock. Built with clean architecture and Bloc pattern for scalable state management. The app achieved remarkable success with 10,000+ downloads and maintains 4.8-star ratings across both Google Play and iOS platforms.',
      tech: ['Flutter', 'Firebase', 'Bloc', 'Clean Architecture', 'REST APIs'],
      color: const Color(0xFF7B2CBF),
      downloads: '10,000+',
      logoUrl: Assets.images.stock.logo.path,
      galleryImages: [
        Assets.images.stock.logo.path,
        Assets.images.stock.image1.path,
        Assets.images.stock.image2.path,
        Assets.images.stock.image3.path,
        Assets.images.stock.image4.path,
        Assets.images.stock.image5.path,
        Assets.images.stock.image6.path,
        Assets.images.stock.image7.path,
        Assets.images.stock.image8.path,
      ],
      androidStoreUrl:
          'https://play.google.com/store/apps/details?id=com.spark.stockclientapp',
      iosStoreUrl: 'https://apps.apple.com/eg/app/stock-b2b/id1639101527',
    ),
    Project(
      title: 'Palleta Mobile App',
      description:
          'An innovative mobile application designed for modern businesses. Built with Flutter and clean architecture principles, Palleta offers a seamless user experience with robust performance. The app features intuitive design, efficient state management using Bloc pattern, and seamless integration with Firebase backend services.',
      tech: ['Flutter', 'Firebase', 'Bloc', 'Clean Architecture', 'REST APIs'],
      color: const Color(0xFF00D9FF),
      downloads: 'Active Development',
      logoUrl: Assets.images.paletta.logo.path,
      galleryImages: [
        // Assets.images.paletta.logo.path,
        Assets.images.paletta.image1.path,
        Assets.images.paletta.image2.path,
        Assets.images.paletta.image3.path,
        Assets.images.paletta.image4.path,
        Assets.images.paletta.image5.path,
        Assets.images.paletta.image6.path,
        Assets.images.paletta.image7.path,
      ],
      androidStoreUrl:
          'https://play.google.com/store/apps/details?id=com.spark.palettalientapp',
    ),
    Project(
      title: 'DrugZa - TagPharma',
      description:
          'A specialized healthcare application connecting patients with pharmaceutical services. Features local data storage using SQLite and Hive for offline functionality, ensuring seamless access to medical information. The intuitive design and user-centric approach resulted in a significant 35% increase in customer engagement.',
      tech: ['Flutter', 'Firebase', 'Bloc', 'SQLite', 'Hive'],
      androidStoreUrl:
          'https://play.google.com/store/apps/details?id=com.app.drugza',
      color: const Color(0xFF00D9FF),
      videoUrl: Assets.videos.drugzaDemo,
      downloads: 'High Engagement',
    ),
    const Project(
      title: 'Ringo - Shahabander',
      description:
          'An advanced wholesale e-commerce platform designed for bulk trading operations. Integrated comprehensive shipment tracking and streamlined checkout processes to dramatically improve business efficiency. The solution delivered impressive results: a 60% boost in sales performance and 40% improvement in operational speed.',
      tech: ['Flutter', 'Firebase', 'Bloc', 'REST APIs', 'E-commerce'],
      color: Color(0xFF7B2CBF),
      downloads: '90% Enhancement',
    ),
    Project(
      title: 'Adruse Mobile App',
      description:
          'A comprehensive Learning Management System (LMS) designed to revolutionize the educational experience. Features interactive learning modules, real-time progress tracking, and dedicated parent portal for monitoring student performance. The platform simplifies education management while providing complete control and transparency for all stakeholders.',
      tech: ['Flutter', 'Firebase', 'Bloc', 'LMS', 'Parent Control'],
      color: const Color(0xFF00D9FF),
      downloads: 'LMS Platform',
      logoUrl: Assets.images.adruse.login.path,
      galleryImages: [
        Assets.images.adruse.login.path,
        Assets.images.adruse.primary1.path,
        Assets.images.adruse.primary11.path,
        Assets.images.adruse.primary12.path,
        Assets.images.adruse.primary13.path,
        Assets.images.adruse.primary14.path,
        Assets.images.adruse.primary3Subjects1.path,
        Assets.images.adruse.primary4SubjectCourcePage1.path,
        Assets.images.adruse.primary4SubjectCourcePage5.path,
        Assets.images.adruse.profile.path,
        Assets.images.adruse.sideMenu.path,
        Assets.images.adruse.subscribe.path,
      ],
      androidStoreUrl:
          'https://play.google.com/store/apps/details?id=com.example.adruse',
      iosStoreUrl: 'https://apps.apple.com/app/adruse/id123456789',
    ),
    Project(
      title: 'Albatal Mobile App',
      description:
          'A full-featured marketplace platform that connects sellers and customers seamlessly. Includes robust seller dashboard for inventory management, order processing, and analytics, while providing customers with a smooth shopping experience. The platform has gained strong market traction with 10,000+ downloads and maintains excellent 4.8-star user ratings.',
      tech: ['Flutter', 'Bloc', 'REST APIs', 'E-commerce', 'Seller System'],
      androidStoreUrl:
          'https://play.google.com/store/apps/details?id=com.albatal.alba',
      color: const Color(0xFF7B2CBF),
      downloads: '5,000+',
      galleryImages: [
        Assets.images.albatal.image1.path,
        Assets.images.albatal.image2.path,
        Assets.images.albatal.image3.path,
        Assets.images.albatal.image4.path,
        Assets.images.albatal.image5.path,
        Assets.images.albatal.image6.path,
        Assets.images.albatal.image7.path,
        Assets.images.albatal.image17.path,
      ],
    ),
  ];

  static const List<Experience> experiences = [
    Experience(
      company: 'The First-Agency',
      role: 'Flutter Developer',
      period: '2025 – now',
      achievements: [
        'Led the design and implementation of Tolet Mobile App',
        'Added maintenance in the High-gold Mobile App',
      ],
    ),
    Experience(
      company: 'Gomla',
      role: 'Flutter Developer (Part-time)',
      period: '2024 – 2025',
      achievements: [
        'Enhanced the design and redesigned screens in Gomla-Mobile App',
        'Reduced app load time by 25% through performance optimization using RiverPod',
      ],
    ),
    Experience(
      company: 'Stock Tech',
      role: 'Flutter Developer',
      period: '2024 – 2025',
      achievements: [
        'Led the design and implementation of Palleta Mobile App',
        'Led design and maintenance of Stock App (B2B), achieving 10,000+ downloads and 4.8-star rating',
        'Delivered Tag-pharma & DrugZa Mobile App with 35% increase in customer engagement',
        'Reduced app load time by 20% through performance optimization using Bloc',
      ],
    ),
    Experience(
      company: 'Freelance (Many Companies)',
      role: 'Flutter Developer',
      period: '2023 - 2024',
      achievements: [
        'Developed and deployed 10+ cross-platform mobile applications',
        'Optimized app performance by 30% through debugging and code refactoring',
        'Improved user engagement by 35% through intuitive UI/UX design',
      ],
    ),
    Experience(
      company: 'Innovation Company',
      role: 'Flutter Developer',
      period: '2022 – 2023',
      achievements: [
        'Led design and implementation of Al-Taqwa Mobile App (1,000+ downloads, 4.8-star rating)',
        'Delivered Global Dent Mobile App with 35% increase in customer engagement',
        'Reduced app load time by 20% through performance optimization',
      ],
    ),
  ];

  static const String name = 'Mohamed Adel';
  static const String title = 'Flutter Developer';
  static const String subtitle = '3+ Years Experience';
  static const String description =
      'Building Scalable Cross-Platform Mobile Applications';
  static const String professionalSummary =
      'Flutter Developer with 3+ years of experience in designing and deploying scalable, cross-platform mobile applications. Proficient in clean architecture, state management (Bloc/Provider), and API integrations. Proven ability to deliver high-performing applications with 10,000+ downloads and 4.8-star ratings on Google Play.';

  static const List<String> techStack = [
    'Flutter',
    'Dart',
    'Bloc Pattern',
    'Firebase',
    'REST APIs',
    'SQLite',
    'Clean Architecture',
    'MVVM',
  ];

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
