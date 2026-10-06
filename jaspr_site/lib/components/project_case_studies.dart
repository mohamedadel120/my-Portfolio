import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import 'project_view.dart';
import 'shot_strip.dart';

/// V2-A: one case study per project, rendered entirely on the server (plain
/// HTML + CSS, no client JavaScript), so every title, description, link and
/// screenshot is in the page source for search engines and works with
/// JavaScript disabled.
///
/// Content comes only from Firestore. The optional `role`, `problem` and
/// `outcome` fields are shown when the owner has written them and omitted
/// otherwise; nothing here invents copy.
class ProjectCaseStudies extends StatelessComponent {
  final List<Map<String, dynamic>> projects;

  const ProjectCaseStudies({super.key, required this.projects});

  @override
  Component build(BuildContext context) {
    if (projects.isEmpty) return div([]);
    return div(classes: 'cs-list', [
      for (final (i, project) in projects.indexed) _article(project, i),
    ]);
  }

  Component _article(Map<String, dynamic> project, int index) {
    final view = ProjectView.fromMap(project);
    final title = view.title;
    final description = view.description;
    final tech = view.tech;
    final images = view.images;
    final videoUrl = view.videoUrl;
    final androidUrl = view.androidUrl;
    final iosUrl = view.iosUrl;
    final downloads = view.downloads;
    final facts = view.facts;
    final headingId = 'cs-title-$index';

    return article(
      classes: 'cs-item',
      attributes: {'aria-labelledby': headingId},
      styles: Styles(raw: {'--accent': view.accentHex}),
      [
        header(classes: 'cs-head', [
          h3(id: headingId, classes: 'cs-title', [.text(title)]),
          if (downloads.isNotEmpty) p(classes: 'cs-downloads', [.text(downloads)]),
        ]),
        if (videoUrl != null)
          video(
            classes: 'cs-video',
            src: videoUrl,
            controls: true,
            muted: true,
            attributes: const {'playsinline': '', 'preload': 'none', 'aria-label': 'Video preview'},
            [],
          ),
        if (images.isNotEmpty) ShotStrip(id: 'cs-strip-$index', title: title, images: images, eagerFirst: index == 0),
        div(classes: 'cs-body', [
          div(classes: 'cs-story', [
            p(classes: 'cs-description', [.text(description)]),
            if (facts.isNotEmpty)
              dl(classes: 'cs-facts', [
                for (final (label, value) in facts)
                  div([
                    dt([.text(label)]),
                    dd([.text(value)]),
                  ]),
              ]),
          ]),
          div(classes: 'cs-side', [
            if (tech.isNotEmpty)
              ul(classes: 'cs-tech', attributes: {'aria-label': 'Technologies'}, [
                for (final item in tech) li([.text(item)]),
              ]),
            div(classes: 'cs-links', [
              if (androidUrl != null)
                a(
                  href: androidUrl,
                  classes: 'cs-link',
                  target: Target.blank,
                  attributes: {'rel': 'noopener', 'aria-label': 'Get $title on Google Play (opens in a new tab)'},
                  [.text('Google Play')],
                ),
              if (iosUrl != null)
                a(
                  href: iosUrl,
                  classes: 'cs-link',
                  target: Target.blank,
                  attributes: {'rel': 'noopener', 'aria-label': 'Get $title on the App Store (opens in a new tab)'},
                  [.text('App Store')],
                ),
              if (androidUrl == null && iosUrl == null) span(classes: 'cs-soon', [.text('Coming soon')]),
              a(href: '#contact', classes: 'cs-cta', [.text('Build something like this')]),
            ]),
          ]),
        ]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.cs-list', [
      css('&').styles(display: Display.flex, flexDirection: FlexDirection.column, gap: Gap.all(5.rem)),
    ]),
    css('.cs-item', [
      css('&').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        gap: Gap.all(1.75.rem),
        padding: Padding.only(top: 2.5.rem),
        border: Border.only(top: BorderSide.solid(color: Color.variable('--accent'), width: 2.px)),
      ),
    ]),
    css('.cs-head', [
      css('&').styles(display: Display.flex, flexWrap: FlexWrap.wrap, alignItems: AlignItems.baseline, gap: Gap(row: 0.5.rem, column: 1.5.rem)),
    ]),
    css('.cs-title', [
      css('&').styles(
        color: AppColors.textPrimary,
        fontSize: Unit.expression('clamp(1.75rem, 4vw, 2.75rem)'),
        lineHeight: Unit.expression('1.15'),
      ),
    ]),
    css('.cs-downloads', [
      css('&').styles(
        margin: Margin.zero,
        color: AppColors.textSecondary,
        fontSize: 0.9.rem,
      ),
    ]),
    css('.cs-video', [
      css('&').styles(
        width: 100.percent,
        maxWidth: 52.rem,
        radius: BorderRadius.circular(0.75.rem),
        backgroundColor: AppColors.surface,
      ),
    ]),
    css('.cs-body', [
      css('&').styles(
        display: Display.grid,
        gap: Gap.all(2.rem),
        raw: {'grid-template-columns': 'minmax(0, 1.6fr) minmax(0, 1fr)'},
      ),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.tablet.px), [
        css('&').styles(raw: {'grid-template-columns': 'minmax(0, 1fr)'}),
      ]),
    ]),
    css('.cs-description', [
      css('&').styles(
        margin: Margin.zero,
        color: AppColors.textSecondary,
        fontSize: 1.05.rem,
        lineHeight: Unit.expression('1.75'),
        maxWidth: Unit.expression('65ch'),
      ),
    ]),
    css('.cs-facts', [
      css('&').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        gap: Gap.all(1.rem),
        margin: Margin.only(top: 1.5.rem),
      ),
      css('dt').styles(color: AppColors.textTertiary, fontSize: 0.8.rem),
      css('dd').styles(margin: Margin.only(top: 0.25.rem), color: AppColors.textPrimary, maxWidth: Unit.expression('65ch'), lineHeight: Unit.expression('1.6')),
    ]),
    css('.cs-side', [
      css('&').styles(display: Display.flex, flexDirection: FlexDirection.column, gap: Gap.all(1.5.rem)),
    ]),
    css('.cs-tech', [
      css('&').styles(
        display: Display.flex,
        flexWrap: FlexWrap.wrap,
        gap: Gap.all(0.5.rem),
        margin: Margin.zero,
        padding: Padding.zero,
        raw: {'list-style': 'none'},
      ),
      css('li').styles(
        padding: Padding.symmetric(horizontal: 0.75.rem, vertical: 0.35.rem),
        radius: BorderRadius.circular(0.5.rem),
        border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.18), width: 1.px),
        color: AppColors.textPrimary,
        fontSize: 0.8.rem,
      ),
    ]),
    css('.cs-links', [
      css('&').styles(display: Display.flex, flexWrap: FlexWrap.wrap, alignItems: AlignItems.center, gap: Gap.all(0.75.rem)),
    ]),
    css('.cs-link, .cs-cta', [
      css('&').styles(
        display: Display.inlineFlex,
        alignItems: AlignItems.center,
        minHeight: 2.75.rem,
        padding: Padding.symmetric(horizontal: 1.1.rem),
        radius: BorderRadius.circular(0.5.rem),
        textDecoration: TextDecoration.none,
        fontSize: 0.9.rem,
        fontWeight: FontWeight.w600,
        raw: {'transition': 'transform 160ms cubic-bezier(0.23, 1, 0.32, 1), background-color 160ms ease'},
      ),
      css('&:active').styles(transform: Transform.scale(0.97)),
      css('&:focus-visible').styles(raw: {'outline': '2px solid ${AppColors.primary.value}', 'outline-offset': '3px'}),
    ]),
    css('.cs-link', [
      css('&').styles(
        color: AppColors.textPrimary,
        border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.3), width: 1.px),
      ),
    ]),
    css('.cs-cta', [
      css('&').styles(backgroundColor: AppColors.primary, color: AppColors.background),
    ]),
    css('.cs-soon', [
      css('&').styles(color: AppColors.textSecondary, fontSize: 0.9.rem),
    ]),
  ];
}
