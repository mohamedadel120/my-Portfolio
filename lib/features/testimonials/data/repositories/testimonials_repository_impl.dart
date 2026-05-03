import '../../../../models/testimonial.dart';
import '../../domain/repositories/testimonials_repository.dart';
import '../datasources/testimonials_remote_data_source.dart';

class TestimonialsRepositoryImpl implements TestimonialsRepository {
  final TestimonialsRemoteDataSource remoteDataSource;

  TestimonialsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Testimonial>> getTestimonials() async {
    return await remoteDataSource.getTestimonials();
  }
}
