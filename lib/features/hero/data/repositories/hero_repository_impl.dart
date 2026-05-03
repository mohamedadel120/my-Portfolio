import '../../domain/entities/hero_entity.dart';
import '../../domain/repositories/hero_repository.dart';
import '../datasources/hero_remote_data_source.dart';

class HeroRepositoryImpl implements HeroRepository {
  final HeroRemoteDataSource remoteDataSource;

  HeroRepositoryImpl(this.remoteDataSource);

  @override
  Future<HeroData> getHeroData() async {
    return await remoteDataSource.getHeroData();
  }
}
