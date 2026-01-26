import '../entities/expertise_entity.dart';

abstract class ExpertiseRepository {
  Future<List<Expertise>> getExpertiseAreas();
  Future<List<String>> getTechStack();
}
