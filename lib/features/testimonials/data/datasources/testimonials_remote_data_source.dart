import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../../../models/testimonial_model.dart';

abstract class TestimonialsRemoteDataSource {
  Future<List<TestimonialModel>> getTestimonials();
}

class TestimonialsRemoteDataSourceImpl implements TestimonialsRemoteDataSource {
  final FirebaseFirestore firestore;

  TestimonialsRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<TestimonialModel>> getTestimonials() async {
    try {
      final snapshot = await firestore.collection('testimonials').get();
      debugPrint('Fetched ${snapshot.docs.length} testimonials from Firebase');
      return snapshot.docs
          .map((doc) => TestimonialModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error fetching testimonials: $e');
      throw Exception('Failed to fetch testimonials');
    }
  }
}
