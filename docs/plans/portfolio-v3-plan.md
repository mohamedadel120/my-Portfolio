# Portfolio v3: improvement plan

Written 14 Oct 2026, after the projects redesign (PR #15) went live. Goal: a portfolio that, within
seconds, tells a company or a client what Mohamed builds and proves it with real apps.

How every phase is delivered:

- One branch and one pull request per phase. Each PR gets a Firebase preview link automatically,
  so every change is seen live before it reaches the real site.
- Nothing is merged to `main` (which deploys) without the owner's go.
- A git tag before each merge, so any phase can be rolled back.
- Only confirmed facts on the site: no number, rating or claim the owner has not confirmed.
- Tests for every new behaviour; Lighthouse on every phase that touches the look or loading.

---

## Phase 0: urgent fixes (same day)

| # | Fix | Why | Who |
|---|-----|-----|-----|
| 0.1 | Contact shows "Cairo, Egypt" instead of the full street address | The home address is public on the site | Claude edits Firestore after the owner's OK |
| 0.2 | Merge the case study pages (`feature/project-pages`) | Done and tested, waiting for review | Owner opens the PR and merges |

## Phase 1: content (the owner's input; everything else builds on it)

The site's code is ahead of its content. This phase collects what only the owner knows.

1. **The missing apps.** For each one:
   - name, store links (Google Play / App Store), status (live, coming soon, internal)
   - 4 to 8 screenshots (Claude converts them to WebP and sizes them)
   - the app's colour (or Claude picks it from the logo)
   - one sentence: what the app does and for whom
2. **The story of the 4 or 5 strongest apps** (about 3 short sentences each, Arabic is fine):
   - *The problem*: what was hard or missing before the app
   - *My role*: what you personally did (built it alone, led a team, built the app but not the backend...)
   - *The outcome*: what changed (downloads, a client result, a launch), only what you can stand behind
3. **Decisions:**
   - Who is the site mainly for: companies hiring, freelance clients, or both (it changes the hero and the CTAs)
   - "I" or "we" in the texts
   - Real store ratings, if you want them shown
   - The client testimonials: real people who agreed to be quoted? (one quotes "25%")

Claude prepares a short form or document with these questions so they can be answered in one go.

## Phase 2: message and structure

| # | Change | Detail |
|---|--------|--------|
| 2.1 | New hero headline | 2 or 3 options to choose from, built on real proof (for example "Flutter apps people actually download: Gomla and Stock passed 10,000+ downloads each") |
| 2.2 | Projects move up | Order: Hero, Projects, Experience, Testimonials, Contact |
| 2.3 | One "About" section instead of three | About, Expertise and Why Choose Me say similar things; merged into one short section |
| 2.4 | Skill percentages go | "Flutter 95%" is replaced by skills grouped by area, without numbers |
| 2.5 | Project curation | The 4 or 5 strongest apps in the main showcase, every other app in a compact "More projects" list; all keep their case study page |
| 2.6 | Better descriptions | Generic words ("powerful", "seamless") replaced by what the app actually does |

Delivered as a local preview first, then a PR preview link.

## Phase 3: visual identity

| # | Change | Detail |
|---|--------|--------|
| 3.1 | Fonts: from 7 families to 2 | A readable proportional font for long text, one monospace for accents; faster on mobile |
| 3.2 | Colour and contrast | Keep the dark theme and cyan, make it less "terminal": calmer surfaces, accent only where it matters |
| 3.3 | Custom cursor | Removed (or kept subtle on desktop only), it can get in the way |
| 3.4 | Consistent spacing and type scale | One scale for every section |

Shown as 2 or 3 side-by-side directions to choose from (the same switch we used for the projects
designs), with the current look always one click away.

## Phase 4: adding the missing apps

1. Screenshots optimised (WebP, right size) and uploaded.
2. Each app added to Firestore with all fields, including its story and `featured` where it fits.
3. Each one checked on the local site and the PR preview before going live.
4. The admin dashboard: if it should be able to edit the new fields (featured, highlight, problem,
   role, outcome, slug), that is a separate task. Needs: where the dashboard's code lives.

## Phase 5: turning visitors into conversations

| # | Change |
|---|--------|
| 5.1 | WhatsApp button and/or a "Book a call" link (Calendly or similar) next to the contact form |
| 5.2 | Clear next step at the end of each case study (already there) and in the hero |
| 5.3 | Visitor analytics: which projects get opened, which buttons get clicked, where people leave |

## Phase 6: performance and final checks

- Lighthouse on mobile at 90 or more (now 56 to 76; the fonts in phase 3 are the main fix)
- Test on real phones (Android and iPhone) and common laptop sizes
- Sharing preview (the image and text shown when the link is sent on WhatsApp or LinkedIn) checked per page
- Final review of every text for claims that are not confirmed

---

## Order and effort

| Phase | Depends on | Claude's work | Owner's work |
|-------|------------|---------------|--------------|
| 0 | | minutes | an OK, and one merge |
| 1 | | prepare the questions | the answers, screenshots, links |
| 2 | 1 (decisions) | 1 to 2 sessions | choose the headline, review the preview |
| 3 | | 1 to 2 sessions | choose a direction |
| 4 | 1 (apps) | about 1 session | review |
| 5 | 2 | 1 session | the WhatsApp number / booking link |
| 6 | 2 to 5 | 1 session | test on your phone |

Phases 2 and 3 can start while phase 1's answers are being collected: the structure and the visual
direction do not need the new apps.
