/// The entrypoint for the **server** environment.
///
/// The [main] method will only be executed on the server during pre-rendering.
/// To run code on the client, check the `main.client.dart` file.
library;

import 'package:jaspr/dom.dart';
// Server-specific Jaspr import.
import 'package:jaspr/server.dart';

// Imports the [App] component.
import 'app.dart';

// This file is generated automatically by Jaspr, do not remove or edit.
import 'main.server.options.dart';

void main() {
  // Initializes the server environment with the generated default options.
  Jaspr.initializeApp(
    options: defaultServerOptions,
  );

  // Starts the app.
  //
  // [Document] renders the root document structure (<html>, <head> and <body>)
  // with the provided parameters and components. Page-wide CSS lives in
  // constants/theme.dart's top-level @css `styles` getter instead of here,
  // so it's colocated with the design tokens it references.
  const siteUrl = 'https://muhammed-adel.web.app/';
  const ogImage = 'https://muhammed-adel.web.app/og_image.png';

  runApp(Document(
    lang: 'en',
    title: 'Mohamed Adel - Flutter Developer Portfolio',
    meta: {
      'author': 'Mohamed Adel',
      'keywords': 'Flutter Developer, Mobile App Developer, Portfolio, Mohamed Adel, Dart, iOS, Android, Cross-platform Development',
      'twitter:card': 'summary_large_image',
      'twitter:image': ogImage,
    },
    head: [
      link(rel: 'icon', type: 'image/png', href: 'favicon.png'),
      link(rel: 'manifest', href: 'manifest.json'),
      link(rel: 'stylesheet', href: 'polish.css'),
      // Document's `meta` map always renders a `name=` attribute; Open Graph
      // tags need `property=` per spec, so those go here via the raw
      // `attributes:` map instead of through `meta:` above.
      meta(attributes: {'property': 'og:type', 'content': 'website'}),
      // og:url/title/description, the meta description and the canonical
      // link are per page -- see components/page_meta.dart.
      meta(attributes: {'property': 'og:image', 'content': ogImage}),
      script(
        attributes: {'type': 'application/ld+json'},
        content: '''
{
  "@context": "https://schema.org",
  "@type": "Person",
  "name": "Mohamed Adel",
  "url": "$siteUrl",
  "image": "$ogImage",
  "sameAs": [
    "https://github.com/mohamedadel120",
    "https://www.linkedin.com/in/mohamed-adel-9454a1183/"
  ],
  "jobTitle": "Flutter Developer",
  "worksFor": { "@type": "Organization", "name": "The First-Agency" },
  "description": "Experienced Flutter Developer specializing in building high-quality mobile applications for iOS and Android."
}
''',
      ),
    ],
    body: App(),
  ));
}
