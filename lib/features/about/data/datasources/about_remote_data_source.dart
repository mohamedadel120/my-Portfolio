import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/about_entity.dart';

abstract class AboutRemoteDataSource {
  Future<AboutData> getAboutData();
}

class AboutRemoteDataSourceImpl implements AboutRemoteDataSource {
  final FirebaseFirestore firestore;

  AboutRemoteDataSourceImpl({required this.firestore});

  @override
  Future<AboutData> getAboutData() async {
    try {
      debugPrint('Fetching About Data from FIREBASE...');
      final doc = await firestore.collection('profile_info').doc('main').get();
      if (!doc.exists) {
        throw Exception('Profile info not found');
      }
      final data = doc.data()!;
      debugPrint('Fetched About Data from FIREBASE successfully!');
      final remoteFeatures = data['features'] as List<dynamic>?;
      final remoteSkills = data['skills'] as List<dynamic>?;

      return AboutData(
        title: data['title'] ?? 'About Me',
        professionalSummary: data['professionalSummary'] ?? '',
        downloadsCount: data['downloadsCount'] ?? '10k+',
        ratings: data['ratings'] ?? '4.8',
        yearsExperience: data['yearsExperience'] ?? '3+',
        features: remoteFeatures != null 
          ? remoteFeatures.map((e) => AboutFeature(
              title: e['title'] ?? '',
              description: e['description'] ?? '',
              iconCode: e['iconCode'] ?? '',
            )).toList()
          : const [
          AboutFeature(
            title: 'Clean Code',
            description:
                'Writing maintainable, scalable, and well-documented code that teams love to work with.',
            iconCode: 'code_rounded',
          ),
          AboutFeature(
            title: 'Performance',
            description:
                'Optimizing for 60fps and lightning-fast load times. I make sure your users never wait.',
            iconCode: 'rocket_launch_rounded',
          ),
          AboutFeature(
            title: 'Architecture',
            description:
                'Robust Clean Architecture and MVVM patterns for enterprise-grade scalability.',
            iconCode: 'architecture_rounded',
          ),
          AboutFeature(
            title: 'Responsive',
            description:
                'Pixel-perfect experiences across all device categories, from mobile to desktop.',
            iconCode: 'devices_rounded',
          ),
        ],
        skills: remoteSkills != null
          ? remoteSkills.map((e) => TechnicalSkill(
              name: e['name'] ?? '',
              progress: (e['progress'] ?? 0.0).toDouble(),
              isPrimary: e['isPrimary'] ?? false,
            )).toList()
          : const [
          TechnicalSkill(
            name: 'Flutter & Dart',
            progress: 0.95,
            isPrimary: true,
          ),
          TechnicalSkill(
            name: 'Clean Architecture & Bloc',
            progress: 0.90,
            isPrimary: true,
          ),
          TechnicalSkill(
            name: 'Firebase & REST APIs',
            progress: 0.88,
            isPrimary: false,
          ),
          TechnicalSkill(
            name: 'UI/UX Animations',
            progress: 0.85,
            isPrimary: false,
          ),
          TechnicalSkill(
            name: 'CI/CD & DevOps',
            progress: 0.80,
            isPrimary: false,
          ),
          TechnicalSkill(
            name: 'State Management (Bloc, Cubit)',
            progress: 0.92,
            isPrimary: true,
          ),
          TechnicalSkill(
            name: 'Supabase',
            progress: 0.85,
            isPrimary: false,
          ),
          TechnicalSkill(
            name: 'Responsive UI Design',
            progress: 0.90,
            isPrimary: true,
          ),
          TechnicalSkill(
            name: 'UI/UX Animations',
            progress: 0.85,
            isPrimary: false,
          ),
          TechnicalSkill(
            name: 'CI/CD & DevOps',
            progress: 0.80,
            isPrimary: false,
          ),
          TechnicalSkill(
            name: 'API Integration (GraphQL)',
            progress: 0.82,
            isPrimary: false,
          ),
        ],
      );
    } catch (e) {
      debugPrint('Failed to load about data from Firebase: $e');
      throw Exception('Failed to load about data from Firebase: $e');
    }
  }
}
