import '../../domain/entities/experience_entity.dart';
import '../../domain/repositories/experience_repository.dart';
import '../datasources/experience_remote_data_source.dart';

class ExperienceRepositoryImpl implements ExperienceRepository {
  final ExperienceRemoteDataSource remoteDataSource;

  ExperienceRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Experience>> getExperiences() async {
    return await remoteDataSource.getExperiences();
  }
}
