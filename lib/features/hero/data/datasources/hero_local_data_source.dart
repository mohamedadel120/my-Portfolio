import '../../domain/entities/hero_entity.dart';
import '../../../../core/constants/app_data.dart';

abstract class HeroLocalDataSource {
  Future<HeroData> getHeroData();
}

class HeroLocalDataSourceImpl implements HeroLocalDataSource {
  @override
  Future<HeroData> getHeroData() async {
    return const HeroData(
      name: AppData.name,
      title: AppData.title,
      subtitle: AppData.subtitle,
      helloGreeting: "HELLO I'M",
      showAurora: true,
    );
  }
}
