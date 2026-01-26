import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/expertise_repository.dart';
import 'expertise_state.dart';

class ExpertiseCubit extends Cubit<ExpertiseState> {
  final ExpertiseRepository repository;

  ExpertiseCubit(this.repository) : super(ExpertiseInitial());

  Future<void> loadExpertise() async {
    emit(ExpertiseLoading());
    try {
      final expertiseAreas = await repository.getExpertiseAreas();
      final techStack = await repository.getTechStack();
      emit(ExpertiseLoaded(
        expertiseAreas: expertiseAreas,
        techStack: techStack,
      ));
    } catch (e) {
      emit(const ExpertiseError('Failed to load expertise data'));
    }
  }
}
