import '../../domain/entities/about_entity.dart';
import '../../domain/repositories/about_repository.dart';
import '../datasources/about_local_data_source.dart';

class AboutRepositoryImpl implements AboutRepository {
  final AboutLocalDataSource localDataSource;

  AboutRepositoryImpl(this.localDataSource);

  @override
  Future<AboutData> getAboutData() async {
    return await localDataSource.getAboutData();
  }
}
