# Projects v2: review guide

Everything here is local. Nothing is pushed, merged or deployed. Production still runs the original design: the default is `ProjectsVariant.v1` and a test enforces it.

## See it

```bash
cd jaspr_site
dart pub global run jaspr_cli:jaspr serve
```

Open http://localhost:8080 and scroll to Projects. To switch design, change one line in
`jaspr_site/lib/constants/projects_variant.dart`:

```dart
const projectsVariant = ProjectsVariant.caseStudy; // v1 | caseStudy | indexDetail | refinedSticky
```

The page hot-reloads. Put it back to `v1` before committing anything you intend to ship.

## The variants

| Value | Name | What it is | JS needed |
| --- | --- | --- | --- |
| `v1` | Original | Exactly what is live today | yes |
| `caseStudy` | V2-A | One section per project: big screenshot strip, description, tech, store links, "Build something like this" | no |
| `indexDetail` | V2-B | List of all projects on the left, detail panel on the right, thumbnails to switch screenshots | for switching |
| `refinedSticky` | V2-C | The original showcase, ~42% less scrolling (71k px to 41k px), reduced-motion support, keyboard focus and ARIA labels, contact button | yes |

Optional case-study fields you can add to a project document in Firestore (shown only when present, never invented): `role`, `problem`, `outcome`. A numeric `rating` (0 to 5) makes "Average store rating" appear in the proof strip.

## Fixed along the way (all variants)

- Horizontal scrolling on phones (page was 452px wide on a 375px screen).
- Removed the fabricated "Rating 4.8" (Projects strip and About section).
- Dashboard replaced by a proof strip of facts derived from your data.

## Things only you can decide

1. Project description text for Stock says "4.8-star ratings" and "10,000+ downloads"; that is your Firestore text, left untouched.
2. About section still shows the "10k+" download fallback and the skill percentages (hardcoded defaults in `profile_repository.dart`).
3. 8 projects exist in Firestore but "Live on the stores" counts 6 (only those with a store link).

## Tests

```bash
cd jaspr_site && dart test      # 37 tests
cd .. && flutter test           # Flutter app
```

## Roll back

- Whole project to how it was: `git checkout baseline/projects-v1 -- jaspr_site/lib`
- One variant only: set `projectsVariant` back to `v1`.
