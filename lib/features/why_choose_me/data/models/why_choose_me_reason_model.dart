import '../../../../models/why_choose_me_reason.dart';
import '../../../../utils/icon_mapper.dart';

class WhyChooseMeReasonModel extends WhyChooseMeReason {
  const WhyChooseMeReasonModel({
    required super.title,
    required super.description,
    required super.iconKey,
    required super.color,
  });

  factory WhyChooseMeReasonModel.fromJson(Map<String, dynamic> json) {
    final rawIcon = json['icon'];
    int iconCode = 0; // falls through to the 'star' default in iconKeyFromCodePoint
    if (rawIcon is int) {
      iconCode = rawIcon;
    } else if (rawIcon is String) {
      if (rawIcon.startsWith('0x') || rawIcon.startsWith('0X')) {
        iconCode = int.tryParse(rawIcon.substring(2), radix: 16) ?? iconCode;
      } else {
        iconCode = int.tryParse(rawIcon) ?? iconCode;
      }
    }

    final rawColor = json['color'];
    int colorValue = 0xFF000000;
    if (rawColor is int) {
      colorValue = rawColor;
    } else if (rawColor is String) {
      if (rawColor.startsWith('0x') || rawColor.startsWith('0X')) {
        final parsed = int.tryParse(rawColor.substring(2), radix: 16);
        if (parsed != null) colorValue = parsed;
      } else {
        final parsed = int.tryParse(rawColor);
        if (parsed != null) colorValue = parsed;
      }
    }

    return WhyChooseMeReasonModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      iconKey: iconKeyFromCodePoint(iconCode),
      color: colorValue,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'icon': iconKey,
      'color': color,
    };
  }
}
