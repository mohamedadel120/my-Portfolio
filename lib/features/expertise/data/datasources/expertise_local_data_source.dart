import 'package:flutter/material.dart';
import '../../domain/entities/expertise_entity.dart';
import '../../../../core/constants/app_colors.dart';

abstract class ExpertiseLocalDataSource {
  Future<List<Expertise>> getExpertiseAreas();
  Future<List<String>> getTechStack();
}

class ExpertiseLocalDataSourceImpl implements ExpertiseLocalDataSource {
  @override
  Future<List<Expertise>> getExpertiseAreas() async {
    return _expertiseAreas;
  }

  @override
  Future<List<String>> getTechStack() async {
    return _techStack;
  }

  static const List<Expertise> _expertiseAreas = [
    Expertise(
      title: 'Mobile Development',
      description:
          'Cross-platform Flutter apps with clean architecture, state management, and seamless user experiences.',
      icon: Icons.phone_android_rounded,
      color: AppColors.primary,
    ),
    Expertise(
      title: 'UI/UX Design',
      description:
          'Modern, intuitive interfaces with attention to detail, animations, and user-centered design principles.',
      icon: Icons.design_services_rounded,
      color: AppColors.secondary,
    ),
    Expertise(
      title: 'Backend Integration',
      description:
          'Firebase, REST APIs, and cloud services integration for scalable and robust applications.',
      icon: Icons.cloud_rounded,
      color: AppColors.primary,
    ),
    Expertise(
      title: 'Performance Optimization',
      description:
          'Code optimization, efficient state management, and smooth animations for premium app experiences.',
      icon: Icons.speed_rounded,
      color: AppColors.secondary,
    ),
  ];

  static const List<String> _techStack = [
    'Flutter',
    'Dart',
    'Bloc Pattern',
    'Firebase',
    'REST APIs',
    'SQLite',
    'Clean Architecture',
    'MVVM',
  ];
}
