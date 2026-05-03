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
      
      return AboutData(
        title: 'About Me',
        professionalSummary: data['professionalSummary'] ?? '',
        downloadsCount: '10k+',
        ratings: '4.8',
        yearsExperience: '3+',
        features: const [
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
        skills: const [
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
        ],
      );
    } catch (e) {
      debugPrint('Failed to load about data from Firebase: $e');
      throw Exception('Failed to load about data from Firebase: $e');
    }
  }
}
