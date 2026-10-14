/// A typed, defensive view over the plain `Map` a project travels in between
/// the server render and `@client` components (client constructor params must
/// be simple serialisable values, so projects cross that boundary as maps).
/// Every presentation variant reads projects through this class so missing or
/// wrongly typed fields behave identically everywhere.
class ProjectView {
  final String title;
  final String description;
  final List<String> tech;
  final List<String> images;
  final String? videoUrl;
  final String? androidUrl;
  final String? iosUrl;
  final String downloads;

  /// 24-bit RGB accent, alpha stripped.
  final int accentRgb;

  /// Owner-written case study copy as (label, value) pairs; empty when the
  /// owner has not written any.
  final List<(String, String)> facts;

  /// Owner-set emphasis: a "Featured" label and one headline claim.
  final bool featured;
  final String? highlight;

  /// URL name of the case study page; null when the project has none (for
  /// example in tests that build a map by hand).
  final String? slug;

  const ProjectView({
    required this.title,
    required this.description,
    required this.tech,
    required this.images,
    required this.videoUrl,
    required this.androidUrl,
    required this.iosUrl,
    required this.downloads,
    required this.accentRgb,
    required this.facts,
    this.featured = false,
    this.highlight,
    this.slug,
  });

  factory ProjectView.fromMap(Map<String, dynamic> map) {
    return ProjectView(
      title: (map['title'] as String?)?.trim() ?? '',
      description: (map['description'] as String?)?.trim() ?? '',
      tech: _strings(map['tech']),
      images: [for (final src in _strings(map['galleryImages'])) siteUrl(src)],
      videoUrl: switch (clean(map['videoUrl'])) { final url? => siteUrl(url), null => null },
      androidUrl: clean(map['androidStoreUrl']),
      iosUrl: clean(map['iosStoreUrl']),
      downloads: (map['downloads'] as String?)?.trim() ?? '',
      accentRgb: (map['color'] is int ? map['color'] as int : 0x00D9FF) & 0xFFFFFF,
      facts: [
        if (clean(map['role']) case final role?) ('My role', role),
        if (clean(map['problem']) case final problem?) ('The problem', problem),
        if (clean(map['outcome']) case final outcome?) ('The outcome', outcome),
      ],
      featured: map['featured'] == true,
      highlight: clean(map['highlight']),
      slug: clean(map['slug']),
    );
  }

  bool get hasStoreLink => androidUrl != null || iosUrl != null;

  /// Address of this project's case study page, or null without a slug.
  String? get caseStudyPath => slug == null ? null : '/projects/$slug';

  /// The owner-written story fields, each null until written.
  String? factOf(String label) => [for (final (l, v) in facts) if (l == label) v].firstOrNull;

  /// "Android and iOS", "Android", ... from the store links; empty when the
  /// project is on neither store.
  String get platforms => [if (androidUrl != null) 'Android', if (iosUrl != null) 'iOS'].join(' and ');

  /// A `#rrggbb` string safe to drop into a CSS custom property.
  String get accentHex => '#${accentRgb.toRadixString(16).padLeft(6, '0')}';

  static String? clean(Object? value) {
    if (value is! String) return null;
    final text = value.trim();
    return text.isEmpty ? null : text;
  }

  static List<String> _strings(Object? value) =>
      value is List ? value.whereType<String>().where((s) => s.trim().isNotEmpty).toList() : const [];
}

/// Media paths stored in Firestore may be relative to the site root
/// (`assets/videos/demo.mp4`). Relative URLs resolve against the current page,
/// so on `/projects` they would point at `/projects/assets/...`; anchor them at
/// the root instead. Absolute URLs (`https://`, `//`, `data:`) and paths that
/// already start with `/` are returned unchanged.
String siteUrl(String url) {
  final trimmed = url.trim();
  if (trimmed.startsWith('/') || RegExp(r'^[a-zA-Z][a-zA-Z0-9+.-]*:').hasMatch(trimmed)) return trimmed;
  return '/$trimmed';
}
