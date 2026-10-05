# PRODUCT.md — Mohamed Adel Portfolio

Durable product context for design work on this site. Facts are drawn from the
code, the live Firestore content, and Muhammed's brand kit; anything marked
*(inferred)* still needs his confirmation.

## What it is

The personal portfolio of **Mohamed Adel (Muhammed)**, a Flutter developer
based in Cairo with 3+ years shipping cross-platform mobile apps for iOS and
Android. Live at https://muhammed-adel.web.app.

- **Live surface:** `jaspr_site/` — a statically pre-rendered Jaspr (Dart)
  site, deployed to Firebase Hosting on every push to `main`. Content is
  fetched from Firestore at build time and baked into plain HTML, so crawlers
  and `llms.txt` readers get real content without JavaScript.
- **Legacy surface:** `lib/` — the earlier Flutter Web (WASM) build. No longer
  deployed; it is the source the Jaspr tokens and sections were ported from.
  Treat it as reference, not as a design target.
- **Pages:** `/` (Hero, About, Expertise, Experience, Projects, Contact on one
  scroll), plus `/about`, `/projects`, `/contact`.

## Why it exists

Credibility that converts into opportunity: job offers, freelance and agency
leads, and trust for a future product. Not follower count or vanity metrics.
The site is the destination his LinkedIn, Instagram and TikTok content points
to, so it has to read as the same person.

## Who it is for

1. **Recruiters and hiring managers** scanning for Flutter talent. They skim
   in under a minute and want role, seniority, shipped apps, and a CV link.
2. **Founders and agencies hiring for an app** *(inferred)*. They want proof
   that apps shipped and succeeded in the stores, and an easy way to make
   contact.
3. **Developers from his content audience** (Arabic-speaking, Egypt and the
   Gulf) who follow a post back to the site. They judge craft and code taste.

The site itself is in English. Arabic appears only in the logo wordmark.

## Proof the design must carry

These are the strongest facts on the site; design should make them easy to
find, not bury them in decoration.

- **Stock (B2B inventory):** 10,000+ downloads, 4.8★ on Google Play and the
  App Store. Flutter, Bloc, Clean Architecture.
- **Gomla (e-commerce):** 5,000+ downloads, 4.8★, payments integration.
- Further shipped apps with real screenshots: Adruse, Albatal, Paletta,
  Drugza (demo video).
- Testimonials from named clients (The First-Agency, Stock Tech, Gomla).
- Downloadable CV (Google Drive link in `profile_info/main.cvUrl`).

Content lives in Firestore (`profile_info`, `projects`, `experience`,
`expertise`, `testimonials`) and is edited there, not in code. Design must
survive content length changing without a rebuild of the layout.

## Brand personality

Precise, technical, quietly confident. A developer who lets shipped work and
specific numbers do the talking. Confidence comes from specificity, never from
hype ("no 🚀 game changer"). Terminal and code culture is native to the brand,
not a costume: monospace type, a `muhammed@flutter:~$` prompt with a cyan block
cursor as signature, series-style eyebrows.

## Visual identity (current state and source of truth)

Muhammed's brand kit (the `muhammed-brand` skill) is the authority for color
and type. The live site predates parts of it and diverges:

| | Brand kit | Live site today |
|---|---|---|
| Background | `#0A0E14` | `#000000` |
| Primary cyan | `#18C8EF` (sampled from logo) | `#00D9FF` |
| Purple | `#8B7BEF`, code keywords only | `#7B2CBF`, used in gradients |
| Headlines | Inter 800 | IBM Plex Mono, Orbitron (hero name), Oswald, Anton |
| Body / labels | JetBrains Mono | JetBrains Mono, Space Mono, Fira Code |
| Rules | No new accents, no gradients beyond soft panel glows | Cyan→purple gradient underline on section titles |

Brand-kit rules that apply to the site: never improvise a new accent color;
red `#FF5C5C` is for wrong/broken states only; no stock illustration; the
logo (cyan Arabic wordmark in a circle) is a small corner signature, never
recolored or placed on a light background.

*Open:* whether to converge the site onto the brand kit's tokens and type, or
keep the site's own louder display treatment (Orbitron hero name) as an
intentional web-only exception.

## Anti-references

- Generic "dev portfolio template" looks: gradient blobs, glassmorphism cards,
  skill progress bars with percentages, emoji-heavy copy.
- Hype voice and unverifiable superlatives.
- Decoration that slows the page or hides the shipped apps below the fold.

## Constraints

- **Static and fast.** Content must render without JavaScript; animations are
  CSS-first and must respect `prefers-reduced-motion`. Performance has been a
  repeated focus in the commit history (LCP, off-screen animation pausing,
  compressed media).
- **Responsive tiers:** mobile < 768px, tablet 768–1023px, desktop ≥ 1024px,
  wide desktop ≥ 1440px (`jaspr_site/lib/constants/theme.dart`).
- **Dark first.** A light theme toggle exists (`data-theme="light"`); the logo
  rule above means light mode needs care around the mark.
- **Accessibility:** WCAG 2.1 AA contrast and full keyboard reachability
  *(inferred target)*. The custom cursor must never replace focus visibility.
- **Privacy:** Firestore `profile_info` holds a street address and phone
  number. Public pages show city and country only unless Muhammed says
  otherwise.

## Known content issues to confirm before design touches them

- A testimonial from "Jane Doe, Senior Tech Lead, TechFlow Systems" reads as
  placeholder data. Do not feature or redesign around it until confirmed.
- About-section features and skills come from hardcoded fallbacks (with
  duplicates) because Firestore lacks those fields.
