import 'package:flutter/material.dart';

/// Maps a Material Icons codepoint (as stored in Firestore for the
/// expertise / why-choose-me collections) to a stable string key.
///
/// Domain entities store this string key rather than an [IconData] directly
/// so they stay plain Dart with no Flutter-UI dependency (needed for reuse
/// outside Flutter, e.g. a Jaspr/HTML renderer, where the same key maps to a
/// CSS icon-font class instead). [iconDataFromKey] does the Flutter-side
/// lookup back to a literal `Icons.x` constant, which keeps Flutter's icon
/// tree shaker able to run, which otherwise ships the entire ~1.6MB
/// MaterialIcons font. Add a new case in both functions (and in Firestore)
/// if a new icon is needed.
String iconKeyFromCodePoint(int codePoint) {
  switch (codePoint) {
    case 0xf56e:
      return 'architecture';
    case 0xf650:
      return 'cloud';
    case 0xf653:
      return 'code';
    case 0xf69c:
      return 'design_services';
    case 0xf005e:
      return 'people';
    case 0xf0078:
      return 'phone_android';
    case 0xf01b5:
      return 'speed';
    case 0xf01d4:
      return 'star';
    default:
      return 'star';
  }
}

IconData iconDataFromKey(String key) {
  switch (key) {
    case 'architecture':
      return Icons.architecture_rounded;
    case 'cloud':
      return Icons.cloud_rounded;
    case 'code':
      return Icons.code_rounded;
    case 'design_services':
      return Icons.design_services_rounded;
    case 'people':
      return Icons.people_rounded;
    case 'phone_android':
      return Icons.phone_android_rounded;
    case 'speed':
      return Icons.speed_rounded;
    case 'star':
      return Icons.star_rounded;
    default:
      return Icons.star;
  }
}
