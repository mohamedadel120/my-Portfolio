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
      // The visible words start the accessible name, so voice control users
      // can say what they see ("click read the case study").
      attributes: {'aria-label': 'Read the case study: ${view.title}', if (!focusable) 'tabindex': '-1'},
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
        fontFamily: AppFonts.body,
        fontSize: 0.92.rem,
        fontWeight: FontWeight.w700,
        textDecoration: TextDecoration.none,
        raw: {
          'align-self': 'flex-start',
          // Light look: ink text, underlined in the app's own colour.
          'color': lit('var(--accent-fg, ${AppColors.primary.value})', light: AppColors.textPrimary.value),
          'border-bottom': lit('1px solid currentColor', light: '2px solid var(--accent, ${AppColors.primary.value})'),
          'padding-bottom': '2px',
        },
      ),
      css('&:focus-visible').styles(raw: {'outline': '2px solid ${AppColors.textPrimary.value}', 'outline-offset': '3px'}),
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
