# Projects v2: review guide

The chosen design is the **pinned showcase**: the Projects section stays on screen and each step of
scroll switches to the next project in place. The phone plays that project's screenshots like a
short video (tap the screen to pause, tap again to play), the title and description are typed, and
the arrows beside the phone step through screenshots. Phones get stacked cards with a manual
gallery; tablets and windows from 768px wide keep the pinned stage.

The other candidates (case study, index + detail, refined sticky, stage showcase, stories) were
removed after review; they remain in git history. The original design is still one switch away.

## See it

Use the launch configurations in `.claude/launch.json` (one at a time; they share port 8080):

| Configuration | What it shows |
| --- | --- |
| `portfolio` | The chosen design with the live Firestore data |
| `portfolio-preview-data` | The same with the Firestore corrections applied locally (see `firestore-corrections.md`) |
| `portfolio-v1-original` | The original design |

From a terminal: `cd jaspr_site && dart pub global run jaspr_cli:jaspr serve`.

## Content fields (Firestore `projects`)

| Field | Type | Effect |
| --- | --- | --- |
| `featured` | boolean | Listed first, "Featured project" badge, star in the project list |
| `highlight` | string | One headline line after the title, in the app's colour |
| `rating` | number 0 to 5 | Enables "Average store rating" in the proof strip (hidden until real ratings exist) |
| `role`, `problem`, `outcome` | string | Stored for case studies; not shown in the pinned design yet |

## Fixed along the way

- Horizontal scrolling on phones; fabricated "4.8" ratings removed from the Projects strip and About.
- Proof strip of verifiable facts instead of the old stats dashboard.
- Page language declared; experience dates readable (contrast 9.5:1).
- Media paths stored relative to the site root now also load on `/projects`.

## Tests

```bash
cd jaspr_site && dart test      # 54 tests
cd .. && flutter test           # Flutter app
```

## Roll back

- Projects section to the original: run with `--dart-define=PROJECTS_VARIANT=v1`, or set the
  default in `jaspr_site/lib/constants/projects_variant.dart`.
- Code exactly as before this work: git tag `baseline/projects-v1`.
