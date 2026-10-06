/// Which presentation the Projects section uses. Every variant renders the
/// same Firestore data. `v1` is the design that is live today and is the
/// safe default: the exact original lives on git tag `baseline/projects-v1`.
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
/// `.claude/launch.json`). Without it, or with an unknown name, the original
/// design is used, so a production build can never pick a variant by accident.
const _requested = String.fromEnvironment('PROJECTS_VARIANT');

const projectsVariant = _requested == 'caseStudy'
    ? ProjectsVariant.caseStudy
    : _requested == 'indexDetail'
        ? ProjectsVariant.indexDetail
        : _requested == 'refinedSticky'
            ? ProjectsVariant.refinedSticky
            : _requested == 'stageShowcase'
                ? ProjectsVariant.stageShowcase
                : _requested == 'pinnedShowcase'
                    ? ProjectsVariant.pinnedShowcase
                    : ProjectsVariant.v1;
