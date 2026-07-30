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

// Sorts newest-first by the year found in `period` (e.g. "2022 - 2023" or
// "2022 – 2023" -- Firestore has both a hyphen and an en-dash in the wild),
// then by the second year, with an open-ended entry like "2025 - now"
// treated as ending after any specific year so it lands first among ties.
int _periodStartYear(String period) {
  final match = RegExp(r'\d{4}').firstMatch(period);
  return match != null ? int.parse(match.group(0)!) : 0;
}

int _periodEndYear(String period) {
  final years = RegExp(r'\d{4}').allMatches(period).toList();
  if (years.length < 2) return 1 << 30;
  return int.parse(years[1].group(0)!);
}

Future<List<ExperienceItem>> fetchExperiences() async {
  final docs = await _firestore.getCollection('experiences');
  final items = docs
      .map((json) => ExperienceItem(
            company: json['company'] as String? ?? '',
            role: json['role'] as String? ?? '',
            period: json['period'] as String? ?? '',
            achievements: (json['achievements'] as List?)?.cast<String>() ?? const [],
          ))
      .toList();
  items.sort((a, b) {
    final byStart = _periodStartYear(b.period).compareTo(_periodStartYear(a.period));
    return byStart != 0 ? byStart : _periodEndYear(b.period).compareTo(_periodEndYear(a.period));
  });
  return items;
}
