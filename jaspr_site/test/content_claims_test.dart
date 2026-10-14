import 'dart:io';

import 'package:test/test.dart';

/// Ratings must come from data the owner confirmed (Firestore `rating`), never
/// from text written into the code: page descriptions end up in search results.
void main() {
  test('no star rating is hardcoded anywhere in lib/', () {
    final rating = RegExp(r'\b\d\.\d[- ]?stars?\b', caseSensitive: false);
    final offenders = <String>[];
    for (final file in Directory('lib').listSync(recursive: true).whereType<File>()) {
      if (!file.path.endsWith('.dart')) continue;
      final lines = file.readAsLinesSync();
      for (var i = 0; i < lines.length; i++) {
        if (rating.hasMatch(lines[i])) offenders.add('${file.path}:${i + 1}: ${lines[i].trim()}');
      }
    }
    expect(offenders, isEmpty, reason: offenders.join('\n'));
  });
}
