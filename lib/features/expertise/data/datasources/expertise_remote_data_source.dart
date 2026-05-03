import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/expertise_model.dart';

abstract class ExpertiseRemoteDataSource {
  Future<List<ExpertiseModel>> getExpertiseAreas();
  Future<List<String>> getTechStack();
}

class ExpertiseRemoteDataSourceImpl implements ExpertiseRemoteDataSource {
  final FirebaseFirestore firestore;

  ExpertiseRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<ExpertiseModel>> getExpertiseAreas() async {
    try {
      final snapshot = await firestore.collection('expertise').get();
      debugPrint('Fetched ${snapshot.docs.length} expertise from Firebase');
      return snapshot.docs
          .map((doc) => ExpertiseModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error fetching expertise: $e');
      throw Exception('Failed to fetch expertise');
    }
  }

  @override
  Future<List<String>> getTechStack() async {
    try {
      final doc = await firestore.collection('profile_info').doc('tech_stack').get();
      if (doc.exists && doc.data() != null && doc.data()!['items'] != null) {
        return List<String>.from(doc.data()!['items']);
      }
      return [];
    } catch (e) {
      debugPrint('Error fetching tech stack: $e');
      throw Exception('Failed to fetch tech stack');
    }
  }
}
