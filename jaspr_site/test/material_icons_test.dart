import 'dart:io';

import 'package:jaspr_site/constants/theme.dart';
import 'package:test/test.dart';

/// Icon names the source code can render, found by reading lib/:
/// string literals on lines that render a `material-symbols-rounded` span,
/// the icon mapper's return values, and the contact section's icon keys.
Set<String> iconsUsedInSource() {
  final used = <String>{};
  final literal = RegExp(r"'([a-z][a-z_]*)'");
  for (final file in Directory('lib').listSync(recursive: true).whereType<File>()) {
    if (!file.path.endsWith('.dart') || file.path.contains('main.')) continue;
    final lines = file.readAsLinesSync();
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final rendersIcon = line.contains('material-symbols-rounded') && !line.contains('css(');
      // The icon text can sit on the same line or the next one.
      if (rendersIcon) {
        for (final text in [line, if (i + 1 < lines.length) lines[i + 1]]) {
          for (final m in RegExp(r"\.text\(([^)]*)\)").allMatches(text)) {
            used.addAll(literal.allMatches(m.group(1)!).map((x) => x.group(1)!));
          }
        }
      }
      for (final m in RegExp(r"(?:return |iconKey: |_infoRow\()'([a-z][a-z_]*)'").allMatches(line)) {
        used.add(m.group(1)!);
      }
    }
  }
  // Classes and other identifiers that are not icons.
  return used..removeWhere((name) => name.startsWith('material') || name.contains('-'));
}

void main() {
  test('every icon used in the source is in the subset the icon font serves', () {
    final missing = iconsUsedInSource().difference(materialIconNames.toSet());
    expect(missing, isEmpty, reason: 'Add these to materialIconNames in lib/constants/theme.dart: $missing');
  });

  test('the icon list is sorted and has no duplicates', () {
    expect(materialIconNames, [...materialIconNames]..sort());
    expect(materialIconNames.toSet(), hasLength(materialIconNames.length));
  });

  test('the icon font is requested at the one size the site uses, not the full font', () {
    expect(materialSymbolsUrl, contains('icon_names='));
    expect(materialSymbolsUrl, contains('@24,400,0..1,0'));
    expect(materialSymbolsUrl, isNot(contains('20..48')));
  });

  test('the scanner finds the icons it should (sanity check)', () {
    final used = iconsUsedInSource();
    expect(used, containsAll(['rocket_launch', 'star', 'chevron_left', 'chevron_right', 'pause', 'play_arrow', 'mail', 'architecture']));
  });
}
