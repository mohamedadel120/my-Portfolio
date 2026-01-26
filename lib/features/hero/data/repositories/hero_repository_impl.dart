import '../../domain/entities/hero_entity.dart';
import '../../domain/repositories/hero_repository.dart';
import '../datasources/hero_local_data_source.dart';

class HeroRepositoryImpl implements HeroRepository {
  final HeroLocalDataSource localDataSource;

  HeroRepositoryImpl(this.localDataSource);

  @override
  Future<HeroData> getHeroData() async {
    return await localDataSource.getHeroData();
  }
}
