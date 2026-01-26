import '../entities/hero_entity.dart';

abstract class HeroRepository {
  Future<HeroData> getHeroData();
}
