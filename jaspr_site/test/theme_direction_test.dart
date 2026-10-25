import 'package:jaspr/dom.dart';
import 'package:jaspr_site/constants/theme.dart';
import 'package:test/test.dart';

/// The font import exactly as it was before the directions existed.
const _todaysFontImport = 'https://fonts.googleapis.com/css2'
    '?family=JetBrains+Mono:wght@400;500;700'
    '&family=IBM+Plex+Mono:wght@600;700;900'
    '&family=Fira+Code:wght@400;600'
    '&family=Space+Mono:wght@400;700'
    '&family=Oswald:wght@400;700'
    '&family=Orbitron:wght@500;700'
    '&family=Anton'
    '&display=swap';

void main() {
  test('direction c is the default; the others stay available', () {
    expect(themeDirection, ThemeDirection.c);
    expect(isLight, isTrue);
    expect(ThemeDirection.values, [ThemeDirection.current, ThemeDirection.a, ThemeDirection.b, ThemeDirection.c]);
    expect(googleFontsUrl, AppFonts.byDirection[ThemeDirection.c]!.importUrl);
  });

  test('the current direction requests exactly the same fonts as before', () {
    expect(AppFonts.byDirection[ThemeDirection.current]!.importUrl, _todaysFontImport);
  });

  test('the icon font import is unchanged', () {
    expect(
      materialSymbolsUrl,
      'https://fonts.googleapis.com/css2'
      '?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,400,0..1,0'
      '&icon_names=${materialIconNames.join(',')}'
      '&display=block',
    );
  });

  test('the page stylesheet imports nothing (an @import blocks the first paint)', () {
    final imports = [
      for (final rule in styles)
        if (rule.toCss().trimLeft().startsWith('@import')) rule.toCss().trim(),
    ];
    expect(imports, isEmpty);
  });

  test('reveal-on-scroll never hides content unless the client script has started', () {
    final css = [for (final rule in styles) rule.toCss()].join('\n');
    // Every rule that hides a .reveal element is scoped to html.reveal-ready,
    // which only the client script adds.
    final hiding = RegExp(r'([^{}]*\.reveal[^{}]*)\{[^}]*opacity:\s*0').allMatches(css).map((m) => m.group(1)!.trim());
    expect(hiding, isNotEmpty);
    for (final selector in hiding) {
      expect(selector, contains('html.reveal-ready'), reason: selector);
    }
  });

  test('the text fonts and the icon font are both loaded by the page head', () {
    expect(fontStylesheets, [googleFontsUrl, materialSymbolsUrl]);
  });

  for (final direction in [ThemeDirection.a, ThemeDirection.b, ThemeDirection.c]) {
    group('direction ${direction.name}', () {
      final fonts = AppFonts.byDirection[direction]!;

      test('loads at most 2 text families in one swap request', () {
        expect(fonts.loaded.length, lessThanOrEqualTo(2));
        expect({for (final f in fonts.loaded) f.name}, hasLength(fonts.loaded.length));
        final url = Uri.parse(fonts.importUrl);
        expect(url.host, 'fonts.googleapis.com');
        expect(RegExp('family=').allMatches(fonts.importUrl), hasLength(fonts.loaded.length));
        expect(fonts.importUrl, endsWith('&display=swap'));
        expect(fonts.importUrl, isNot(contains('Material')));
      });

      test('every role uses a loaded family', () {
        expect(fonts.roles.keys.toSet(), FontRole.values.toSet());
        for (final font in fonts.roles.values) {
          expect(fonts.loaded, contains(font));
        }
      });

      test('long text and headings are not monospace', () {
        for (final role in [FontRole.text, FontRole.heading, FontRole.display]) {
          expect(fonts.roles[role]!.generic, isNot(FontFamilies.monospace), reason: '$role');
        }
      });

      test('the type scale grows step by step', () {
        final fixed = [TypeStep.label, TypeStep.small, TypeStep.body, TypeStep.lead, TypeStep.h3];
        final rems = [for (final step in fixed) double.parse(AppType.scale(direction, step).value.replaceAll('rem', ''))];
        for (var i = 1; i < rems.length; i++) {
          expect(rems[i], greaterThan(rems[i - 1]));
        }
        for (final step in [TypeStep.h2, TypeStep.title, TypeStep.display]) {
          expect(AppType.scale(direction, step).value, startsWith('clamp('));
        }
      });
    });
  }

  test('in the default direction (c) components take the direction\'s fonts, scale and light colours', () {
    expect(AppFonts.of(FontRole.display, was: AppFonts.orbitron).value, "'Geist', sans-serif");
    expect(AppType.size(TypeStep.body, was: 3.rem).value, AppType.scale(ThemeDirection.c, TypeStep.body).value);
    // Light page: ink text, and no cyan glow.
    expect(AppColors.textPrimary.value, '#16171A');
    expect(AppColors.glow(0.5).value, isNot(AppColors.primary.withValues(alpha: 0.5).value));
  });
}
