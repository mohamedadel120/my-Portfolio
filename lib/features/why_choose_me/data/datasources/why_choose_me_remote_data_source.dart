import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/why_choose_me_reason_model.dart';

abstract class WhyChooseMeRemoteDataSource {
  Future<List<WhyChooseMeReasonModel>> getReasons();
}

class WhyChooseMeRemoteDataSourceImpl implements WhyChooseMeRemoteDataSource {
  final FirebaseFirestore firestore;

  WhyChooseMeRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<WhyChooseMeReasonModel>> getReasons() async {
    try {
      final snapshot = await firestore.collection('why_choose_me').get();
      debugPrint('Fetched ${snapshot.docs.length} why choose me reasons from Firebase');
      return snapshot.docs
          .map((doc) => WhyChooseMeReasonModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error fetching why choose me reasons: $e');
      throw Exception('Failed to fetch why choose me reasons');
    }
  }
}
