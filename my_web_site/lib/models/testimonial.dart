class Testimonial {
  final String name;
  final String role;
  final String company;
  final String opinion;
  final String? imageUrl;
  final double rating;

  const Testimonial({
    required this.name,
    required this.role,
    required this.company,
    required this.opinion,
    this.imageUrl,
    this.rating = 5.0,
  });
}
