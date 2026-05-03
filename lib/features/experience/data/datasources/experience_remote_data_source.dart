import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/experience_entity.dart';
import '../models/experience_model.dart';

abstract class ExperienceRemoteDataSource {
  Future<List<Experience>> getExperiences();
}

class ExperienceRemoteDataSourceImpl implements ExperienceRemoteDataSource {
  final FirebaseFirestore firestore;

  ExperienceRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<Experience>> getExperiences() async {
    try {
      debugPrint('Fetching Experiences from FIREBASE...');
      final snapshot = await firestore.collection('experiences').get();
      debugPrint('Fetched ${snapshot.docs.length} Experiences from FIREBASE successfully!');
      return snapshot.docs.map((doc) => ExperienceModel.fromJson(doc.data())).toList();
    } catch (e) {
      debugPrint('Failed to load experiences from Firebase: $e');
      throw Exception('Failed to load experiences from Firebase: $e');
    }
  }
}
