import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/experience_repository.dart';
import 'experience_state.dart';

class ExperienceCubit extends Cubit<ExperienceState> {
  final ExperienceRepository repository;

  ExperienceCubit(this.repository) : super(ExperienceInitial());

  Future<void> loadExperiences() async {
    emit(ExperienceLoading());
    try {
      final experiences = await repository.getExperiences();
      emit(ExperienceLoaded(experiences));
    } catch (e) {
      emit(const ExperienceError('Failed to load experiences'));
    }
  }
}
