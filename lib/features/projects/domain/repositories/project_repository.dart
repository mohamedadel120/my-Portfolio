import '../entities/project_entity.dart';

abstract class ProjectRepository {
  Future<List<Project>> getProjects();
}
