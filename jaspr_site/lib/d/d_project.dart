import '../data/projects_repository.dart';

/// Escapes text for HTML element content and quoted attribute values. Design
/// D renders its markup as HTML strings (see d_markup.dart), so every value
/// that comes from Firestore goes through here.
String esc(String text) => text
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#39;');

/// Store glyphs (Simple Icons, CC0).
const playGlyph =
    '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M22.018 13.298l-3.919 2.218-3.515-3.493 3.543-3.521 3.891 2.202a1.49 1.49 0 0 1 0 2.594zM1.337.924a1.486 1.486 0 0 0-.112.568v21.017c0 .217.045.419.124.6l11.155-11.087L1.337.924zm12.207 10.065l3.258-3.238L3.45.195a1.466 1.466 0 0 0-.946-.179l11.04 10.973zm0 2.067l-11 10.933c.298.036.612-.016.906-.183l13.324-7.54-3.23-3.21z"/></svg>';
const appleGlyph =
    '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M12.152 6.896c-.948 0-2.415-1.078-3.96-1.04-2.04.027-3.91 1.183-4.961 3.014-2.117 3.675-.546 9.103 1.519 12.09 1.013 1.454 2.208 3.09 3.792 3.039 1.52-.065 2.09-.987 3.935-.987 1.831 0 2.35.987 3.96.948 1.637-.026 2.676-1.48 3.676-2.948 1.156-1.688 1.636-3.325 1.662-3.415-.039-.013-3.182-1.221-3.22-4.857-.026-3.04 2.48-4.494 2.597-4.559-1.429-2.09-3.623-2.324-4.39-2.376-2-.156-3.675 1.09-4.61 1.09zM15.53 3.83c.843-1.012 1.4-2.427 1.245-3.83-1.207.052-2.662.805-3.532 1.818-.78.896-1.454 2.338-1.273 3.714 1.338.104 2.715-.688 3.559-1.701"/></svg>';

/// One store link of a project: where it goes and, when the owner added the
/// listing in the dashboard, what the store shows (for the preview card).
class DStore {
  final String store; // 'play' or 'ios'
  final String url;
  final StoreListing? listing;
  const DStore(this.store, this.url, this.listing);

  String get label => store == 'play' ? 'Google Play' : 'App Store';
  String get device => store == 'play' ? 'Android' : 'iPhone';
}

/// A project as design D shows it: the Firestore item plus its page address
/// and the facts derived for display. Nothing here is invented: a value that
/// cannot be derived from the owner's data is null or empty and not shown.
class DProject {
  final ProjectItem item;
  final String slug;
  const DProject(this.item, this.slug);

  /// Short name for stages and labels: the title without "Mobile App" and
  /// without a " - Subtitle" part (DrugZa - TagPharma -> DrugZa).
  String get name {
    var n = item.title.replaceAll(RegExp(r'\s+Mobile App$', caseSensitive: false), '').trim();
    final dash = n.indexOf(' - ');
    if (dash > 0) n = n.substring(0, dash);
    return n.isEmpty ? item.title : n;
  }

  String get title => item.title;
  String get overview => item.description;
  List<String> get stack => item.tech;

  /// '#RRGGBB' from the project's colour, for the stage's tint.
  String get tint => '#${(item.color & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';

  /// 'Android · iOS', 'Android', 'iOS' or '' from the store links.
  String get platforms => [if (item.hasAndroid) 'Android', if (item.hasIos) 'iOS'].join(' · ');

  /// The download count when `downloads` is a number like "10,000+".
  int? get downloads {
    final m = RegExp(r'^\s*([\d,]+)\s*\+?\s*$').firstMatch(item.downloads);
    return m == null ? null : int.tryParse(m.group(1)!.replaceAll(',', ''));
  }

  /// `downloads` when it is words instead ("Active Development").
  String? get status => downloads == null && item.downloads.trim().isNotEmpty ? item.downloads.trim() : null;

  List<DStore> get stores => [
    if (item.hasAndroid) DStore('play', item.androidStoreUrl!.trim(), item.listing('play')),
    if (item.hasIos) DStore('ios', item.iosStoreUrl!.trim(), item.listing('ios')),
  ];

  /// The display mode, falling back sensibly for projects not set up yet:
  /// a video with no screens plays the video, otherwise the gallery shows.
  ShowcaseMode get mode {
    if (item.showcase.mode case final m?) return m;
    final hasVideo = (item.videoUrl ?? '').trim().isNotEmpty;
    return hasVideo && (item.galleryImages ?? const []).isEmpty ? ShowcaseMode.video : ShowcaseMode.screens;
  }

  /// The screens to show: the chosen ones, or the gallery without labels.
  List<ShowcaseScreen> get screens => item.showcase.screens.isNotEmpty
      ? item.showcase.screens
      : [for (final (i, url) in (item.galleryImages ?? const <String>[]).indexed) ShowcaseScreen(url: url, caption: 'Screen ${i + 1}')];

  String? get videoUrl => (item.videoUrl ?? '').trim().isEmpty ? null : item.videoUrl!.trim();
}
