import 'package:jaspr_site/data/experience_repository.dart';
import 'package:jaspr_site/data/projects_repository.dart';
import 'package:test/test.dart';

ProjectItem project({
  String? android,
  String? ios,
  Object? rating,
  String title = 'App',
}) => ProjectItem.fromJson({
  'title': title,
  'androidStoreUrl': android,
  'iosStoreUrl': ios,
  'rating': rating,
});

ExperienceItem experience(String period) =>
    ExperienceItem(company: 'c', role: 'r', period: period, achievements: const []);

void main() {
  group('parseColor', () {
    test('accepts int, 0x hex and decimal strings', () {
      expect(parseColor(0xFF00D9FF), 0xFF00D9FF);
      expect(parseColor('0xFF00D9FF'), 0xFF00D9FF);
      expect(parseColor('0XFF00D9FF'), 0xFF00D9FF);
      expect(parseColor('4278243839'), 4278243839);
      expect(parseColor('  0xFF00D9FF '), 0xFF00D9FF);
    });

    test('falls back to opaque black for anything unusable', () {
      for (final bad in [null, '', 'red', '0xZZ', 1.5, <String>[]]) {
        expect(parseColor(bad), 0xFF000000, reason: '$bad');
      }
    });
  });

  group('parseRating', () {
    test('accepts valid numbers and numeric strings', () {
      expect(parseRating(4.7), 4.7);
      expect(parseRating(5), 5.0);
      expect(parseRating('4.5'), 4.5);
      expect(parseRating(' 3 '), 3.0);
    });

    test('rejects missing, zero, negative, out of range and non-numeric', () {
      for (final bad in [null, 0, -1, 5.01, 6, 'abc', '', double.nan, true, <int>[]]) {
        expect(parseRating(bad), isNull, reason: '$bad');
      }
    });
  });

  group('ProjectItem.fromJson', () {
    test('tolerates an empty document', () {
      final item = ProjectItem.fromJson(const {});
      expect(item.title, '');
      expect(item.tech, isEmpty);
      expect(item.rating, isNull);
      expect(item.isLive, isFalse);
    });

    test('ignores fields of the wrong type instead of throwing', () {
      final item = ProjectItem.fromJson({
        'title': 42,
        'tech': 'flutter',
        'galleryImages': [1, 'a.webp', null],
        'androidStoreUrl': 7,
      });
      expect(item.title, '');
      expect(item.tech, isEmpty);
      expect(item.galleryImages, ['a.webp']);
      expect(item.androidStoreUrl, isNull);
    });

    test('blank store urls do not count as live', () {
      expect(project(android: '  ', ios: '').isLive, isFalse);
      expect(project(android: 'https://play.google.com/x').isLive, isTrue);
      expect(project(ios: 'https://apps.apple.com/x').hasIos, isTrue);
    });
  });

  group('featured and highlight', () {
    test('parseFlag accepts booleans and the strings true/false only', () {
      expect(parseFlag(true), isTrue);
      expect(parseFlag(false), isFalse);
      expect(parseFlag('true'), isTrue);
      expect(parseFlag(' TRUE '), isTrue);
      for (final other in [null, 'yes', '1', 1, 0, 'false', '', <bool>[]]) {
        expect(parseFlag(other), isFalse, reason: '$other');
      }
    });

    test('fromJson reads both fields and defaults to not featured', () {
      final plain = ProjectItem.fromJson(const {'title': 'A'});
      expect(plain.featured, isFalse);
      expect(plain.highlight, isNull);

      final item = ProjectItem.fromJson({'title': 'G', 'featured': true, 'highlight': '  One app for everything  '});
      expect(item.featured, isTrue);
      expect(item.highlight, 'One app for everything');
    });

    test('blank or wrongly typed highlight is ignored', () {
      expect(ProjectItem.fromJson({'highlight': '   '}).highlight, isNull);
      expect(ProjectItem.fromJson({'highlight': 7}).highlight, isNull);
    });

    test('featured projects come first and everything else keeps its order', () {
      final docs = [
        {'title': 'A'},
        {'title': 'B', 'featured': true},
        {'title': 'C'},
        {'title': 'D', 'featured': 'true'},
        {'title': 'E'},
      ];
      expect(parseProjects(docs).map((p) => p.title), ['B', 'D', 'A', 'C', 'E']);
    });

    test('with no featured project the Firestore order is untouched', () {
      final docs = [for (final t in ['X', 'Y', 'Z']) {'title': t}];
      expect(parseProjects(docs).map((p) => p.title), ['X', 'Y', 'Z']);
    });
  });

  group('earliestStartYear', () {
    test('finds the earliest year across hyphen and en-dash periods', () {
      expect(
        earliestStartYear([experience('2023 - now'), experience('2022 – 2023')]),
        2022,
      );
    });

    test('is null when no period contains a year', () {
      expect(earliestStartYear([experience('recent'), experience('')]), isNull);
      expect(earliestStartYear(const []), isNull);
    });
  });

  group('computeProofSummary', () {
    test('never invents a rating when none was supplied', () {
      final summary = computeProofSummary(
        [project(android: 'a'), project(ios: 'i')],
        [experience('2022 - now')],
      );
      expect(summary.averageRating, isNull);
      expect(summary.ratedApps, 0);
    });

    test('averages only real ratings and counts the rated apps', () {
      final summary = computeProofSummary(
        [project(rating: 4.0), project(rating: 5), project(rating: null), project(rating: 9)],
        const [],
      );
      expect(summary.averageRating, 4.5);
      expect(summary.ratedApps, 2);
    });

    test('derives live apps, platforms and start year from data only', () {
      final summary = computeProofSummary(
        [project(android: 'a'), project(android: 'a', ios: 'i'), project()],
        [experience('2024 - now'), experience('2022 - 2023')],
      );
      expect(summary.totalProjects, 3);
      expect(summary.liveApps, 2);
      expect(summary.platforms, ['Android', 'iOS']);
      expect(summary.buildingSinceYear, 2022);
    });

    test('handles an empty collection', () {
      final summary = computeProofSummary(const [], const []);
      expect(summary.totalProjects, 0);
      expect(summary.liveApps, 0);
      expect(summary.platforms, isEmpty);
      expect(summary.buildingSinceYear, isNull);
      expect(summary.averageRating, isNull);
    });
  });
}
