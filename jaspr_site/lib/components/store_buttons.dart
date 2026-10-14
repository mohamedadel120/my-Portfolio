import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import 'project_view.dart';
import 'store_icons.dart';

/// The round Google Play / App Store buttons from the original showcase:
/// the platform's logo at rest, turning into its store mark and brand colour
/// on hover. The look (and all of its CSS) lives with the original showcase
/// under `.info-links`; this renders the same markup for the other designs,
/// with a descriptive label, and opening the store in a new tab.
///
/// A project that is on neither store shows "Coming soon" instead.
class StoreButtons extends StatelessComponent {
  final ProjectView view;

  /// False when the buttons belong to a hidden (inactive) panel, so keyboard
  /// focus does not land on them.
  final bool focusable;

  const StoreButtons(this.view, {this.focusable = true, super.key});

  @override
  Component build(BuildContext context) {
    final tab = focusable ? const <String, String>{} : const {'tabindex': '-1'};
    final androidUrl = view.androidUrl;
    final iosUrl = view.iosUrl;

    return div(classes: 'info-links', [
      if (androidUrl != null)
        a(
          href: androidUrl,
          classes: 'store-btn store-btn-play',
          target: Target.blank,
          attributes: {'rel': 'noopener', 'aria-label': 'Get ${view.title} on Google Play (opens in a new tab)', ...tab},
          [
            span(classes: 'store-tooltip', [.text('Google Play')]),
            svg([
              path(d: androidLogoPath, fill: const Color('currentColor'), []),
            ], viewBox: '0 0 24 24', width: 1.3.rem, height: 1.3.rem, classes: 'store-icon icon-default'),
            svg([
              path(d: googlePlayPath, fill: const Color('currentColor'), []),
            ], viewBox: '0 0 24 24', width: 1.3.rem, height: 1.3.rem, classes: 'store-icon icon-hover'),
          ],
        ),
      if (iosUrl != null)
        a(
          href: iosUrl,
          classes: 'store-btn store-btn-ios',
          target: Target.blank,
          attributes: {'rel': 'noopener', 'aria-label': 'Get ${view.title} on the App Store (opens in a new tab)', ...tab},
          [
            span(classes: 'store-tooltip', [.text('App Store')]),
            svg([
              path(d: appleLogoPath, fill: const Color('currentColor'), []),
            ], viewBox: '0 0 24 24', width: 1.3.rem, height: 1.3.rem, classes: 'store-icon icon-default'),
            div(classes: 'store-icon icon-hover appstore-glyph', [
              div(classes: 'as-bar as-bar-left', []),
              div(classes: 'as-bar as-bar-right', []),
              div(classes: 'as-bar as-bar-cross', []),
              div(classes: 'as-leaf', []),
            ]),
          ],
        ),
      // Not repeated when the project's own status line already says so.
      if (!view.hasStoreLink && !view.downloads.toLowerCase().contains('coming soon')) span(classes: 'sb-soon', [.text('Coming soon')]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.sb-soon', [
      css('&').styles(color: AppColors.textSecondary, fontSize: 0.9.rem, raw: {'align-self': 'center'}),
    ]),
  ];
}
