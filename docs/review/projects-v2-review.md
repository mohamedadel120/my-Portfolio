# Projects v2: review guide

Everything here is local. Nothing is pushed, merged or deployed. Production still runs the original design: the default is `ProjectsVariant.v1` and a test enforces it.

## See it

Use the launch configurations in `.claude/launch.json` (the preview pane lists them). Only one can run at a time because they share port 8080 and one build daemon; stop the running one before starting another, then wait about 30 seconds for the page to build.

| Configuration | Design |
| --- | --- |
| `portfolio-v1-original` | Original, exactly what is live |
| `portfolio-A-case-study` | V2-A |
| `portfolio-B-index-detail` | V2-B |
| `portfolio-C-refined-sticky` | V2-C |
| `portfolio-D-stage-showcase` | V2-D |
| `portfolio-E-pinned-showcase` | V2-E |

From a terminal instead:

```bash
cd jaspr_site
dart pub global run jaspr_cli:jaspr serve --dart-define=PROJECTS_VARIANT=pinnedShowcase
# values: caseStudy | indexDetail | refinedSticky | stageShowcase | pinnedShowcase (omit for the original)
```

A build without the define always produces the original design.

## The variants

| Name | What it is |
| --- | --- |
| V2-A `caseStudy` | One section per project, server-rendered. Screenshots in a phone mockup gallery (arrows, dots or a slider, swipe, keyboard) |
| V2-B `indexDetail` | List of projects on the left, detail panel on the right, thumbnails to switch screenshots |
| V2-C `refinedSticky` | The original scroll-driven showcase with about 42% less scrolling, reduced-motion support, ARIA labels and a contact button |
| V2-D `stageShowcase` | One screen per project (about 10 screens for 8 projects instead of 79). Screenshots browsed with the phone gallery. All text in the HTML |
| V2-E `pinnedShowcase` | The section stays pinned. Scrolling switches project in place: the phone cross-fades to the next project and its screenshots play like a video (pause, previous, next, progress), title and description are typed. About 8 screens. Phones and tablets get stacked cards |

Optional case-study fields you can add to a project document in Firestore (shown only when present, never invented): `role`, `problem`, `outcome`. A numeric `rating` (0 to 5) makes "Average store rating" appear in the proof strip.

Emphasis fields (A, B, D and E; the original v1 and C only get the reordering):

| Field | Type | Effect |
| --- | --- | --- |
| `featured` | boolean (`true`) | The project is listed first and shows a "Featured" label. Several featured projects keep their relative order. |
| `highlight` | string | One short headline claim shown right after the title, before the description. Works with or without `featured`. |

Add them in the Firebase console on the project document. `featured` must be a boolean, not the text "true".

## Fixed along the way (all variants)

- Horizontal scrolling on phones (page was 452px wide on a 375px screen).
- Removed the fabricated "Rating 4.8" (Projects strip and About section).
- Dashboard replaced by a proof strip of facts derived from your data.
- Default browser scrollbars replaced by a thin themed one.

## Things only you can decide

1. Project description text for Stock says "4.8-star ratings" and "10,000+ downloads"; that is your Firestore text, left untouched.
2. About section still shows the "10k+" download fallback and the skill percentages (hardcoded defaults in `profile_repository.dart`).
3. 8 projects exist in Firestore but "Live on the stores" counts 6 (only those with a store link).

## Tests

```bash
cd jaspr_site && dart test      # 76 tests
cd .. && flutter test           # Flutter app
```

## Roll back

- Whole project to how it was: `git checkout baseline/projects-v1 -- jaspr_site/lib`
- One variant only: stop using its launch configuration; the default is the original.
