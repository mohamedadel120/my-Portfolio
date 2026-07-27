import 'firestore_rest.dart';

const _firestore = FirestoreRest('my-website-bf9e6');

class ExperienceItem {
  final String company;
  final String role;
  final String period;
  final List<String> achievements;

  const ExperienceItem({
    required this.company,
    required this.role,
    required this.period,
    required this.achievements,
  });
}

Future<List<ExperienceItem>> fetchExperiences() async {
  final docs = await _firestore.getCollection('experiences');
  return docs
      .map((json) => ExperienceItem(
            company: json['company'] as String? ?? '',
            role: json['role'] as String? ?? '',
            period: json['period'] as String? ?? '',
            achievements: (json['achievements'] as List?)?.cast<String>() ?? const [],
          ))
      .toList();
}
