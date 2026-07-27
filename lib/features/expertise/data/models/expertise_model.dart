import '../../domain/entities/expertise_entity.dart';
import '../../../../utils/icon_mapper.dart';

class ExpertiseModel extends Expertise {
  const ExpertiseModel({
    required super.title,
    required super.description,
    required super.iconKey,
    super.color,
  });

  factory ExpertiseModel.fromJson(Map<String, dynamic> json) {
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
    int? colorValue;
    if (rawColor is int) {
      colorValue = rawColor;
    } else if (rawColor is String) {
      if (rawColor.startsWith('0x') || rawColor.startsWith('0X')) {
        colorValue = int.tryParse(rawColor.substring(2), radix: 16);
      } else {
        colorValue = int.tryParse(rawColor);
      }
    }

    return ExpertiseModel(
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
