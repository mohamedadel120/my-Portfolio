import '../../domain/entities/about_entity.dart';
import '../../domain/repositories/about_repository.dart';
import '../datasources/about_remote_data_source.dart';

class AboutRepositoryImpl implements AboutRepository {
  final AboutRemoteDataSource remoteDataSource;

  AboutRepositoryImpl(this.remoteDataSource);

  @override
  Future<AboutData> getAboutData() async {
    return await remoteDataSource.getAboutData();
  }
}
