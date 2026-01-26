import 'package:equatable/equatable.dart';
import '../../domain/entities/expertise_entity.dart';

abstract class ExpertiseState extends Equatable {
  const ExpertiseState();

  @override
  List<Object> get props => [];
}

class ExpertiseInitial extends ExpertiseState {}

class ExpertiseLoading extends ExpertiseState {}

class ExpertiseLoaded extends ExpertiseState {
  final List<Expertise> expertiseAreas;
  final List<String> techStack;

  const ExpertiseLoaded({
    required this.expertiseAreas,
    required this.techStack,
  });

  @override
  List<Object> get props => [expertiseAreas, techStack];
}

class ExpertiseError extends ExpertiseState {
  final String message;

  const ExpertiseError(this.message);

  @override
  List<Object> get props => [message];
}
