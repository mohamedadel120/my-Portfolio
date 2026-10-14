import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/cta_link.dart';
import '../components/featured_label.dart';
import '../components/page_meta.dart';
import '../components/project_gallery.dart';
import '../components/project_view.dart';
import '../components/store_buttons.dart';
import '../constants/motion_css.dart';
import '../constants/theme.dart';

/// One project's own page (`/projects/<slug>`): what the app is, the problem
/// it solves, the visitor's way to the stores, and every screenshot.
///
/// Everything comes from the project's Firestore document. The story parts
/// (`problem`, `role`, `outcome`) are owner-written and optional: a part that
/// has not been written is left out, never filled in, so the page is honest
/// for every project and grows as the owner adds to it.
class ProjectCaseStudy extends StatelessComponent {
  final Map<String, dynamic> project;

  /// The neighbours in the projects list, for "previous / next" at the end.
  /// Null when there is no other project.
  final Map<String, dynamic>? previous;
  final Map<String, dynamic>? next;

  const ProjectCaseStudy({super.key, required this.project, this.previous, this.next});

  /// The browser tab and search result title for [view].
  static String pageTitle(ProjectView view) => '${view.title} case study - Mohamed Adel';

  /// One-line summary for search results: the owner's highlight, else the
  /// start of the description.
  static String pageDescription(ProjectView view) {
    final text = view.highlight ?? view.description;
    if (text.length <= 160) return text;
    final cut = text.substring(0, 157);
    final space = cut.lastIndexOf(' ');
    return '${space > 100 ? cut.substring(0, space) : cut}...';
  }

  @override
  Component build(BuildContext context) {
    final view = ProjectView.fromMap(project);
    final problem = view.factOf('The problem');
    final role = view.factOf('My role');
    final outcome = view.factOf('The outcome');
    final previousView = previous == null ? null : ProjectView.fromMap(previous!);
    final nextView = next == null ? null : ProjectView.fromMap(next!);
    final videoUrl = view.videoUrl;

    return Component.fragment([
      PageMeta(path: view.caseStudyPath ?? '/projects', title: pageTitle(view), description: pageDescription(view)),
      article(
        classes: 'cs',
        styles: Styles(raw: {'--accent': view.accentHex}),
        [
          a(href: '/projects', classes: 'cs-back', [
            span(classes: 'material-symbols-rounded cs-back-icon', attributes: {'aria-hidden': 'true'}, [.text('arrow_back')]),
            .text('All projects'),
          ]),
          div(classes: 'cs-hero', [
            div(classes: 'cs-intro', [
              p(classes: 'cs-kicker', [.text('Case study')]),
              h1(classes: 'cs-title', [.text(view.title)]),
              FeaturedLabel(view),
              if (view.downloads.isNotEmpty || view.platforms.isNotEmpty)
                dl(classes: 'cs-facts', [
                  if (view.downloads.isNotEmpty)
                    div(classes: 'cs-fact', [
                      // "10,000+" is a download count; "Coming Soon" is a status.
                      dt([.text(view.downloads.contains(RegExp(r'\d')) ? 'Downloads' : 'Status')]),
                      dd([.text(view.downloads)]),
                    ]),
                  if (view.platforms.isNotEmpty)
                    div(classes: 'cs-fact', [
                      dt([.text('Available on')]),
                      dd([.text(view.platforms)]),
                    ]),
                ]),
              div(classes: 'cs-links', [StoreButtons(view), const CtaLink()]),
            ]),
            if (view.images.isNotEmpty) div(classes: 'cs-media', [ProjectGallery(title: view.title, images: view.images)]),
          ]),
          div(classes: 'cs-story', [
            if (problem != null) _part('The problem', [p([.text(problem)])]),
            // With a problem above it, the description reads as the answer.
            if (view.description.isNotEmpty) _part(problem != null ? 'The solution' : 'Overview', [p([.text(view.description)])]),
            if (role != null) _part('My role', [p([.text(role)])]),
            if (outcome != null) _part('The outcome', [p([.text(outcome)])]),
            if (view.tech.isNotEmpty)
              _part('Built with', [
                ul(classes: 'cs-tech', [for (final item in view.tech) li([.text(item)])]),
              ]),
            if (videoUrl != null)
              _part('See it in action', [
                video(
                  classes: 'cs-video',
                  src: videoUrl,
                  controls: true,
                  preload: Preload.none,
                  attributes: const {'playsinline': ''},
                  [],
                ),
              ]),
          ]),
          if (previousView != null || nextView != null)
            nav(classes: 'cs-more', attributes: {'aria-label': 'More projects'}, [
              if (previousView != null) _neighbour(previousView, 'Previous project', isNext: false),
              if (nextView != null && nextView.slug != previousView?.slug) _neighbour(nextView, 'Next project', isNext: true),
            ]),
          div(classes: 'cs-closing', [
            h2(classes: 'cs-closing-title', [.text('Have an app in mind?')]),
            p(classes: 'cs-closing-text', [.text('Tell me about it, and we can talk about how to build it for Android and iOS.')]),
            const CtaLink(),
          ]),
        ],
      ),
    ]);
  }

