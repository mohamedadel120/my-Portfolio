import 'package:flutter/material.dart';
import '../../domain/entities/project_entity.dart';
import '../../../../gen/assets.gen.dart';

abstract class ProjectLocalDataSource {
  Future<List<Project>> getProjects();
}

class ProjectLocalDataSourceImpl implements ProjectLocalDataSource {
  @override
  Future<List<Project>> getProjects() async {
    // Simulate API delay if needed, but for local data it's instant
    // return Future.delayed(const Duration(milliseconds: 500), () => _projects);
    return _projects;
  }

  static final List<Project> _projects = [
    const Project(
      title: 'Hi Gold',
      description:
          'A comprehensive e-commerce platform for the Saudi Arabian gold and diamond market. Features real-time gold price updates (second-by-second), secure purchasing, and instant notifications. Built with Clean Architecture, Cubit, Google Maps, and fully automated CI/CD pipelines.',
      tech: [
        'Flutter',
        'Cubit',
        'Firebase',
        'Google Maps',
        'Clean Code',
        'CI/CD'
      ],
      color: Color(0xFFFFD700), // Gold color
      downloads: 'Coming Soon',
      logoUrl:
          'assets/images/hi_gold/image1.png', // Using copied image as logo for now
      galleryImages: [
        'assets/images/hi_gold/image1.png',
        'assets/images/hi_gold/image2.png',
        'assets/images/hi_gold/image3.png',
        'assets/images/hi_gold/image4.png',
        'assets/images/hi_gold/image5.png',
      ],
      androidStoreUrl: null,
      iosStoreUrl: null,
    ),
    Project(
      title: 'Gomla Mobile App',
      description:
          'A comprehensive e-commerce solution built with clean architecture principles. Features seamless Firebase backend integration, secure payment processing, and intuitive user experience. This app successfully reached 5,000+ downloads with outstanding 4.8-star ratings, demonstrating reliability and user satisfaction.',
      tech: const [
        'Flutter',
        'Firebase',
        'Bloc',
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
      tech: const [
        'Flutter',
        'Firebase',
        'Bloc',
        'Clean Architecture',
        'REST APIs'
      ],
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
      tech: const [
        'Flutter',
        'Firebase',
        'Bloc',
        'Clean Architecture',
        'REST APIs'
      ],
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
      tech: const ['Flutter', 'Firebase', 'Bloc', 'SQLite', 'Hive'],
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
      tech: const ['Flutter', 'Firebase', 'Bloc', 'LMS', 'Parent Control'],
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
      androidStoreUrl: null,
      iosStoreUrl: null,
    ),
    Project(
      title: 'Albatal Mobile App',
      description:
          'A full-featured marketplace platform that connects sellers and customers seamlessly. Includes robust seller dashboard for inventory management, order processing, and analytics, while providing customers with a smooth shopping experience. The platform has gained strong market traction with 10,000+ downloads and maintains excellent 4.8-star user ratings.',
      tech: const [
        'Flutter',
        'Bloc',
        'REST APIs',
        'E-commerce',
        'Seller System'
      ],
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
}
