import '../../domain/repositories/project_repository.dart';
import '../../domain/entities/project_entity.dart';
import '../datasources/project_local_data_source.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectLocalDataSource dataSource;

  ProjectRepositoryImpl(this.dataSource);

  @override
  Future<List<Project>> getProjects() async {
    return await dataSource.getProjects();
  }
}
