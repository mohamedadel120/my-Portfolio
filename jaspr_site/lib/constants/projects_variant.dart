/// Which presentation the Projects section uses. Every variant renders the
/// same Firestore data. `pinnedShowcase` (V2-E) is the chosen design and the
/// default; `v1` is the original, kept exactly on git tag
/// `baseline/projects-v1`.
enum ProjectsVariant {
  /// Original scroll-driven phone showcase, unchanged.
  v1,

  /// V2-A: one server-rendered case study per project.
  caseStudy,

  /// V2-B: project index with a detail panel.
  indexDetail,

  /// V2-C: the original sticky showcase with shorter scroll, reduced-motion
  /// support, keyboard/ARIA fixes and a contact call to action.
  refinedSticky,

  /// V2-D: one screen per project, stacked sticky stages, screenshot gallery.
  stageShowcase,

  /// V2-E: the section stays pinned; scrolling switches project in place
  /// (phone plays the screenshots like a video, text is typed).
  pinnedShowcase,
}

/// Chosen at launch with `--dart-define=PROJECTS_VARIANT=<name>` (see
/// `.claude/launch.json`). Without it, or with an unknown name, the chosen
/// design (V2-E, the pinned showcase) is used. The original stays reachable
/// with `PROJECTS_VARIANT=v1`, and exactly as shipped on git tag
/// `baseline/projects-v1`.
const _requested = String.fromEnvironment('PROJECTS_VARIANT');

const projectsVariant = _requested == 'v1'
    ? ProjectsVariant.v1
    : _requested == 'caseStudy'
        ? ProjectsVariant.caseStudy
        : _requested == 'indexDetail'
            ? ProjectsVariant.indexDetail
            : _requested == 'refinedSticky'
                ? ProjectsVariant.refinedSticky
                : _requested == 'stageShowcase'
                    ? ProjectsVariant.stageShowcase
                    : ProjectsVariant.pinnedShowcase;
