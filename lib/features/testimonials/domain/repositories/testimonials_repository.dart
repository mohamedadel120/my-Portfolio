import '../../../../models/testimonial.dart';

abstract class TestimonialsRepository {
  Future<List<Testimonial>> getTestimonials();
}
