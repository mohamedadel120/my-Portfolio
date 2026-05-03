import '../../domain/entities/experience_entity.dart';

class ExperienceModel extends Experience {
  const ExperienceModel({
    required super.company,
    required super.role,
    required super.period,
    required super.achievements,
  });

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      company: json['company'] ?? '',
      role: json['role'] ?? '',
      period: json['period'] ?? '',
      achievements: List<String>.from(json['achievements'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company': company,
      'role': role,
      'period': period,
      'achievements': achievements,
    };
  }
}
