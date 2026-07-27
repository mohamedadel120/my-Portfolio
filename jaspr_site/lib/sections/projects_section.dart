import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import '../constants/theme.dart';
import '../data/projects_repository.dart';

/// Ported from `ProjectsDesktopView`/`StickyProjectShowcase`. The original
/// is a scroll-driven "phone mockup" carousel with a stats dashboard —
/// there's no Jaspr/HTML equivalent of that scroll-linked interaction (see
/// the migration plan's Phase 3 note), so this is a CSS-grid card layout
/// instead: same data (stats, tech chips, store/demo links, gallery
/// images), read as plain markup rather than driven by scroll position.
/// Decorative-only elements from the original (floating code shapes,
/// terminal window, background tech grid) are dropped rather than ported —
/// pure decoration with no content, consistent with dropping the
/// always-on background animations elsewhere in this migration.
class ProjectsSection extends AsyncStatelessComponent {
  const ProjectsSection({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final projects = await fetchProjects();
    final stats = computeProjectStats(projects);

    return section(id: 'projects', classes: 'projects', [
      h2(classes: 'section-title', [.text('Projects')]),
      div(classes: 'stats-dashboard reveal', [
        _statItem('apps', stats.totalProjects.toString(), 'Projects'),
        div(classes: 'stat-divider', []),
        _statItem('download', '${(stats.totalDownloads / 1000).round()}K+', 'Downloads'),
        div(classes: 'stat-divider', []),
        _statItem('star', stats.averageRating.toStringAsFixed(1), 'Rating'),
        div(classes: 'stat-divider', []),
        _statItem('code', stats.techStacks.toString(), 'Tech Stacks'),
      ]),
      div(classes: 'project-grid', [
        for (final (i, project) in projects.indexed) _projectCard(project, i),
      ]),
    ]);
  }

  Component _statItem(String icon, String value, String label) {
    return div(classes: 'stat-item', [
      span(classes: 'material-symbols-rounded stat-icon', [.text(icon)]),
      span(classes: 'stat-value', [.text(value)]),
      span(classes: 'stat-label', [.text(label)]),
    ]);
  }

  Component _projectCard(ProjectItem project, int index) {
    final accent = Color.value(project.color & 0xFFFFFF);
    final thumbnail = project.logoUrl ?? project.galleryImages?.firstOrNull ?? project.imageUrl;

    return div(
      classes: 'project-card reveal',
      styles: Styles(raw: {'--accent': accent.value, 'transition-delay': '${index * 80}ms'}),
      [
        if (thumbnail != null) img(src: thumbnail, alt: project.title, classes: 'project-thumb'),
        div(classes: 'project-body', [
          h3(classes: 'project-title', [.text(project.title)]),
          p(classes: 'project-description', [.text(project.description)]),
          div(classes: 'project-tech', [
            for (final tech in project.tech) span(classes: 'tech-chip', [.text(tech)]),
          ]),
          div(classes: 'project-footer', [
            span(classes: 'project-downloads', [.text(project.downloads)]),
            div(classes: 'project-links', [
              if (project.androidStoreUrl != null)
                a(href: project.androidStoreUrl!, classes: 'project-link', [.text('Android')]),
              if (project.iosStoreUrl != null) a(href: project.iosStoreUrl!, classes: 'project-link', [.text('iOS')]),
            ]),
          ]),
          if (project.videoUrl != null)
            video(src: project.videoUrl!, controls: true, classes: 'project-video', []),
        ]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.projects', [
      css('&').styles(padding: Padding.symmetric(horizontal: 3.75.rem, vertical: 6.25.rem)),
    ]),
    css('.stats-dashboard', [
      css('&').styles(
        display: Display.flex,
        justifyContent: JustifyContent.spaceAround,
        alignItems: AlignItems.center,
        margin: Margin.only(top: 3.75.rem),
        padding: Padding.all(1.75.rem),
        radius: BorderRadius.circular(1.5.rem),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1.5.px),
        raw: {
          'background': 'linear-gradient(135deg, ${AppColors.primary.withValues(alpha: 0.15).value}, '
              '${AppColors.secondary.withValues(alpha: 0.1).value} 50%, ${AppColors.surface.withValues(alpha: 0.9).value})',
        },
      ),
    ]),
    css('.stat-divider', [
      css('&').styles(width: 1.px, height: 3.rem, backgroundColor: AppColors.primary.withValues(alpha: 0.3)),
    ]),
    css('.stat-item', [
      css('&').styles(display: Display.flex, flexDirection: FlexDirection.column, alignItems: AlignItems.center, gap: Gap.all(0.4.rem)),
      css('.stat-icon').styles(
        color: AppColors.primary,
        fontSize: 1.75.rem,
        padding: Padding.all(0.6.rem),
        radius: BorderRadius.circular(0.75.rem),
        backgroundColor: AppColors.primary.withValues(alpha: 0.15),
      ),
      css('.stat-value').styles(
        color: AppColors.textPrimary,
        fontFamily: FontFamily.list([FontFamily('JetBrains Mono'), FontFamilies.monospace]),
        fontSize: 1.75.rem,
        fontWeight: FontWeight.w700,
      ),
      css('.stat-label').styles(
        color: AppColors.textSecondary,
        fontFamily: FontFamily.list([FontFamily('JetBrains Mono'), FontFamilies.monospace]),
        fontSize: 0.8.rem,
      ),
    ]),
    css('.project-grid', [
      css('&').styles(
        display: Display.grid,
        gridTemplate: GridTemplate(
          columns: GridTracks([
            GridTrack.repeat(TrackRepeat.autoFit, [GridTrack(TrackSize.minmax(TrackSize(20.rem), TrackSize.fr(1)))]),
          ]),
        ),
        gap: Gap.all(2.rem),
        margin: Margin.only(top: 4.rem),
      ),
    ]),
    css('.project-card', [
      css('&').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        overflow: Overflow.hidden,
        backgroundColor: AppColors.surface,
        radius: BorderRadius.circular(1.25.rem),
        border: Border.all(color: Color.variable('--accent').withValues(alpha: 0.3), width: 1.5.px),
        transition: Transition('transform', duration: 200.ms),
      ),
      css('&:hover').styles(transform: Transform.translate(y: (-4).px)),
    ]),
    css('.project-thumb', [
      css('&').styles(width: 100.percent, height: 12.rem, raw: {'object-fit': 'cover'}),
    ]),
    css('.project-body', [
      css('&').styles(display: Display.flex, flexDirection: FlexDirection.column, gap: Gap.all(0.9.rem), padding: Padding.all(1.5.rem)),
    ]),
    css('.project-title', [
      css('&').styles(
        color: Color.variable('--accent'),
        fontFamily: FontFamily.list([FontFamily('JetBrains Mono'), FontFamilies.monospace]),
        fontSize: 1.4.rem,
        fontWeight: FontWeight.w700,
      ),
    ]),
    css('.project-description', [
      css('&').styles(
        color: AppColors.textSecondary,
        fontFamily: FontFamily.list([FontFamily('JetBrains Mono'), FontFamilies.monospace]),
        fontSize: 0.9.rem,
        lineHeight: Unit.expression('1.6'),
      ),
    ]),
    css('.project-tech', [
      css('&').styles(display: Display.flex, flexWrap: FlexWrap.wrap, gap: Gap.all(0.5.rem)),
      css('.tech-chip').styles(
        color: AppColors.textSecondary,
        fontFamily: FontFamily.list([FontFamily('Space Mono'), FontFamilies.monospace]),
        fontSize: 0.7.rem,
        padding: Padding.symmetric(horizontal: 0.6.rem, vertical: 0.3.rem),
        radius: BorderRadius.circular(0.5.rem),
        backgroundColor: Colors.white.withValues(alpha: 0.06),
      ),
    ]),
    css('.project-footer', [
      css('&').styles(display: Display.flex, justifyContent: JustifyContent.spaceBetween, alignItems: AlignItems.center),
      css('.project-downloads').styles(
        color: AppColors.textTertiary,
        fontFamily: FontFamily.list([FontFamily('JetBrains Mono'), FontFamilies.monospace]),
        fontSize: 0.8.rem,
      ),
    ]),
    css('.project-links', [
      css('&').styles(display: Display.flex, gap: Gap.all(1.rem)),
      css('a').styles(
        color: Color.variable('--accent'),
        textDecoration: TextDecoration.none,
        fontFamily: FontFamily.list([FontFamily('JetBrains Mono'), FontFamilies.monospace]),
        fontSize: 0.8.rem,
        fontWeight: FontWeight.w600,
      ),
      css('a:hover').styles(textDecoration: TextDecoration(line: TextDecorationLine.underline)),
    ]),
    css('.project-video', [
      css('&').styles(width: 100.percent, radius: BorderRadius.circular(0.75.rem)),
    ]),
  ];
}
