import '../../domain/entities/expertise_entity.dart';
import '../../domain/repositories/expertise_repository.dart';
import '../datasources/expertise_local_data_source.dart';

class ExpertiseRepositoryImpl implements ExpertiseRepository {
  final ExpertiseLocalDataSource localDataSource;

  ExpertiseRepositoryImpl(this.localDataSource);

  @override
  Future<List<Expertise>> getExpertiseAreas() async {
    return await localDataSource.getExpertiseAreas();
  }

  @override
  Future<List<String>> getTechStack() async {
    return await localDataSource.getTechStack();
  }
}
