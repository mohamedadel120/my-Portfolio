import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import '../components/project_showcase.dart';
import '../constants/theme.dart';
import '../data/projects_repository.dart';

/// Ported from `ProjectsDesktopView` — stats dashboard plus the scroll-driven
/// phone-mockup showcase (see components/project_showcase.dart for how that
/// part works). Decorative-only elements from the original (floating code
/// shapes, terminal window, background tech grid) are dropped rather than
/// ported — pure decoration with no content, consistent with dropping the
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
      StickyProjectShowcase(projects: [for (final p in projects) _toMap(p)]),
    ]);
  }

  Component _statItem(String icon, String value, String label) {
    return div(classes: 'stat-item', [
      span(classes: 'material-symbols-rounded stat-icon', [.text(icon)]),
      span(classes: 'stat-value', [.text(value)]),
      span(classes: 'stat-label', [.text(label)]),
    ]);
  }

  Map<String, dynamic> _toMap(ProjectItem p) => {
    'title': p.title,
    'description': p.description,
    'tech': p.tech,
    'color': p.color,
    'downloads': p.downloads,
    'galleryImages': p.galleryImages,
    'androidStoreUrl': p.androidStoreUrl,
    'iosStoreUrl': p.iosStoreUrl,
    'videoUrl': p.videoUrl,
  };

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
        margin: Margin.only(top: 3.75.rem, bottom: 3.75.rem),
        padding: Padding.all(1.75.rem),
        radius: BorderRadius.circular(1.5.rem),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1.5.px),
        raw: {
          'background': 'linear-gradient(135deg, ${AppColors.primary.withValues(alpha: 0.15).value}, '
              '${AppColors.secondary.withValues(alpha: 0.1).value} 50%, ${AppColors.surface.withValues(alpha: 0.9).value})',
        },
      ),
      // Plain flex with no wrap squeezed all 4 columns into one row
      // regardless of width, so on narrow viewports the numbers/labels ran
      // into each other instead of shrinking gracefully.
      css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile.px), [
        css('&').styles(
          flexWrap: FlexWrap.wrap,
          justifyContent: JustifyContent.center,
          gap: Gap.all(1.75.rem),
        ),
      ]),
    ]),
    css('.stat-divider', [
      css('&').styles(width: 1.px, height: 3.rem, backgroundColor: AppColors.primary.withValues(alpha: 0.3)),
      // Vertical dividers between columns don't make sense once the layout
      // wraps into a grid instead of a single row.
      css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile.px), [
        css('&').styles(display: Display.none),
      ]),
    ]),
    css('.stat-item', [
      css('&').styles(display: Display.flex, flexDirection: FlexDirection.column, alignItems: AlignItems.center, gap: Gap.all(0.4.rem)),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile.px), [
        // Two clean columns instead of whatever widths 4 unconstrained
        // flex items happen to wrap into.
        css('&').styles(raw: {'flex': '0 0 calc(50% - 0.875rem)'}),
      ]),
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
  ];
}
