import 'package:flutter/material.dart';
import '../../domain/entities/expertise_entity.dart';

class ExpertiseModel extends Expertise {
  const ExpertiseModel({
    required super.title,
    required super.description,
    required super.icon,
    super.color,
  });

  factory ExpertiseModel.fromJson(Map<String, dynamic> json) {
    return ExpertiseModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      icon: IconData(json['icon'] ?? Icons.star.codePoint, fontFamily: 'MaterialIcons'),
      color: json['color'] != null ? Color(json['color']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'icon': icon.codePoint,
      'color': color?.toARGB32(),
    };
  }
}
