/// Which design the site renders.
enum SiteDesign {
  /// Direction c: the light, product-first design (v3).
  c,

  /// Design D: the scroll-craft build ("the build, taken apart"): living app
  /// stages, inspector labels, store previews, the career as a log.
  d,
}

/// Chosen at build time with `--dart-define=SITE_DESIGN=c` to bring back
/// design c; D otherwise (owner's choice, 25 Oct 2026).
const _requested = String.fromEnvironment('SITE_DESIGN');

const siteDesign = _requested == 'c' ? SiteDesign.c : SiteDesign.d;

const isDesignD = siteDesign == SiteDesign.d;

/// Design D's fonts: Geist for text, Geist Mono for the technical details.
const designDFonts = ['https://fonts.googleapis.com/css2?family=Geist:wght@400;500;600&family=Geist+Mono:wght@400;500&display=swap'];
