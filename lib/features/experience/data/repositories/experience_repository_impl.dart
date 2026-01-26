import '../../domain/entities/experience_entity.dart';
import '../../domain/repositories/experience_repository.dart';
import '../datasources/experience_local_data_source.dart';

class ExperienceRepositoryImpl implements ExperienceRepository {
  final ExperienceLocalDataSource localDataSource;

  ExperienceRepositoryImpl(this.localDataSource);

  @override
  Future<List<Experience>> getExperiences() async {
    return await localDataSource.getExperiences();
  }
}
