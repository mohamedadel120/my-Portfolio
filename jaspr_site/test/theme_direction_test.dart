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
  test('the current look is the default', () {
    expect(themeDirection, ThemeDirection.current);
    expect(isCalm, isFalse);
  });

  test('the current direction requests exactly the same fonts as before', () {
    expect(AppFonts.byDirection[ThemeDirection.current]!.importUrl, _todaysFontImport);
    expect(googleFontsUrl, _todaysFontImport);
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

  test('the page stylesheet imports the text fonts and the icons, nothing else', () {
    final imports = [
      for (final rule in styles)
        if (rule.toCss().trimLeft().startsWith('@import')) rule.toCss().trim(),
    ];
    expect(imports, hasLength(2));
    expect(imports[0], contains(googleFontsUrl));
    expect(imports[1], contains(materialSymbolsUrl));
  });

  for (final direction in [ThemeDirection.a, ThemeDirection.b]) {
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

  test('outside the new directions every component keeps its own font and size', () {
    expect(AppFonts.of(FontRole.display, was: AppFonts.orbitron).value, "'Orbitron', sans-serif");
    expect(AppType.size(TypeStep.display, was: 3.rem).value, '3rem');
    expect(AppColors.glow(0.5).value, AppColors.primary.withValues(alpha: 0.5).value);
    expect(AppColors.outline(0.3).value, AppColors.primary.withValues(alpha: 0.3).value);
  });
}
