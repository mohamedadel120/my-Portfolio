import '../../domain/entities/expertise_entity.dart';
import '../../domain/repositories/expertise_repository.dart';
import '../datasources/expertise_remote_data_source.dart';

class ExpertiseRepositoryImpl implements ExpertiseRepository {
  final ExpertiseRemoteDataSource remoteDataSource;

  ExpertiseRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Expertise>> getExpertiseAreas() async {
    return await remoteDataSource.getExpertiseAreas();
  }

  @override
  Future<List<String>> getTechStack() async {
    return await remoteDataSource.getTechStack();
  }
}