  static Component _part(String heading, List<Component> body) {
    return section(classes: 'cs-part reveal', [
      h2(classes: 'cs-part-title', [.text(heading)]),
      div(classes: 'cs-part-body', body),
    ]);
  }

  static Component _neighbour(ProjectView view, String label, {required bool isNext}) {
    return a(
      href: view.caseStudyPath ?? '/projects',
      classes: isNext ? 'cs-next cs-next-forward' : 'cs-next',
      styles: Styles(raw: {'--accent': view.accentHex}),
      [
        span(classes: 'cs-next-label', [
          if (!isNext) span(classes: 'material-symbols-rounded cs-next-icon', attributes: {'aria-hidden': 'true'}, [.text('arrow_back')]),
          .text(label),
          if (isNext) span(classes: 'material-symbols-rounded cs-next-icon', attributes: {'aria-hidden': 'true'}, [.text('arrow_forward')]),
        ]),
        span(classes: 'cs-next-title', [.text(view.title)]),
      ],
    );
  }

  static const _mono = FontFamily.list([AppFonts.body, FontFamilies.monospace]);

  @css
  static List<StyleRule> get styles => [
    css('.cs', [
      css('&').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        gap: Gap.all(4.rem),
        maxWidth: 72.rem,
        margin: Margin.symmetric(horizontal: Unit.auto),
        padding: Padding.only(top: 8.rem, bottom: 6.rem, left: 2.5.rem, right: 2.5.rem),
        raw: {'--accent-fg': 'color-mix(in srgb, var(--accent) 62%, #ffffff)'},
      ),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile.px), [
        css('&').styles(gap: Gap.all(3.rem), padding: Padding.only(top: 6.5.rem, bottom: 4.rem, left: 1.25.rem, right: 1.25.rem)),
      ]),
    ]),
    css('.cs-back', [
      css('&').styles(
        display: Display.inlineFlex,
        alignItems: AlignItems.center,
        gap: Gap.all(0.4.rem),
        color: AppColors.textSecondary,
        fontFamily: _mono,
        fontSize: 0.9.rem,
        textDecoration: TextDecoration.none,
        raw: {'align-self': 'flex-start', 'margin-bottom': '-2rem', 'transition': 'color 160ms ease'},
      ),
      css('&:hover').styles(color: AppColors.primary),
      css('&:focus-visible').styles(raw: {'outline': '2px solid ${AppColors.primary.value}', 'outline-offset': '4px'}),
    ]),
    css('.cs-back-icon, .cs-next-icon').styles(
      width: 1.1.rem,
      height: 1.1.rem,
      overflow: Overflow.hidden,
      fontSize: 1.1.rem,
      raw: {'line-height': '1', 'flex': '0 0 auto'},
    ),
    // Text beside the phone on wide screens, stacked on narrow ones.
    css('.cs-hero', [
      css('&').styles(
        display: Display.grid,
        alignItems: AlignItems.center,
        raw: {'grid-template-columns': 'minmax(0, 1fr) auto', 'gap': '3rem 4rem'},
      ),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.tablet.px), [
        css('&').styles(raw: {'grid-template-columns': 'minmax(0, 1fr)'}),
      ]),
    ]),
    css('.cs-intro', [
      css('&').styles(display: Display.flex, flexDirection: FlexDirection.column, gap: Gap.all(1.25.rem), raw: {'min-width': '0'}),
    ]),
    css('.cs-kicker').styles(
      margin: Margin.zero,
      fontFamily: _mono,
      fontSize: 0.85.rem,
      fontWeight: FontWeight.w700,
      raw: {'color': 'var(--accent-fg)', 'letter-spacing': '0.12em', 'text-transform': 'uppercase'},
    ),
    css('.cs-title').styles(
      margin: Margin.zero,
      color: AppColors.textPrimary,
      fontFamily: FontFamily.list([AppFonts.heading, FontFamilies.monospace]),
      fontSize: Unit.expression('clamp(2rem, 5vw, 3.4rem)'),
      fontWeight: FontWeight.w700,
      lineHeight: Unit.expression('1.08'),
      raw: {'text-wrap': 'balance', 'overflow-wrap': 'anywhere'},
    ),
    css('.cs-facts', [
      css('&').styles(display: Display.flex, flexWrap: FlexWrap.wrap, margin: Margin.zero, raw: {'gap': '1rem 2.5rem'}),
      css('dt').styles(color: AppColors.textTertiary, fontFamily: _mono, fontSize: 0.78.rem),
      css('dd').styles(
        margin: Margin.fromLTRB(Unit.zero, 0.25.rem, Unit.zero, Unit.zero),
        color: AppColors.textPrimary,
        fontFamily: _mono,
        fontSize: 1.15.rem,
        fontWeight: FontWeight.w700,
        raw: {'font-variant-numeric': 'tabular-nums'},
      ),
    ]),
    css('.cs-links', [
      css('&').styles(display: Display.flex, flexWrap: FlexWrap.wrap, alignItems: AlignItems.center, gap: Gap.all(1.rem), raw: {'margin-top': '0.75rem'}),
      css('.info-links').styles(gap: Gap.all(0.85.rem)),
    ]),
    css('.cs-media', [
      css('&').styles(display: Display.flex, justifyContent: JustifyContent.center, raw: {'min-width': '0'}),
    ]),
    // The story: a heading column and a text column, one row per part.
    css('.cs-story', [
      css('&').styles(display: Display.flex, flexDirection: FlexDirection.column),
    ]),
    css('.cs-part', [
      css('&').styles(
        display: Display.grid,
        padding: Padding.symmetric(vertical: 2.25.rem),
        border: Border.only(top: BorderSide(color: AppColors.textPrimary.withValues(alpha: 0.12), width: 1.px)),
        raw: {'grid-template-columns': '14rem minmax(0, 1fr)', 'gap': '1rem 3rem'},
      ),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile.px), [
        css('&').styles(padding: Padding.symmetric(vertical: 1.75.rem), raw: {'grid-template-columns': 'minmax(0, 1fr)'}),
      ]),
    ]),
    css('.cs-part-title').styles(
      margin: Margin.zero,
      fontFamily: _mono,
      fontSize: 0.95.rem,
      fontWeight: FontWeight.w700,
      raw: {'color': 'var(--accent-fg)', 'letter-spacing': '0.04em'},
    ),
    css('.cs-part-body', [
      css('&').styles(raw: {'min-width': '0'}),
      css('p').styles(
        margin: Margin.zero,
        color: AppColors.textSecondary,
        fontSize: Unit.expression('clamp(1rem, 1.6vw, 1.15rem)'),
        lineHeight: Unit.expression('1.75'),
        maxWidth: Unit.expression('62ch'),
        raw: {'white-space': 'pre-line'},
      ),
    ]),
    css('.cs-tech', [
      css('&').styles(display: Display.flex, flexWrap: FlexWrap.wrap, gap: Gap.all(0.6.rem), margin: Margin.zero, padding: Padding.zero, listStyle: ListStyle.none),
      css('li').styles(
        padding: Padding.symmetric(horizontal: 0.85.rem, vertical: 0.4.rem),
        radius: BorderRadius.circular(2.rem),
        border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.18), width: 1.px),
        color: AppColors.textPrimary,
        fontFamily: _mono,
        fontSize: 0.85.rem,
      ),
    ]),
    css('.cs-video').styles(
      display: Display.block,
      maxWidth: 100.percent,
      radius: BorderRadius.circular(1.rem),
      raw: {'max-height': '70vh', 'background': '#000'},
    ),
    // Previous / next project.
    css('.cs-more', [
      css('&').styles(display: Display.grid, raw: {'grid-template-columns': 'repeat(auto-fit, minmax(15rem, 1fr))', 'gap': '1rem'}),
    ]),
    css('.cs-next', [
      css('&').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        gap: Gap.all(0.5.rem),
        padding: Padding.all(1.5.rem),
        radius: BorderRadius.circular(1.rem),
        border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.12), width: 1.px),
        backgroundColor: AppColors.surface,
        textDecoration: TextDecoration.none,
        raw: {
          'border-left': '3px solid var(--accent)',
          'transition': 'border-color 180ms ease, transform 180ms cubic-bezier(0.23, 1, 0.32, 1)',
        },
      ),
      css('&:focus-visible').styles(raw: {'outline': '2px solid ${AppColors.primary.value}', 'outline-offset': '3px'}),
    ]),
    css('.cs-next-forward').styles(raw: {'align-items': 'flex-end', 'text-align': 'right', 'border-left': '1px solid rgba(255,255,255,0.12)', 'border-right': '3px solid var(--accent)'}),
    css('.cs-next-label').styles(
      display: Display.inlineFlex,
      alignItems: AlignItems.center,
      gap: Gap.all(0.35.rem),
      color: AppColors.textTertiary,
      fontFamily: _mono,
      fontSize: 0.8.rem,
    ),
    css('.cs-next-title').styles(
      color: AppColors.textPrimary,
      fontFamily: FontFamily.list([AppFonts.heading, FontFamilies.monospace]),
      fontSize: 1.25.rem,
      fontWeight: FontWeight.w700,
    ),
    RawMediaRule.hoverCapable([
      css('.cs-next:hover').styles(raw: {'transform': 'translateY(-2px)', 'border-color': 'var(--accent)'}),
    ]),
    MotionRule.reduced([
      css('.cs-next').styles(raw: {'transition': 'none'}),
    ]),
    // Closing call to action.
    css('.cs-closing', [
      css('&').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        alignItems: AlignItems.center,
        gap: Gap.all(1.rem),
        padding: Padding.symmetric(vertical: 3.rem, horizontal: 1.5.rem),
        radius: BorderRadius.circular(1.5.rem),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25), width: 1.px),
        textAlign: TextAlign.center,
        raw: {'background': 'radial-gradient(120% 140% at 50% 0%, ${AppColors.primary.withValues(alpha: 0.12).value} 0%, transparent 60%)'},
      ),
    ]),
    css('.cs-closing-title').styles(
      margin: Margin.zero,
      color: AppColors.textPrimary,
      fontFamily: FontFamily.list([AppFonts.heading, FontFamilies.monospace]),
      fontSize: Unit.expression('clamp(1.5rem, 3vw, 2.1rem)'),
    ),
    css('.cs-closing-text').styles(margin: Margin.zero, color: AppColors.textSecondary, maxWidth: Unit.expression('44ch'), lineHeight: Unit.expression('1.6')),
  ];
}
