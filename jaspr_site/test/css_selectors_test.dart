import 'dart:convert';

import 'package:jaspr/server.dart';
import 'package:jaspr_site/components/contact_form.dart';
import 'package:jaspr_site/constants/projects_variant.dart';
import 'package:jaspr_site/constants/theme.dart' as theme;
import 'package:jaspr_site/main.server.options.dart';
import 'package:jaspr_site/sections/projects_section.dart';
import 'package:test/test.dart';

/// Inside a nested rule Jaspr prefixes only the FIRST part of a comma
/// selector: `css('.phone-screen', [css('img, video')])` becomes
/// `.phone-screen img, video`, a global rule. That hid every <video> on the
/// site. This renders the components that nest rules and fails on any comma
/// selector whose first part is scoped under a class and a later part is not
/// under the same class.
void main() {
  setUpAll(() => Jaspr.initializeApp(options: defaultServerOptions));

  Future<String> cssOf(Component component) async {
    final html = utf8.decode((await renderComponent(component, standalone: true)).body);
    return RegExp(r'<style[^>]*>([\s\S]*?)</style>').allMatches(html).map((m) => m.group(1)!).join('\n');
  }

  final project = {
    'title': 'App',
    'description': 'Text',
    'tech': ['Flutter'],
    'color': 0xFF00D9FF,
    'downloads': '',
    'galleryImages': ['https://img.test/1.webp'],
    'androidStoreUrl': 'https://play.google.com/store/apps/details?id=a',
    'iosStoreUrl': 'https://apps.apple.com/app/id1',
    'videoUrl': null,
  };

  for (final (name, component) in [
    ('original showcase', ProjectsSection.showcase(ProjectsVariant.v1, [project])),
    ('pinned showcase', ProjectsSection.showcase(ProjectsVariant.pinnedShowcase, [project])),
    ('contact form', const ContactForm(recipientEmail: 'a@b.test')),
  ]) {
    test('$name: no comma selector leaks out of its parent rule', () async {
      final css = await cssOf(component);
      // The page-wide stylesheet (constants/theme.dart) writes its global
      // comma rules out in full on purpose; only nested component rules can
      // leak this way.
      final global = {
        for (final rule in theme.styles)
          for (final m in RegExp(r'([^{}@]+)\{').allMatches(rule.toCss())) m.group(1)!.trim(),
      };
      final leaks = <String>[];
      for (final match in RegExp(r'([^{}@]+)\{').allMatches(css)) {
        if (global.contains(match.group(1)!.trim())) continue;
        final parts = match.group(1)!.split(',').map((p) => p.trim()).where((p) => p.isNotEmpty).toList();
        if (parts.length < 2) continue;
        final first = parts.first.split(RegExp(r'\s+'));
        // Only rules generated from nesting: the first part is "<.scope> <child>".
        if (first.length < 2 || !first.first.startsWith('.')) continue;
        final scope = first.first;
        for (final part in parts.skip(1)) {
          if (!part.startsWith(scope)) leaks.add('${match.group(1)!.trim()}  ->  "$part" is unscoped');
        }
      }
      expect(leaks, isEmpty, reason: leaks.join('\n'));
    });
  }
}
