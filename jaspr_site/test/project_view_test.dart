import 'package:jaspr_site/components/project_view.dart';
import 'package:test/test.dart';

void main() {
  test('reads a complete project', () {
    final v = ProjectView.fromMap({
      'title': ' Stock ',
      'description': 'Inventory',
      'tech': ['Flutter', 'Bloc', '', 3],
      'galleryImages': ['a.webp', '  ', 'b.webp'],
      'videoUrl': 'v.mp4',
      'androidStoreUrl': 'https://play.google.com/x',
      'iosStoreUrl': 'https://apps.apple.com/x',
      'downloads': '10,000+',
      'color': 0xFFFF0000,
      'role': 'Lead developer',
      'problem': 'Paper stock sheets',
      'outcome': 'Live in production',
    });
    expect(v.title, 'Stock');
    expect(v.tech, ['Flutter', 'Bloc']);
    expect(v.images, ['a.webp', 'b.webp']);
    expect(v.hasStoreLink, isTrue);
    expect(v.accentRgb, 0xFF0000);
    expect(v.accentHex, '#ff0000');
    expect(v.facts.map((f) => f.$1), ['My role', 'The problem', 'The outcome']);
  });

  test('survives an empty map', () {
    final v = ProjectView.fromMap(const {});
    expect(v.title, '');
    expect(v.tech, isEmpty);
    expect(v.images, isEmpty);
    expect(v.videoUrl, isNull);
    expect(v.hasStoreLink, isFalse);
    expect(v.facts, isEmpty);
    expect(v.accentHex, '#00d9ff');
  });

  test('blank or wrongly typed optional fields are ignored', () {
    final v = ProjectView.fromMap({
      'role': '   ',
      'problem': 5,
      'androidStoreUrl': '',
      'videoUrl': null,
      'color': 'red',
    });
    expect(v.facts, isEmpty);
    expect(v.androidUrl, isNull);
    expect(v.accentHex, '#00d9ff');
  });

  test('featured and highlight', () {
    final v = ProjectView.fromMap({'featured': true, 'highlight': ' Headline '});
    expect(v.featured, isTrue);
    expect(v.highlight, 'Headline');
    final none = ProjectView.fromMap(const {});
    expect(none.featured, isFalse);
    expect(none.highlight, isNull);
    // Only a real boolean true counts once it has crossed into a map.
    expect(ProjectView.fromMap({'featured': 'true'}).featured, isFalse);
    expect(ProjectView.fromMap({'highlight': ''}).highlight, isNull);
  });

  test('accent hex is always 6 digits', () {
    expect(ProjectView.fromMap({'color': 0xFF000001}).accentHex, '#000001');
  });
}
