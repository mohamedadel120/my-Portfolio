import 'package:jaspr_site/data/experience_repository.dart';
import 'package:jaspr_site/data/projects_repository.dart';
import 'package:jaspr_site/sections/projects_section.dart';
import 'package:test/test.dart';

ProjectItem app({String? android, String? ios, Object? rating}) =>
    ProjectItem.fromJson({
      'title': 't',
      'androidStoreUrl': android,
      'iosStoreUrl': ios,
      'rating': rating,
    });

List<String> labels(List<ProjectItem> p, List<ExperienceItem> e) =>
    proofFacts(computeProofSummary(p, e)).map((f) => f.label).toList();

void main() {
  final since2022 = [
    const ExperienceItem(company: 'c', role: 'r', period: '2022 - now', achievements: []),
  ];

  test('no rating fact until a real rating exists', () {
    final facts = proofFacts(computeProofSummary([app(android: 'a')], since2022));
    expect(facts.map((f) => f.label), isNot(contains('Average store rating')));
    expect(facts.any((f) => f.value.contains('4.8')), isFalse);
  });

  test('rating fact appears with its sample size once supplied', () {
    final facts = proofFacts(
      computeProofSummary([app(android: 'a', rating: 4.6), app(ios: 'i', rating: 4.4)], since2022),
    );
    final rating = facts.singleWhere((f) => f.label == 'Average store rating');
    expect(rating.value, '4.5 across 2 apps');
  });

  test('wording is correct for one app and one platform', () {
    final facts = proofFacts(computeProofSummary([app(ios: 'i')], since2022));
    expect(facts.firstWhere((f) => f.label == 'Live on the stores').value, '1 app');
    expect(facts.firstWhere((f) => f.label == 'Platforms').value, 'iOS');
    expect(facts.firstWhere((f) => f.label == 'Building since').value, '2022');
  });

  test('facts that cannot be derived are omitted', () {
    expect(labels([app()], const []), isEmpty);
    expect(proofStrip(computeProofSummary(const [], const [])), isEmpty);
  });

  test('strip renders when there is at least one fact', () {
    expect(proofStrip(computeProofSummary([app(android: 'a')], const [])), hasLength(1));
  });
}
