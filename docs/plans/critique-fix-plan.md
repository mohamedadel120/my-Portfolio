# Fix plan: the critique of 21 Oct 2026

Source: `.impeccable/critique/2026-10-21T13-11-54Z__jaspr-site.md` (site 20/32, dashboard 24/40).
One problem per step, one commit per step, each checked before the next one starts.
Site work on branch `v3/preview`; dashboard work on a new branch in `portfolio-dashboard`.

Status: ⬜ not started · 🔄 in progress · ✅ done · ⏸ waiting for the owner

## P0 (live now)

| # | Step | Where | Needs the owner | Status |
|---|------|-------|-----------------|--------|
| 1 | Remove the placeholder testimonial "Jane Doe" and stop showing 5 stars on every testimonial | Firestore `testimonials/UmxyO4OVxxDgshuyrNOS`; `testimonials_section.dart:34-46` | Yes: OK to delete; stars or not | ⏸ |

## P1 (before publishing v3)

| # | Step | Where | Needs the owner | Status |
|---|------|-------|-----------------|--------|
| 2 | Content never hidden without JavaScript: `.reveal` hides only once the script has started; reduced motion shows it at once | `theme.dart` reveal rules, `scroll_reveal.web.dart` | No | ✅ |
| 3 | Hero entrance animations respect reduced motion | `hero_section.dart` | No | ✅ |
| 4 | A project with no screenshots (and a phone still loading) shows an intentional placeholder in the app's colour, not a black screen | `project_pinned_showcase.dart`, `shot_gallery.dart` | No | ⬜ |
| 5 | Replace the per-character retyping on every project change with a short crossfade | `project_pinned_showcase.dart` | No | ⬜ |
| 6 | Dashboard: "Discard changes?" before closing a changed form; Profile's Save always visible | dashboard dialogs, `profile_info_page.dart` | No | ⬜ |
| 7 | Dashboard: usable under 1000 px (sidebar becomes a rail/drawer; cards size to their content) | `dashboard_layout.dart`, `projects_page.dart` | No | ⬜ |

## P2

| # | Step | Where | Needs the owner | Status |
|---|------|-------|-----------------|--------|
| 8 | Showcase: shorter scroll per project, description clamped with a link, at most ~6 tags + "+N", `dir="auto"` for Arabic, no inner scroller hiding the CTAs | `project_pinned_showcase.dart` | No | ⬜ |
| 9 | Case studies: "My role" and "The outcome" filled, role line under the title, first image not cropped | Firestore + `project_case_study.dart` | Yes: the role/outcome text | ⏸ |
| 10 | Lower half of the page in the direction c voice (titles, copy, contact, footer) | sections below Projects | Yes: redesign or polish | ⏸ |
| 11 | Dashboard accessibility: semantics on, labelled icon buttons, keyboard reaches sidebar and actions | dashboard | No | ⬜ |
| 12 | Touch targets 44 px on phones (gallery arrows/dots, case study link, "All projects"); store tooltip readable and on screen | site components | No | ⬜ |

## P3 (one batch at the end)

Header blur while scrolling; no skipped heading levels on /projects, /about, /contact; no `transition: width`;
`.gal-viewport` gets a role; dashboard chart without overshoot; one style for edit/delete buttons;
"enterprise-grade scalability" in `profile_repository.dart:88`.

After all steps: re-run the critique and compare the scores.
