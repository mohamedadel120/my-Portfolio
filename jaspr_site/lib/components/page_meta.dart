import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

const siteUrl = 'https://muhammed-adel.web.app';

/// Per-page `<head>` entries: each route gets its own description and a
/// canonical URL, so search results don't show the same snippet for every
/// page. Site-wide tags (OG image, JSON-LD, ...) stay in main.server.dart.
class PageMeta extends StatelessComponent {
  /// Path of the page, e.g. `/` or `/about`.
  final String path;
  final String title;
  final String description;

  const PageMeta({super.key, required this.path, required this.title, required this.description});

  @override
  Component build(BuildContext context) {
    final url = path == '/' ? '$siteUrl/' : '$siteUrl$path';
    return Document.head(
      meta: {
        'description': description,
        'twitter:url': url,
        'twitter:title': title,
        'twitter:description': description,
      },
      children: [
        link(rel: 'canonical', href: url),
        meta(attributes: {'property': 'og:url', 'content': url}),
        meta(attributes: {'property': 'og:title', 'content': title}),
        meta(attributes: {'property': 'og:description', 'content': description}),
      ],
    );
  }
}
