import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/motion_css.dart';
import '../constants/theme.dart';
import 'project_view.dart';

/// "Read the case study" under a project's description, leading to its own
/// page. Renders nothing when the project has no page (no slug).
class CaseStudyLink extends StatelessComponent {
  final ProjectView view;

  /// False inside a hidden (inactive) panel, so keyboard focus skips it.
  final bool focusable;

  const CaseStudyLink(this.view, {this.focusable = true, super.key});

  @override
  Component build(BuildContext context) {
    final path = view.caseStudyPath;
    if (path == null) return const Component.fragment([]);
    return a(
      href: path,
      classes: 'case-link',
      attributes: {'aria-label': 'Read the ${view.title} case study', if (!focusable) 'tabindex': '-1'},
      [
        .text('Read the case study'),
        span(classes: 'material-symbols-rounded case-link-icon', attributes: {'aria-hidden': 'true'}, [.text('arrow_forward')]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.case-link', [
      css('&').styles(
        display: Display.inlineFlex,
        alignItems: AlignItems.center,
        gap: Gap.all(0.35.rem),
        fontFamily: FontFamily.list([AppFonts.body, FontFamilies.monospace]),
        fontSize: 0.92.rem,
        fontWeight: FontWeight.w700,
        textDecoration: TextDecoration.none,
        raw: {
          'align-self': 'flex-start',
          'color': 'var(--accent-fg, ${AppColors.primary.value})',
          'border-bottom': '1px solid currentColor',
          'padding-bottom': '2px',
        },
      ),
      css('&:focus-visible').styles(raw: {'outline': '2px solid #ffffff', 'outline-offset': '3px'}),
    ]),
    css('.case-link-icon').styles(
      width: 1.1.rem,
      height: 1.1.rem,
      overflow: Overflow.hidden,
      fontSize: 1.1.rem,
      raw: {'line-height': '1', 'transition': 'transform 180ms cubic-bezier(0.23, 1, 0.32, 1)'},
    ),
    RawMediaRule.hoverCapable([
      css('.case-link:hover .case-link-icon').styles(raw: {'transform': 'translateX(3px)'}),
    ]),
    MotionRule.reduced([
      css('.case-link-icon').styles(raw: {'transition': 'none'}),
    ]),
  ];
}
