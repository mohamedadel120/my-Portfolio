import 'package:equatable/equatable.dart';
import '../../../../models/testimonial.dart';

abstract class TestimonialsState extends Equatable {
  const TestimonialsState();

  @override
  List<Object> get props => [];
}

class TestimonialsInitial extends TestimonialsState {}

class TestimonialsLoading extends TestimonialsState {}

class TestimonialsLoaded extends TestimonialsState {
  final List<Testimonial> testimonials;

  const TestimonialsLoaded(this.testimonials);

  @override
  List<Object> get props => [testimonials];
}

class TestimonialsError extends TestimonialsState {
  final String message;

  const TestimonialsError(this.message);

  @override
  List<Object> get props => [message];
}
