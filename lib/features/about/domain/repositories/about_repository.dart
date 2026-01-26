import '../entities/about_entity.dart';

abstract class AboutRepository {
  Future<AboutData> getAboutData();
}
