import 'package:flutter/material.dart';

/// Maps a Material Icons codepoint (as stored in Firestore for the
/// expertise / why-choose-me collections) to a constant [IconData].
///
/// Firestore only ever stores a handful of known icon codepoints for this
/// content, and using literal `Icons.x` constants here (instead of
/// `IconData(codePoint, fontFamily: 'MaterialIcons')`) keeps Flutter's icon
/// tree shaker able to run, which otherwise ships the entire ~1.6MB
/// MaterialIcons font. Add a new `case` here (and in Firestore) if a new
/// icon is needed.
IconData iconFromCodePoint(int codePoint) {
  switch (codePoint) {
    case 0xf56e:
      return Icons.architecture_rounded;
    case 0xf650:
      return Icons.cloud_rounded;
    case 0xf653:
      return Icons.code_rounded;
    case 0xf69c:
      return Icons.design_services_rounded;
    case 0xf005e:
      return Icons.people_rounded;
    case 0xf0078:
      return Icons.phone_android_rounded;
    case 0xf01b5:
      return Icons.speed_rounded;
    case 0xf01d4:
      return Icons.star_rounded;
    default:
      return Icons.star;
  }
}
