import '../utils/icon_mapper.dart';
import 'firestore_rest.dart';

const _firestore = FirestoreRest('my-website-bf9e6');

class WhyChooseMeReason {
  final String title;
  final String description;
  final String iconKey;

  /// CSS hex color (`#RRGGBB`), converted from the ARGB int Firestore stores.
  final String color;

  const WhyChooseMeReason({
    required this.title,
    required this.description,
    required this.iconKey,
    required this.color,
  });
}

// Same parsing as the Flutter app's `WhyChooseMeReasonModel.fromJson`: an
// int, or a decimal/`0x` hex string, defaulting to opaque black. Alpha is
// dropped since the cards only use the color at reduced opacity anyway.
String _cssColor(Object? rawColor) {
  int value = 0xFF000000;
  if (rawColor is int) {
    value = rawColor;
  } else if (rawColor is String) {
    final parsed = rawColor.startsWith('0x') || rawColor.startsWith('0X')
        ? int.tryParse(rawColor.substring(2), radix: 16)
        : int.tryParse(rawColor);
    if (parsed != null) value = parsed;
  }
  return '#${(value & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';
}

Future<List<WhyChooseMeReason>> fetchWhyChooseMe() async {
  final docs = await _firestore.getCollection('why_choose_me');
  return docs
      .map(
        (json) => WhyChooseMeReason(
          title: json['title'] as String? ?? '',
          description: json['description'] as String? ?? '',
          iconKey: iconKeyFromFirestore(json['icon']),
          color: _cssColor(json['color']),
        ),
      )
      .toList();
}
