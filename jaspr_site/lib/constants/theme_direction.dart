/// Which visual direction the site renders. All three show the same content
/// and layout; they differ in fonts, type scale, surfaces and how loudly the
/// accent colour is used. `current` is today's look and the default.
enum ThemeDirection {
  /// Today's look, unchanged: seven Google Fonts families, glowing accents,
  /// the "<LABEL />" nav motif and the custom cursor.
  current,

  /// Modern product: one geometric sans (Manrope) for everything readable,
  /// JetBrains Mono only for small labels, numbers and tags.
  a,

  /// Editorial and personal: a soft serif (Fraunces) for headings, a clean
  /// sans (Inter) for text and labels, no monospace at all.
  b,

  /// Product-first and light: a warm off-white page where the colour comes
  /// from the apps themselves (each project's own accent), a deep teal in
  /// place of the neon cyan, soft real shadows instead of glows, and one
  /// type family (Geist, with Geist Mono for numbers and tags). The hero
  /// shows a phone with the featured app rather than only text.
  c,
}

/// Chosen at launch with `--dart-define=THEME_DIRECTION=a` (or `b`), see
/// `.claude/launch.json`. Without it the current look is used.
const _requested = String.fromEnvironment('THEME_DIRECTION');

const themeDirection = _requested == 'a'
    ? ThemeDirection.a
    : _requested == 'b'
    ? ThemeDirection.b
    : _requested == 'c'
    ? ThemeDirection.c
    : ThemeDirection.current;

/// Direction c is the only light one: everything that assumes a dark page
/// (white text, white hairlines, glows) asks this.
const isLight = themeDirection == ThemeDirection.c;

/// [dark] on the dark directions, [light] on direction c.
T lit<T>(T dark, {required T light}) => isLight ? light : dark;

/// True for the new directions, which share the calmer surfaces, the single
/// type scale and the quieter accent.
const isCalm = themeDirection != ThemeDirection.current;

/// [current] for today's look, [calm] for directions a and b. Used where a
/// component's own value differs between the two, so today's value stays
/// readable right next to the new one.
T themed<T>(T current, {required T calm}) => isCalm ? calm : current;
