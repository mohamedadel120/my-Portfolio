# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Stack
Dart. The live site is Flutter Web (`lib/`, WASM, Firebase Hosting). The confirmed future is the Jaspr static-site rewrite in `jaspr_site/` (pre-rendered HTML, Firestore REST for content). New UI work targets `jaspr_site/`; `lib/` is kept working until the migration ships.

## Users
Prospective freelance clients and hiring companies looking at Mohamed Adel's work. They arrive to judge quality and decide whether to get in touch or hire. (Audience split is the owner's description: "attract clients and companies".)

## Product Purpose
A personal portfolio owned by its subject: show his shipped mobile work in the best possible light and convert visitors into contacts (clients) and interviews (companies). Success is a visitor reaching the contact form or CV after seeing the projects.

## Positioning
A Flutter developer whose own site is itself evidence of craft: custom, animated, content-driven from Firestore, and pre-rendered for search once on Jaspr.

## Operating Context
Content (projects, experience, expertise, hero copy) lives in Firestore and is edited without a rebuild. Deployed to Firebase Hosting (`muhammed-adel.web.app`) via GitHub Actions. Site copy is English; the owner works in Arabic (Egyptian).

## Capabilities and Constraints
- Sections: hero, about, expertise, experience, projects, contact (home page) plus /about, /projects, /contact routes.
- Dark and light themes exist; dark is the default identity.
- Project presentation (the sticky showcase) is open for redesign proposals; nothing else is declared binding.
- Undecided: whether `lib/` is retired once Jaspr ships.

## Brand Commitments
None declared as binding. The current cyan and purple on black, monospace type pairing, and custom cursor are the incumbent look, not confirmed constraints.

## Evidence on Hand
Case-study imagery for six projects in `assets/images/` (adruse, albatal, gomla, hi_gold, paletta, stock), optional video in `assets/videos/`, GitHub and LinkedIn links, `jaspr_site/web/og_image.png`. No testimonials or metrics are confirmed; the stats dashboard values come from project data and must not be invented.

## Product Principles
1. The work leads: projects get the most room and the best presentation.
2. One clear next step: every section points toward contacting or hiring.
3. The site demonstrates craft by being fast, accessible and robust, not only decorative.
4. Content stays editable in Firestore; design must survive any content length.
5. Honest claims: no invented numbers, clients or testimonials.

## Accessibility & Inclusion
Respect reduced-motion and keyboard use; no specific standard was required by the owner.
