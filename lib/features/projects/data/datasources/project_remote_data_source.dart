import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/project_entity.dart';
import '../models/project_model.dart';

abstract class ProjectRemoteDataSource {
  Future<List<Project>> getProjects();
}

class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  final FirebaseFirestore firestore;

  ProjectRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<Project>> getProjects() async {
    try {
      debugPrint('Fetching Projects from FIREBASE...');
      final snapshot = await firestore.collection('projects').get();
      debugPrint(
          'Fetched ${snapshot.docs.length} Projects from FIREBASE successfully!');
      return snapshot.docs
          .map((doc) => ProjectModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Failed to load projects from Firebase: $e');
      throw Exception('Failed to load projects from Firebase: $e');
    }
  }
}
