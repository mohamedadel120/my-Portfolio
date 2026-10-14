/// The URL name of a project's case study page (`/projects/<slug>`), made
/// from its title: "Gomla Mobile App" becomes `gomla`, "DrugZa - TagPharma"
/// becomes `drugza-tagpharma`. The words "mobile app" add nothing to a URL
/// and are dropped. A title with no Latin letters or digits gives `project`.
String projectSlug(String title) {
  final slug = title
      .toLowerCase()
      .replaceAll(RegExp(r'\bmobile app\b'), ' ')
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
  return slug.isEmpty ? 'project' : slug;
}

/// Gives every project a unique `slug`: the owner's own (Firestore `slug`)
/// when it is set, otherwise one made from the title. A repeated slug gets
/// `-2`, `-3`, ... so no two pages share an address. Returns new maps; the
/// order of [projects] is kept.
List<Map<String, dynamic>> withSlugs(List<Map<String, dynamic>> projects) {
  final taken = <String>{};
  return [
    for (final project in projects)
      {
        ...project,
        'slug': _unique(_ownSlug(project['slug']) ?? projectSlug(project['title'] as String? ?? ''), taken),
      },
  ];
}

/// The owner's slug, cleaned to the same rules as a generated one, or null.
String? _ownSlug(Object? raw) {
  if (raw is! String || raw.trim().isEmpty) return null;
  final cleaned = raw.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-').replaceAll(RegExp(r'^-+|-+$'), '');
  return cleaned.isEmpty ? null : cleaned;
}

String _unique(String slug, Set<String> taken) {
  var candidate = slug;
  for (var n = 2; taken.contains(candidate); n++) {
    candidate = '$slug-$n';
  }
  taken.add(candidate);
  return candidate;
}
