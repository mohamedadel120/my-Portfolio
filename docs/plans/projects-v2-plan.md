# Projects section v2: plan

Goal: the strongest possible presentation of the work for freelance clients and hiring companies, shipped with zero regressions. Production is the Jaspr site (`jaspr_site/`); every push to `main` deploys it live via `.github/workflows/deploy-firebase.yml`.

## 0. Safety net (done)

| Item | State |
| --- | --- |
| Baseline of the current look | git tag `baseline/projects-v1` at `9d9ec81` (what is live today) |
| Work branch | `redesign/projects-v2` (never commit to `main` directly) |
| Rollback | `git checkout baseline/projects-v1 -- jaspr_site/lib` restores the exact current Projects code; or revert the merge commit |
| Local preview | `jaspr serve` in `jaspr_site/` (http://localhost:8080), nothing leaves the machine |
| Production gate | no push, merge or deploy without an explicit "go" from the owner |

Experiment variants: each proposal lives on its own short branch off `redesign/projects-v2` (`exp/showcase-casestudy`, `exp/showcase-grid`, ...) so any can be dropped without touching the others.

## 1. Findings that must be fixed regardless of design

1. **Fabricated rating.** `computeProjectStats` (`jaspr_site/lib/data/projects_repository.dart`) shows "Rating 4.8" for any project whose `downloads` text contains `+` or `,`. It is not read from any data. On a portfolio shown to companies this is an unverifiable claim. Remove it, or replace it with a real per-project rating stored in Firestore.
2. **"Downloads" is a sum of free text** (`"10K+"`, `"1,000"`), digits stripped. `5K+` and `5,000` both become 5000 and units like `K` are lost. Needs a numeric field.
3. **No tests exist** in `jaspr_site/` (no `test/` folder).
4. Stats strip is a hero-metric template with gradient card, border and shadow.
5. Lints: 96 (`styles_ordering`, `sort_children_last`), cosmetic.

## 2. Dashboard: from decoration to evidence

Current: four generic numbers. Proposed (pick any):

- **A. Proof strip (recommended):** real, verifiable facts only: shipped apps (count, linked to stores), platforms (iOS / Android), years building with Flutter, latest release date. Each item links to its evidence.
- **B. Per-project facts:** drop the global strip; each case study carries its own role, stack, platform, store links, and a real number only when the owner supplies it.
- **C. Tech map:** the tech stacks as a filterable list (click a stack, projects filter), turning the "Tech Stacks 12" number into navigation.
- **D. Live data:** GitHub stats (public repos, last commit) fetched at build time. Real, but only if the GitHub profile is strong.

Rule: no number appears unless it comes from data the owner controls.

## 3. Projects presentation: candidates

| Variant | Idea | Best for |
| --- | --- | --- |
| V2-A Case study | Per project: problem, role, stack, outcome, store links, one large mockup | clients and companies |
| V2-B Index + detail | Compact list of all projects; selecting one opens its case study | many projects, fast scanning |
| V2-C Refined sticky | Keep the sticky phone, fix mobile/keyboard/reduced motion, add CTA | closest to today |

All variants: keyboard operable, no scroll hijack on touch, content survives any Firestore length, CTA "Build something like this" linking to #contact.

## 4. Quality gates (every variant, before it can be merged)

Automated (`dart test`, `dart analyze`):
- Unit: repository parsing (missing/typed-wrong fields, empty collection, color formats), stats computation.
- Component render: SSR output contains every project title, description, store link; no empty `alt`; heading order.
- `jaspr build` succeeds and the static HTML for `/` and `/projects` contains the content with JavaScript disabled.

Browser (local, via the preview pane):
- Viewports 375, 768, 1024, 1440 and 1920; light and dark theme; no horizontal scroll; no layout shift.
- Keyboard-only path through the section; visible focus; `prefers-reduced-motion` honoured.
- Console clean (no errors, no 404s); images have dimensions and lazy loading below the fold.
- Content stress: 0, 1, 2 and 12 projects; 200-character titles; missing images/videos/store links.

Performance and a11y: Lighthouse (performance >= 90, accessibility = 100, SEO = 100) and an axe pass.

## 5. Release path

1. Local review of each variant by the owner (screens at all viewports).
2. Owner picks a winner; the others stay as branches.
3. Open a PR to `main`. Add a PR preview deploy (Firebase Hosting preview channel, expires automatically) so the exact build is viewable on a temporary URL before merge. This needs a new workflow file and the existing Firebase secret; proposed, not added.
4. Merge only after the owner approves the preview. Merge deploys live; rollback is reverting the merge commit or redeploying tag `baseline/projects-v1`.

## 6. Order of work

1. Data and tests foundation (fix findings 1-3, add `test/`).
2. Dashboard decision (section 2).
3. Build V2-A, V2-B, V2-C on separate branches, each passing section 4.
4. Side-by-side local review, then PR and preview.
