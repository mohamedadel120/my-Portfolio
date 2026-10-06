import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import '../components/project_case_studies.dart';
import '../components/project_index_detail.dart';
import '../components/project_pinned_showcase.dart';
import '../components/project_showcase.dart';
import '../components/project_stage_showcase.dart';
import '../constants/projects_variant.dart';
import '../constants/theme.dart';
import '../data/experience_repository.dart';
import '../data/projects_repository.dart';

/// Proof strip (verifiable facts only) plus the scroll-driven phone-mockup
/// showcase (see components/project_showcase.dart for how that part works).
///
/// The strip replaces the old four-number "stats dashboard": its "Rating"
/// was a flat 4.8 that was not read from any data, and "Downloads" summed
/// free text. Every value here is derived from Firestore content the owner
/// controls, and a fact that cannot be derived is simply not rendered. In
/// particular a rating only appears once real `rating` values exist.
class ProjectsSection extends AsyncStatelessComponent {
  /// Which presentation to render. Defaults to [projectsVariant]; tests and
  /// previews can pass another one explicitly.
  final ProjectsVariant variant;

  const ProjectsSection({super.key, this.variant = projectsVariant});

  @override
  Future<Component> build(BuildContext context) async {
    final projects = await fetchProjects();
    final experiences = await fetchExperiences();
    final summary = computeProofSummary(projects, experiences);

    return section(id: 'projects', classes: 'projects', [
      h2(classes: 'section-title', [.text('Projects')]),
      ...proofStrip(summary),
      showcase(variant, [for (final p in projects) _toMap(p)]),
    ]);
  }

  /// The presentation for [variant]. Public so tests can render every one.
  static Component showcase(ProjectsVariant variant, List<Map<String, dynamic>> projects) {
    return switch (variant) {
      ProjectsVariant.v1 => StickyProjectShowcase(projects: projects),
      ProjectsVariant.caseStudy => ProjectCaseStudies(projects: projects),
      ProjectsVariant.indexDetail => ProjectIndexDetail(projects: projects),
      ProjectsVariant.refinedSticky => StickyProjectShowcase(projects: projects, refined: true),
      ProjectsVariant.stageShowcase => ProjectStageShowcase(projects: projects),
      ProjectsVariant.pinnedShowcase => ProjectPinnedShowcase(projects: projects),
    };
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
    'role': p.role,
    'problem': p.problem,
    'outcome': p.outcome,
    'featured': p.featured,
    'highlight': p.highlight,
  };

  @css
  static List<StyleRule> get styles => [
    css('.projects', [
      css('&').styles(padding: Padding.symmetric(horizontal: 3.75.rem, vertical: 6.25.rem)),
    ]),
    css('.proof-strip', [
      css('&').styles(
        display: Display.grid,
        margin: Margin.only(top: 3.rem, bottom: 3.75.rem),
        padding: Padding.symmetric(vertical: 1.5.rem),
        border: Border.only(
          top: BorderSide(color: AppColors.primary.withValues(alpha: 0.3), width: 1.px),
          bottom: BorderSide(color: AppColors.primary.withValues(alpha: 0.3), width: 1.px),
        ),
        raw: {
          'grid-template-columns': 'repeat(auto-fit, minmax(10rem, 1fr))',
          'gap': '1.5rem 2rem',
        },
      ),
    ]),
    css('.proof-item', [
      css('&').styles(display: Display.flex, flexDirection: FlexDirection.column, gap: Gap.all(0.35.rem), margin: Margin.zero),
      css('dt').styles(
        color: AppColors.textSecondary,
        fontFamily: FontFamily.list([FontFamily('JetBrains Mono'), FontFamilies.monospace]),
        fontSize: 0.8.rem,
      ),
      css('dd').styles(
        margin: Margin.zero,
        color: AppColors.textPrimary,
        fontFamily: FontFamily.list([FontFamily('JetBrains Mono'), FontFamilies.monospace]),
        fontSize: 1.25.rem,
        fontWeight: FontWeight.w600,
        raw: {'font-variant-numeric': 'tabular-nums'},
      ),
    ]),
  ];
}

/// One fact: a label and its value. Public so tests can render it.
class ProofFact {
  final String label;
  final String value;
  const ProofFact(this.label, this.value);
}

/// The facts that can honestly be shown for [summary], in display order.
List<ProofFact> proofFacts(ProofSummary summary) {
  String plural(int n, String word) => '$n $word${n == 1 ? '' : 's'}';
  final platforms = summary.platforms;
  return [
    if (summary.liveApps > 0) ProofFact('Live on the stores', plural(summary.liveApps, 'app')),
    if (platforms.isNotEmpty) ProofFact('Platforms', platforms.join(' and ')),
    if (summary.buildingSinceYear != null) ProofFact('Building since', '${summary.buildingSinceYear}'),
    if (summary.averageRating != null)
      ProofFact(
        'Average store rating',
        '${summary.averageRating!.toStringAsFixed(1)} across ${plural(summary.ratedApps, 'app')}',
      ),
  ];
}

/// Renders nothing (an empty list) when there is no fact to show.
List<Component> proofStrip(ProofSummary summary) {
  final facts = proofFacts(summary);
  if (facts.isEmpty) return const [];
  return [
    dl(classes: 'proof-strip reveal', [
      for (final fact in facts)
        div(classes: 'proof-item', [
          dt([.text(fact.label)]),
          dd([.text(fact.value)]),
        ]),
    ]),
  ];
}
