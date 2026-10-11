/// Which presentation the Projects section uses. Both render the same
/// Firestore data. `pinnedShowcase` is the chosen design and the default;
/// `v1` is the original, kept as a fallback and exactly on git tag
/// `baseline/projects-v1`.
enum ProjectsVariant {
  /// Original scroll-driven phone showcase, unchanged.
  v1,

  /// The section stays pinned; scrolling switches project in place (the phone
  /// plays the screenshots like a video, the text is typed).
  pinnedShowcase,
}

/// Chosen at launch with `--dart-define=PROJECTS_VARIANT=v1` to bring the
/// original back (see `.claude/launch.json`). Without it the chosen design is
/// used.
const _requested = String.fromEnvironment('PROJECTS_VARIANT');

const projectsVariant = _requested == 'v1' ? ProjectsVariant.v1 : ProjectsVariant.pinnedShowcase;
