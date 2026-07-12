import 'package:flutter/material.dart';
import '../../domain/entities/expertise_entity.dart';
import '../../../../utils/icon_mapper.dart';

class ExpertiseModel extends Expertise {
  const ExpertiseModel({
    required super.title,
    required super.description,
    required super.icon,
    super.color,
  });

  factory ExpertiseModel.fromJson(Map<String, dynamic> json) {
    final rawIcon = json['icon'];
    int iconCode = Icons.star.codePoint;
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
    Color? colorValue;
    if (rawColor is int) {
      colorValue = Color(rawColor);
    } else if (rawColor is String) {
      if (rawColor.startsWith('0x') || rawColor.startsWith('0X')) {
        final parsed = int.tryParse(rawColor.substring(2), radix: 16);
        if (parsed != null) colorValue = Color(parsed);
      } else {
        final parsed = int.tryParse(rawColor);
        if (parsed != null) colorValue = Color(parsed);
      }
    }

    return ExpertiseModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      icon: iconFromCodePoint(iconCode),
      color: colorValue,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'icon': icon.codePoint,
      'color': color?.value,
    };
  }
}
