import '../utils/icon_mapper.dart';
import 'firestore_rest.dart';

const _projectId = 'my-website-bf9e6';
const _firestore = FirestoreRest(_projectId);

class HeroData {
  final String name;
  final String title;
  final String subtitle;
  final String cvUrl;

  const HeroData({required this.name, required this.title, required this.subtitle, required this.cvUrl});
}

class AboutFeature {
  final String title;
  final String description;

  const AboutFeature({required this.title, required this.description});
}

class TechnicalSkill {
  final String name;
  final double progress;
  final bool isPrimary;

  const TechnicalSkill({required this.name, required this.progress, required this.isPrimary});
}

class AboutData {
  final String professionalSummary;
  final String downloadsCount;
  final String ratings;
  final List<AboutFeature> features;
  final List<TechnicalSkill> skills;

  const AboutData({
    required this.professionalSummary,
    required this.downloadsCount,
    required this.ratings,
    required this.features,
    required this.skills,
  });
}

class ExpertiseItem {
  final String title;
  final String description;
  final String iconKey;

  const ExpertiseItem({required this.title, required this.description, required this.iconKey});
}

/// Both Hero and About read the same `profile_info/main` Firestore document
/// — same as the Flutter app's `HeroRemoteDataSource`/`AboutRemoteDataSource`,
/// which both hit that document independently. Kept as two separate fetches
/// here too (one extra build-time HTTP call is irrelevant; matching the
/// existing data shape/ownership is worth more than micro-optimizing this).
Future<HeroData> fetchHeroData() async {
  final data = await _firestore.getDocument('profile_info', 'main');
  return HeroData(
    name: data['name'] as String? ?? '',
    title: data['title'] as String? ?? '',
    subtitle: data['subtitle'] as String? ?? '',
    cvUrl: data['cvUrl'] as String? ?? '',
  );
}

// The live `profile_info/main` document has no `features`/`skills`/
// `downloadsCount`/`ratings` fields at all (verified directly against the
// REST API) — meaning the Flutter app's "fallback" defaults in
// about_remote_data_source.dart are what's actually shown in production
// today, not a rare edge case. Replicated verbatim here, duplicates and
// all (`UI/UX Animations` and `CI/CD & DevOps` each appear twice in the
// Flutter source), to match current live behavior rather than "fixing" it.
const _fallbackFeatures = [
  AboutFeature(
    title: 'Clean Code',
    description: 'Writing maintainable, scalable, and well-documented code that teams love to work with.',
  ),
  AboutFeature(
    title: 'Performance',
    description: 'Optimizing for 60fps and lightning-fast load times. I make sure your users never wait.',
  ),
  AboutFeature(
    title: 'Architecture',
    description: 'Robust Clean Architecture and MVVM patterns for enterprise-grade scalability.',
  ),
  AboutFeature(
    title: 'Responsive',
    description: 'Pixel-perfect experiences across all device categories, from mobile to desktop.',
  ),
];

const _fallbackSkills = [
  TechnicalSkill(name: 'Flutter & Dart', progress: 0.95, isPrimary: true),
  TechnicalSkill(name: 'Clean Architecture & Bloc', progress: 0.90, isPrimary: true),
  TechnicalSkill(name: 'Firebase & REST APIs', progress: 0.88, isPrimary: false),
  TechnicalSkill(name: 'UI/UX Animations', progress: 0.85, isPrimary: false),
  TechnicalSkill(name: 'CI/CD & DevOps', progress: 0.80, isPrimary: false),
  TechnicalSkill(name: 'State Management (Bloc, Cubit)', progress: 0.92, isPrimary: true),
  TechnicalSkill(name: 'Supabase', progress: 0.85, isPrimary: false),
  TechnicalSkill(name: 'Responsive UI Design', progress: 0.90, isPrimary: true),
  TechnicalSkill(name: 'UI/UX Animations', progress: 0.85, isPrimary: false),
  TechnicalSkill(name: 'CI/CD & DevOps', progress: 0.80, isPrimary: false),
  TechnicalSkill(name: 'API Integration (GraphQL)', progress: 0.82, isPrimary: false),
];

Future<AboutData> fetchAboutData() async {
  final data = await _firestore.getDocument('profile_info', 'main');
  final rawFeatures = data['features'] as List?;
  final rawSkills = data['skills'] as List?;

  return AboutData(
    professionalSummary: data['professionalSummary'] as String? ?? '',
    downloadsCount: data['downloadsCount'] as String? ?? '10k+',
    ratings: data['ratings'] as String? ?? '4.8',
    features: rawFeatures != null && rawFeatures.isNotEmpty
        ? rawFeatures
            .cast<Map<String, dynamic>>()
            .map((e) => AboutFeature(title: e['title'] as String? ?? '', description: e['description'] as String? ?? ''))
            .toList()
        : _fallbackFeatures,
    skills: rawSkills != null && rawSkills.isNotEmpty
        ? rawSkills
            .cast<Map<String, dynamic>>()
            .map((e) => TechnicalSkill(
                  name: e['name'] as String? ?? '',
                  progress: (e['progress'] as num?)?.toDouble() ?? 0.0,
                  isPrimary: e['isPrimary'] as bool? ?? false,
                ))
            .toList()
        : _fallbackSkills,
  );
}

Future<List<ExpertiseItem>> fetchExpertise() async {
  final docs = await _firestore.getCollection('expertise');
  return docs.map((json) {
    final rawIcon = json['icon'];
    int iconCode = 0;
    if (rawIcon is int) {
      iconCode = rawIcon;
    } else if (rawIcon is String) {
      if (rawIcon.startsWith('0x') || rawIcon.startsWith('0X')) {
        iconCode = int.tryParse(rawIcon.substring(2), radix: 16) ?? 0;
      } else {
        iconCode = int.tryParse(rawIcon) ?? 0;
      }
    }
    return ExpertiseItem(
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      iconKey: iconKeyFromCodePoint(iconCode),
    );
  }).toList();
}
