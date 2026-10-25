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
import 'constants/site_design.dart';
import 'constants/theme.dart';

// This file is generated automatically by Jaspr, do not remove or edit.
import 'main.server.options.dart';

void main() {
  // Initializes the server environment with the generated default options.
  // Design D brings its own stylesheet (web/d/d.css), so the component
  // styles of design c are left out: several of their names (.hero,
  // .store-icon) and their element rules (h1-h6, section) would otherwise
  // restyle D. The client components (the visit tracker) stay.
  final base = defaultServerOptions;
  Jaspr.initializeApp(
    options: isDesignD ? ServerOptions(clientId: base.clientId, clients: base.clients, stylesId: base.stylesId, styles: () => const []) : base,
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
    // Tells screen readers and search engines the page is in English.
    lang: 'en',
    title: 'Mohamed Adel - Flutter Developer Portfolio',
    meta: {
      'author': 'Mohamed Adel',
      'keywords': 'Flutter Developer, Mobile App Developer, Portfolio, Mohamed Adel, Dart, iOS, Android, Cross-platform Development',
      // Colours the phone's browser bar to match the page.
      'theme-color': AppColors.background.value,
      'twitter:card': 'summary_large_image',
      'twitter:image': ogImage,
    },
    head: [
      // Open the connections to Google Fonts early, then fetch the font
      // stylesheets without blocking the first paint: each is preloaded and
      // switched to a stylesheet once it arrives, so the page shows straight
      // away in the fallback fonts and swaps in Geist when it lands (text
      // fonts use display=swap; the icons sit in clipped boxes until theirs
      // arrives). Without JavaScript the <noscript> links load them normally.
      link(rel: 'preconnect', href: 'https://fonts.googleapis.com'),
      link(rel: 'preconnect', href: 'https://fonts.gstatic.com', attributes: const {'crossorigin': ''}),
      // The project screenshots are hosted on imgbb; the hero's phone shows
      // one on the first screen.
      link(rel: 'preconnect', href: 'https://i.ibb.co'),
      for (final href in isDesignD ? designDFonts : fontStylesheets)
        link(rel: 'preload', href: href, attributes: const {'as': 'style', 'onload': "this.onload=null;this.rel='stylesheet'"}),
      Component.element(tag: 'noscript', children: [for (final href in isDesignD ? designDFonts : fontStylesheets) link(rel: 'stylesheet', href: href)]),
      if (isDesignD) ...[
        link(rel: 'stylesheet', href: '/d/d.css'),
        script(src: '/d/d.js', attributes: const {'defer': ''}),
      ],
      link(rel: 'icon', type: 'image/png', href: 'favicon.png'),
      link(rel: 'manifest', href: 'manifest.json'),
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
