import 'package:flutter/material.dart';
import '../../../../models/why_choose_me_reason.dart';

class WhyChooseMeReasonModel extends WhyChooseMeReason {
  const WhyChooseMeReasonModel({
    required super.title,
    required super.description,
    required super.icon,
    required super.color,
  });

  factory WhyChooseMeReasonModel.fromJson(Map<String, dynamic> json) {
    return WhyChooseMeReasonModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      icon: IconData(json['icon'] ?? Icons.star.codePoint, fontFamily: 'MaterialIcons'),
      color: Color(json['color'] ?? 0xFF000000),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'icon': icon.codePoint,
      'color': color.value,
    };
  }
}
