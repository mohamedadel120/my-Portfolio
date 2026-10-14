import 'firestore_rest.dart';

const _firestore = FirestoreRest('my-website-bf9e6');

class Testimonial {
  final String name;
  final String role;
  final String company;
  final String opinion;
  final double rating;

  const Testimonial({
    required this.name,
    required this.role,
    required this.company,
    required this.opinion,
    required this.rating,
  });
}

Future<List<Testimonial>> fetchTestimonials() async {
  final docs = await _firestore.getCollection('testimonials');
  return docs.map((json) {
    // Same lenient parsing as the Flutter app's `TestimonialModel.fromJson`.
    final rawRating = json['rating'];
    final rating = rawRating is num
        ? rawRating.toDouble()
        : (rawRating is String ? double.tryParse(rawRating) : null) ?? 5.0;
    return Testimonial(
      name: json['name'] as String? ?? '',
      role: json['role'] as String? ?? '',
      company: json['company'] as String? ?? '',
      opinion: json['opinion'] as String? ?? '',
      rating: rating.clamp(0, 5).toDouble(),
    );
  }).toList();
}
