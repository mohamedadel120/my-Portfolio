/// Local preview of the Firestore corrections in
/// docs/review/firestore-corrections.md, so the owner can see the corrected
/// content before editing the real database.
///
/// Only active with `--dart-define=PREVIEW_DATA=true` (the
/// `portfolio-preview-data` launch configuration). Every production build
/// leaves the projects exactly as Firestore returns them: Firestore stays the
/// only source of truth, and these values must be copied there to go live.
const previewData = bool.fromEnvironment('PREVIEW_DATA');

/// Field overrides per project, matched by a fragment of the title. Mirrors
/// the corrections document; keep the two in step.
const Map<String, Map<String, Object>> previewCorrections = {
  'Gomla': {
    'featured': true,
    'highlight': 'Not just a beauty store: AI reads your skin, you try makeup on before you buy, and it arrives at your door.',
    'problem': 'Buying beauty products usually means going to a store to try them, and not every product suits every skin. '
        'Many customers first had to see a dermatologist just to learn their skin type before they could buy something suitable.',
    'description': 'We built an app that uses AI to analyze your skin. It tells you your skin type, which products you need and which ones you do not. '
        'You can try products such as makeup virtually before buying, then order them and have them delivered to your door.',
    'downloads': '10,000+',
  },
  'Stock': {
    'description': 'A powerful B2B inventory management platform designed for businesses to efficiently track and manage their stock. '
        'Built with clean architecture and Bloc pattern for scalable state management. The app has passed 10,000+ downloads.',
    'downloads': '10,000+',
  },
  'Albatal': {
    'description': 'A full-featured marketplace platform that connects sellers and customers seamlessly. Includes a robust seller dashboard '
        'for inventory management, order processing, and analytics, while giving customers a smooth shopping experience.',
    'downloads': '1,000+',
  },
  'to-let': {
    'description': 'Rent smarter, move faster. to-let streamlines the entire renting process into one simple interface designed for people '
        'on the move, with instant discovery of places tailored to your budget and lifestyle.',
    'downloads': '',
  },
  'DrugZa': {
    'description': 'A specialized healthcare application connecting patients with pharmaceutical services. Features local data storage '
        'using SQLite and Hive for offline functionality, ensuring seamless access to medical information.',
    'downloads': '',
  },
};

/// Applies [previewCorrections] when [enabled]; otherwise returns [projects]
/// untouched (the same list instance). Featured projects move to the front,
/// as they do when the flag comes from Firestore.
List<Map<String, dynamic>> withPreviewData(List<Map<String, dynamic>> projects, {bool enabled = previewData}) {
  if (!enabled) return projects;
  final corrected = [
    for (final project in projects)
      {
        ...project,
        for (final entry in previewCorrections.entries)
          if ((project['title'] as String? ?? '').contains(entry.key)) ...entry.value,
      },
  ];
  return [
    ...corrected.where((p) => p['featured'] == true),
    ...corrected.where((p) => p['featured'] != true),
  ];
}
