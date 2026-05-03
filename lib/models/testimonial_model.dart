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
    return TestimonialModel(
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      company: json['company'] ?? '',
      opinion: json['opinion'] ?? '',
      imageUrl: json['imageUrl'],
      rating: (json['rating'] ?? 5.0).toDouble(),
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
