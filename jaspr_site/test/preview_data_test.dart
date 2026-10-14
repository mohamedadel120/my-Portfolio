import 'package:jaspr_site/data/preview_data.dart';
import 'package:test/test.dart';

List<Map<String, dynamic>> firestoreLike() => [
  {'title': 'Stock Mobile App', 'downloads': '10,000+', 'description': '... maintains 4.8-star ratings ...'},
  {'title': 'Gomla Mobile App', 'downloads': '10,000+', 'description': 'A comprehensive e-commerce solution ... 5,000+ downloads ...'},
  {'title': 'Albatal Mobile App', 'downloads': '5,000+', 'description': '... 10,000+ downloads ... 4.8-star ...'},
  {'title': 'to-let', 'downloads': '100', 'description': 'Rent Smarter.\nThe One-Click Revolution:'},
  {'title': 'ureva', 'downloads': 'Coming Soon', 'description': 'Gold.'},
  {'title': 'DrugZa - TagPharma', 'downloads': 'High Engagement', 'description': '... a significant 35% increase in customer engagement.'},
];

Map<String, dynamic> byTitle(List<Map<String, dynamic>> list, String fragment) =>
    list.firstWhere((p) => (p['title'] as String).contains(fragment));

void main() {
  test('production builds return Firestore data untouched', () {
    final input = firestoreLike();
    expect(identical(withPreviewData(input, enabled: false), input), isTrue);
    expect(previewData, isFalse, reason: 'tests run without the define');
  });

  group('with the preview enabled', () {
    final out = withPreviewData(firestoreLike(), enabled: true);

    test('Gomla is featured, first, and carries its real story', () {
      expect(out.first['title'], 'Gomla Mobile App');
      expect(out.first['featured'], isTrue);
      expect(out.first['highlight'], isNotEmpty);
      expect(out.first['problem'], contains('dermatologist'));
      expect(out.first['description'], contains('AI to analyze your skin'));
      expect(out.first['downloads'], '10,000+');
    });

    test('download figures match the owner: Stock and Gomla 10,000+, Albatal 1,000+', () {
      expect(byTitle(out, 'Stock')['downloads'], '10,000+');
      expect(byTitle(out, 'Albatal')['downloads'], '1,000+');
    });

    test('no unverified figures remain in any description', () {
      for (final project in out) {
        final text = project['description'] as String;
        expect(text, isNot(contains('4.8')), reason: project['title'] as String);
        expect(text, isNot(contains('35%')), reason: project['title'] as String);
      }
      expect(byTitle(out, 'Albatal')['description'], isNot(contains('10,000')));
    });

    test('projects without a figure show none', () {
      expect(byTitle(out, 'to-let')['downloads'], '');
      expect(byTitle(out, 'DrugZa')['downloads'], '');
      expect(byTitle(out, 'to-let')['description'], isNot(contains('One-Click Revolution')));
    });

    test('projects without corrections are left exactly as they were', () {
      expect(byTitle(out, 'ureva'), {'title': 'ureva', 'downloads': 'Coming Soon', 'description': 'Gold.'});
    });

    test('the Gomla headline makes no "first" or "only" claim', () {
      final headline = (out.first['highlight'] as String).toLowerCase();
      for (final claim in ['first', 'only', 'unique', '#1', 'number one']) {
        expect(headline, isNot(contains(claim)));
      }
    });

    test('only Gomla is featured', () {
      expect(out.where((p) => p['featured'] == true), hasLength(1));
    });
  });
}
