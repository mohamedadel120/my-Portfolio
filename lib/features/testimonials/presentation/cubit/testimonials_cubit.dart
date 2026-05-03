import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/testimonials_repository.dart';
import 'testimonials_state.dart';

class TestimonialsCubit extends Cubit<TestimonialsState> {
  final TestimonialsRepository repository;

  TestimonialsCubit({required this.repository}) : super(TestimonialsInitial());

  Future<void> loadTestimonials() async {
    try {
      emit(TestimonialsLoading());
      final testimonials = await repository.getTestimonials();
      emit(TestimonialsLoaded(testimonials));
    } catch (e) {
      emit(TestimonialsError(e.toString()));
    }
  }
}
