import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/motion_css.dart';
import '../constants/theme.dart';

/// The one call to action every project presentation uses (one label for one
/// intent), pointing at the contact section.
const ctaLabel = "Let's build yours";

class CtaLink extends StatelessComponent {
  /// False inside a hidden (inactive) panel, so keyboard focus skips it.
  final bool focusable;

  const CtaLink({this.focusable = true, super.key});

  @override
  Component build(BuildContext context) {
    return a(
      href: '#contact',
      classes: 'cta-btn',
      attributes: {if (!focusable) 'tabindex': '-1'},
      [
        span(classes: 'cta-label', [.text(ctaLabel)]),
        // The icon font renders text until it loads; the fixed, clipped box
        // keeps that raw text from flashing.
        span(classes: 'material-symbols-rounded cta-icon', attributes: {'aria-hidden': 'true'}, [.text('rocket_launch')]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.cta-btn', [
      css('&').styles(
        display: Display.inlineFlex,
        alignItems: AlignItems.center,
        gap: Gap.all(0.6.rem),
        minHeight: 3.rem,
        padding: Padding.symmetric(horizontal: 1.5.rem),
        radius: BorderRadius.circular(0.9.rem),
        backgroundColor: AppColors.primary,
        color: AppColors.background,
        textDecoration: TextDecoration.none,
        fontFamily: FontFamily.list([AppFonts.body, FontFamilies.monospace]),
        fontSize: 1.rem,
        fontWeight: FontWeight.w800,
        raw: {
          'box-shadow': '0 10px 28px -10px ${AppColors.primary.withValues(alpha: 0.7).value}, inset 0 1px 0 rgba(255,255,255,0.35)',
          'transition': 'transform 180ms cubic-bezier(0.23, 1, 0.32, 1), box-shadow 180ms ease',
        },
      ),
      css('&:active').styles(transform: Transform.scale(0.97)),
      css('&:focus-visible').styles(raw: {'outline': '2px solid #ffffff', 'outline-offset': '3px'}),
    ]),
    css('.cta-icon', [
      css('&').styles(
        width: 1.35.rem,
        height: 1.35.rem,
        overflow: Overflow.hidden,
        fontSize: 1.35.rem,
        raw: {'flex': '0 0 auto', 'line-height': '1', 'transition': 'transform 220ms cubic-bezier(0.23, 1, 0.32, 1)'},
      ),
    ]),
    // The rocket lifts off on hover; only for real pointers, so a tap on a
    // phone does not leave it stuck mid-flight.
    RawMediaRule.hoverCapable([
      css('.cta-btn:hover').styles(
        transform: Transform.translate(y: (-2).px),
        raw: {'box-shadow': '0 16px 34px -10px ${AppColors.primary.withValues(alpha: 0.85).value}, inset 0 1px 0 rgba(255,255,255,0.35)'},
      ),
      css('.cta-btn:hover .cta-icon').styles(raw: {'transform': 'translate(3px, -3px) rotate(8deg)'}),
    ]),
    MotionRule.reduced([
      css('.cta-btn, .cta-icon').styles(raw: {'transition': 'none'}),
    ]),
  ];
}
