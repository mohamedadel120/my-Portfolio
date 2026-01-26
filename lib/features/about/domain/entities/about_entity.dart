import 'package:equatable/equatable.dart';

class AboutData extends Equatable {
  final String title;
  final String professionalSummary;
  final String downloadsCount;
  final String ratings;
  final String yearsExperience;
  final List<AboutFeature> features;
  final List<TechnicalSkill> skills;

  const AboutData({
    required this.title,
    required this.professionalSummary,
    required this.downloadsCount,
    required this.ratings,
    required this.yearsExperience,
    required this.features,
    required this.skills,
  });

  @override
  List<Object?> get props => [
        title,
        professionalSummary,
        downloadsCount,
        ratings,
        yearsExperience,
        features,
        skills,
      ];
}

class AboutFeature extends Equatable {
  final String title;
  final String description;
  final String iconCode; // We'll map string to IconData in UI

  const AboutFeature({
    required this.title,
    required this.description,
    required this.iconCode,
  });

  @override
  List<Object?> get props => [title, description, iconCode];
}

class TechnicalSkill extends Equatable {
  final String name;
  final double progress;
  final bool isPrimary; // To distinguish color

  const TechnicalSkill({
    required this.name,
    required this.progress,
    required this.isPrimary,
  });

  @override
  List<Object?> get props => [name, progress, isPrimary];
}
