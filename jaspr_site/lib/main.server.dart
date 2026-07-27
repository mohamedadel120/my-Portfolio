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
  const description =
      'Mohamed Adel - Flutter Developer Portfolio. A modern, animated portfolio website showcasing mobile app development expertise, projects, and experience.';
  const siteUrl = 'https://muhammed-adel.web.app/';
  const ogImage = 'https://muhammed-adel.web.app/og_image.png';

  runApp(Document(
    title: 'Mohamed Adel - Flutter Developer Portfolio',
    meta: {
      'description': description,
      'author': 'Mohamed Adel',
      'keywords': 'Flutter Developer, Mobile App Developer, Portfolio, Mohamed Adel, Dart, iOS, Android, Cross-platform Development',
      'twitter:card': 'summary_large_image',
      'twitter:url': siteUrl,
      'twitter:title': 'Mohamed Adel - Flutter Developer Portfolio',
      'twitter:description': description,
      'twitter:image': ogImage,
    },
    head: [
      link(rel: 'icon', type: 'image/png', href: 'favicon.png'),
      link(rel: 'manifest', href: 'manifest.json'),
      // Document's `meta` map always renders a `name=` attribute; Open Graph
      // tags need `property=` per spec, so those go here via the raw
      // `attributes:` map instead of through `meta:` above.
      meta(attributes: {'property': 'og:type', 'content': 'website'}),
      meta(attributes: {'property': 'og:url', 'content': siteUrl}),
      meta(attributes: {'property': 'og:title', 'content': 'Mohamed Adel - Flutter Developer Portfolio'}),
      meta(attributes: {'property': 'og:description', 'content': description}),
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
  "worksFor": { "@type": "Organization", "name": "Freelance" },
  "description": "Experienced Flutter Developer specializing in building high-quality mobile applications for iOS and Android."
}
''',
      ),
    ],
    body: App(),
  ));
}
