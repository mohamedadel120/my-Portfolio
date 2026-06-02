import 'testimonial.dart';

class TestimonialModel extends Testimonial {
  const TestimonialModel({
    required super.name,
    required super.role,
    required super.company,
    required super.opinion,
    super.imageUrl,
    super.rating = 5.0,
  });

  factory TestimonialModel.fromJson(Map<String, dynamic> json) {
    final rawRating = json['rating'];
    double ratingValue = 5.0;
    if (rawRating is num) {
      ratingValue = rawRating.toDouble();
    } else if (rawRating is String) {
      ratingValue = double.tryParse(rawRating) ?? 5.0;
    }

    return TestimonialModel(
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      company: json['company'] ?? '',
      opinion: json['opinion'] ?? '',
      imageUrl: json['imageUrl'],
      rating: ratingValue,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'role': role,
      'company': company,
      'opinion': opinion,
      'imageUrl': imageUrl,
      'rating': rating,
    };
  }
}
