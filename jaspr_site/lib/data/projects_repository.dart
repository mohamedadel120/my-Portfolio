import 'experience_repository.dart';
import 'firestore_rest.dart';

const _firestore = FirestoreRest('my-website-bf9e6');

class ProjectItem {
  final String title;
  final String description;
  final List<String> tech;
  final int color;
  final String downloads;
  final String? imageUrl;
  final String? logoUrl;
  final List<String>? galleryImages;
  final String? androidStoreUrl;
  final String? iosStoreUrl;
  final String? videoUrl;

  /// Store rating (0-5) supplied by the owner in Firestore (`rating`). Null
  /// until real data exists; nothing may display or derive a rating from
  /// anything else.
  final double? rating;

  /// Optional case-study copy written by the owner in Firestore. Never
  /// generated: when a field is absent the UI simply omits it.
  final String? role;
  final String? problem;
  final String? outcome;

  /// Owner-controlled emphasis (Firestore `featured` and `highlight`): a
  /// featured project is listed first and carries a "Featured" label; the
  /// highlight is one short headline claim shown before the description.
  final bool featured;
  final String? highlight;

  const ProjectItem({
    required this.title,
    required this.description,
    required this.tech,
    required this.color,
    required this.downloads,
    this.imageUrl,
    this.logoUrl,
    this.galleryImages,
    this.androidStoreUrl,
    this.iosStoreUrl,
    this.videoUrl,
    this.rating,
    this.role,
    this.problem,
    this.outcome,
    this.featured = false,
    this.highlight,
  });

  bool get hasAndroid => _isUsable(androidStoreUrl);
  bool get hasIos => _isUsable(iosStoreUrl);

  /// Live on at least one store.
  bool get isLive => hasAndroid || hasIos;

  factory ProjectItem.fromJson(Map<String, dynamic> json) {
    return ProjectItem(
      title: _string(json['title']) ?? '',
      description: _string(json['description']) ?? '',
      tech: _stringList(json['tech']) ?? const [],
      color: parseColor(json['color']),
      downloads: _string(json['downloads']) ?? '',
      imageUrl: _string(json['imageUrl']),
      logoUrl: _string(json['logoUrl']),
      galleryImages: _stringList(json['galleryImages']),
      androidStoreUrl: _string(json['androidStoreUrl']),
      iosStoreUrl: _string(json['iosStoreUrl']),
      videoUrl: _string(json['videoUrl']),
      rating: parseRating(json['rating']),
      role: _nonBlank(json['role']),
      problem: _nonBlank(json['problem']),
      outcome: _nonBlank(json['outcome']),
      featured: parseFlag(json['featured']),
      highlight: _nonBlank(json['highlight']),
    );
  }
}

bool _isUsable(String? url) => url != null && url.trim().isNotEmpty;

String? _string(Object? value) => value is String ? value : null;

String? _nonBlank(Object? value) {
  final text = _string(value)?.trim();
  return text == null || text.isEmpty ? null : text;
}

List<String>? _stringList(Object? value) =>
    value is List ? value.whereType<String>().toList() : null;

/// Accepts the formats seen in Firestore: an int, `"0xFF00D9FF"`, or a plain
/// decimal string. Anything else falls back to opaque black.
int parseColor(Object? raw) {
  const fallback = 0xFF000000;
  if (raw is int) return raw;
  if (raw is String) {
    final text = raw.trim();
    if (text.startsWith('0x') || text.startsWith('0X')) {
      return int.tryParse(text.substring(2), radix: 16) ?? fallback;
    }
    return int.tryParse(text) ?? fallback;
  }
  return fallback;
}

/// A rating is only valid between 0 (exclusive) and 5 (inclusive). Anything
/// else (missing, zero, out of range, wrong type) is treated as "no rating".
double? parseRating(Object? raw) {
  final value = switch (raw) {
    num n => n.toDouble(),
    String s => double.tryParse(s.trim()),
    _ => null,
  };
  if (value == null || value.isNaN || value <= 0 || value > 5) return null;
  return value;
}

/// Accepts a real boolean or the strings "true" / "false" (any case).
bool parseFlag(Object? raw) => switch (raw) {
  bool b => b,
  String s => s.trim().toLowerCase() == 'true',
  _ => false,
};

/// Featured projects first, everything else keeping its Firestore order
/// (the sort is stable, so featured projects also keep their relative order).
List<ProjectItem> featuredFirst(List<ProjectItem> projects) => [
  ...projects.where((p) => p.featured),
  ...projects.where((p) => !p.featured),
];

List<ProjectItem> parseProjects(List<Map<String, dynamic>> docs) =>
    featuredFirst(docs.map(ProjectItem.fromJson).toList());

Future<List<ProjectItem>> fetchProjects() async {
  final docs = await _firestore.getCollection('projects');
  return parseProjects(docs);
}

/// Facts the proof strip may show. Every field is derived from data the owner
/// controls; a field that cannot be derived is null/empty and is not shown.
class ProofSummary {
  final int totalProjects;
  final int liveApps;
  final bool android;
  final bool ios;
  final int? buildingSinceYear;
  final double? averageRating;
  final int ratedApps;

  const ProofSummary({
    required this.totalProjects,
    required this.liveApps,
    required this.android,
    required this.ios,
    required this.buildingSinceYear,
    required this.averageRating,
    required this.ratedApps,
  });

  List<String> get platforms => [if (android) 'Android', if (ios) 'iOS'];
}

ProofSummary computeProofSummary(
  List<ProjectItem> projects,
  List<ExperienceItem> experiences,
) {
  final rated = [for (final p in projects) if (p.rating != null) p.rating!];
  return ProofSummary(
    totalProjects: projects.length,
    liveApps: projects.where((p) => p.isLive).length,
    android: projects.any((p) => p.hasAndroid),
    ios: projects.any((p) => p.hasIos),
    buildingSinceYear: earliestStartYear(experiences),
    averageRating:
        rated.isEmpty ? null : rated.reduce((a, b) => a + b) / rated.length,
    ratedApps: rated.length,
  );
}
