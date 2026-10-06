/// Which presentation the Projects section uses. Switching is a one-line
/// change to [projectsVariant]; every variant renders the same Firestore
/// data. `v1` is the design that is live today and is the safe default: the
/// exact original lives on git tag `baseline/projects-v1`.
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
}

const projectsVariant = ProjectsVariant.v1;
