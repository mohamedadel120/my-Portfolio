import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/hero_entity.dart';

abstract class HeroRemoteDataSource {
  Future<HeroData> getHeroData();
}

class HeroRemoteDataSourceImpl implements HeroRemoteDataSource {
  final FirebaseFirestore firestore;

  HeroRemoteDataSourceImpl({required this.firestore});

  @override
  Future<HeroData> getHeroData() async {
    try {
      debugPrint('Fetching Hero Data from FIREBASE...');
      final doc = await firestore.collection('profile_info').doc('main').get();
      if (!doc.exists) {
        throw Exception('Profile info not found');
      }
      final data = doc.data()!;
      debugPrint('Fetched Hero Data from FIREBASE successfully!');
      
      return HeroData(
        name: data['name'] ?? '',
        title: data['title'] ?? '',
        subtitle: data['subtitle'] ?? '',
        helloGreeting: "HELLO I'M", // Kept local for now
        showAurora: true,
        cvUrl: data['cvUrl'] ?? '',
      );
    } catch (e) {
      debugPrint('Failed to load hero data from Firebase: $e');
      throw Exception('Failed to load hero data from Firebase: $e');
    }
  }
}
