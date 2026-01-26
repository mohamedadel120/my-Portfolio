import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/repositories/project_repository.dart';
import 'projects_state.dart';

class ProjectsCubit extends Cubit<ProjectsState> {
  final ProjectRepository repository;
  List<Project> _allProjects = [];
  Set<String> selectedFilters = {};

  ProjectsCubit(this.repository) : super(ProjectsInitial());

  Future<void> loadProjects() async {
    emit(ProjectsLoading());
    try {
      _allProjects = await repository.getProjects();
      emit(ProjectsLoaded(_allProjects));
    } catch (e) {
      emit(ProjectsError(e.toString()));
    }
  }

  void filterProjects(Set<String> techFilters) {
    selectedFilters = techFilters;
    // Note: If you want to filter projects, you might emit a new state or just store filters
    // Since UI does custom filtering/view, maybe we just expose the selected filters?
    // Actually, StickyProjectShowcase or ProjectsSection manages filtering UI logic.
    // If I move logic to Cubit, 'ProjectsLoaded' should contain filtered list?
    // But existing ProjectsSection calculates stats on ALL projects.
    // So better keep all projects in state, and handle filtering in UI or a selector?
    // OR have `ProjectsLoaded` contain `allProjects` and `filteredProjects`.
    emit(ProjectsLoaded(
        _allProjects)); // Re-emit to trigger rebuild if listeners care
  }
}
