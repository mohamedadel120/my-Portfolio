# Firestore corrections: what to change, document by document

Project: `my-website-bf9e6`, collection `projects`. Writes to this collection need a signed-in admin
(`firestore.rules`), so these edits are made by you in the Firebase console (or your admin
dashboard). Nothing below has been applied. Every value marked **ASK** needs your answer first;
the rest is ready to paste.

Field types matter: `featured` must be a **boolean**, everything else here is a **string**.

## Answer these first

| # | Question | Why it matters |
| --- | --- | --- |
| 1 | Gomla downloads: 10,000+ or 5,000+? | `downloads` field says 10,000+, the description says 5,000+ |
| 2 | Albatal downloads: 5,000+ or 10,000+? | `downloads` says 5,000+, the description says 10,000+ |
| 3 | Stock: is 10,000+ downloads accurate? | Shown on the site |
| 4 | DrugZa: where does "35% increase in customer engagement" come from, and over what period? | Specific number a visitor may ask about |
| 5 | to-let: show "100" downloads, "100+", or hide it? | 100 reads as small next to the others |
| 6 | Gomla headline: which of the three options in `project-story-drafts.md`? (If "first app", in which region?) | Goes in `highlight` |
| 7 | "I" or "we" across the site? | Wording of `problem` and `outcome` |
| 8 | Your role per project | Goes in `role` |
| 9 | Ratings: real store ratings per app (when you have them) | Goes in `rating` (a number 0 to 5) |

## Document by document

### Gomla Mobile App  (`AGhUvszdz253QJcpp0wk`)
| Field | Type | Value |
| --- | --- | --- |
| `featured` | boolean | `true` |
| `highlight` | string | **ASK (#6).** Safe option: `One app for AI skin analysis, virtual makeup try-on and delivery to your door.` |
| `problem` | string | `Buying beauty products usually means going to a store to try them, and not every product suits every skin. Many customers first had to see a dermatologist just to learn their skin type before they could buy something suitable.` |
| `description` | string | `We built an app that uses AI to analyze your skin. It tells you your skin type, which products you need and which ones you do not. You can try products such as makeup virtually before buying, then order them and have them delivered to your door.` |
| `downloads` | string | **ASK (#1)** |
| `tech` | array of strings | add the AI technology you used (**ASK**: own model, an API, on-device?), for example `AI` |
| `role`, `outcome`, `rating` | | **ASK** (#8, #9). Leave unset until you have them |

Note: this replaces the current description ("comprehensive e-commerce solution ... 5,000+ downloads
... 4.8-star ratings"), which no longer matches the app.

### Stock Mobile App  (`2KVhxJcl6K73DYEN5UTm`)
| Field | Type | Value |
| --- | --- | --- |
| `description` | string | Remove the unverified rating. Suggested: `A powerful B2B inventory management platform designed for businesses to efficiently track and manage their stock. Built with clean architecture and Bloc pattern for scalable state management.` (add `The app has passed 10,000+ downloads.` once #3 is confirmed) |
| `problem` | string | **Draft, confirm or rewrite:** `Businesses that buy and sell in bulk often track stock by hand, so counts drift and reordering becomes guesswork.` |
| `downloads` | string | **ASK (#3)**; currently `10,000+` |

### Albatal Mobile App  (`C76zqleRPNpSMqgOa6n2`)
| Field | Type | Value |
| --- | --- | --- |
| `description` | string | Suggested (rating removed, no download claim until #2): `A full-featured marketplace platform that connects sellers and customers seamlessly. Includes a robust seller dashboard for inventory management, order processing, and analytics, while giving customers a smooth shopping experience.` |
| `problem` | string | **Draft:** `Sellers need a way to reach customers, and customers want one place to buy from many sellers.` |
| `downloads` | string | **ASK (#2)** |

### Palleta Mobile App  (`HScIAMJKMOaysit45JoR`)
| Field | Type | Value |
| --- | --- | --- |
| `problem` | string | **ASK.** The current description is generic ("modern businesses"); what does Palleta help its users do? |
| `description` | string | Rewrite once you answer; the current one says nothing specific |

### to-let  (`Jib3lN5zGZ9kZpeVjkAL`)
| Field | Type | Value |
| --- | --- | --- |
| `description` | string | Clean version of the current marketing copy: `Rent smarter, move faster. to-let streamlines the entire renting process into one simple interface designed for people on the move, with instant discovery of places tailored to your budget and lifestyle.` |
| `problem` | string | **Draft:** `Finding a place to rent is slow and scattered across many sources.` |
| `downloads` | string | **ASK (#5)** |

### ureva  (`TklMGh00giLBs6aLGKKk`)
| Field | Type | Value |
| --- | --- | --- |
| `problem` | string | **Draft:** `Gold and diamond prices move every second, and buyers want to purchase at the current price with confidence.` |
| `downloads` | string | `Coming Soon` (keep). Note: it has Android and iOS store URLs filled in, so the site counts it as "live on the stores". If it is not released, clear both URLs. **ASK** |

### Adruse Mobile App  (`UDZxMMLzMmOZleiss98E`)
| Field | Type | Value |
| --- | --- | --- |
| `problem` | string | **Draft:** `Parents and schools lack a clear, current view of how each student is progressing.` |
| `downloads` | string | `LMS Platform` is a label, not a number; fine to keep or replace with a real figure |

### DrugZa - TagPharma  (`j4vecmFJxiAbW2AhN5yo`)
| Field | Type | Value |
| --- | --- | --- |
| `description` | string | **ASK (#4).** If you cannot source it, remove the last sentence ("...a significant 35% increase in customer engagement") |
| `problem` | string | **Draft:** `Patients need access to medical and pharmacy information even when their connection is poor.` |
| `downloads` | string | `High Engagement` is vague; replace with a real figure or leave |

## Other places with unverified numbers (not in `projects`)

`profile_info/main` has no `downloadsCount`, `ratings`, `skills` or `features` fields, so the About
section was showing hardcoded defaults from the code ("10k+" downloads, a 4.8 rating, skill
percentages). The 4.8 is already hidden. To set real values, add on `profile_info/main`:

| Field | Type | Effect |
| --- | --- | --- |
| `downloadsCount` | string, e.g. `10k+` | Replaces the code default "10k+" (only if true) |
| `ratings` | string, e.g. `4.7` | Shows the rating in About (hidden until set) |

The skill percentages (95%, 90%, ...) are still code defaults; tell me whether they are accurate or
should be hidden.

## Order of the projects

The site lists projects in Firestore document-id order, which is arbitrary (`sortOrder` is `0` on
every project and is not used). Setting `featured: true` on Gomla puts it first; the rest keep
their current order. If you want a different order, I can make the site honour `sortOrder`.

## After you edit

Reload http://localhost:8080 (the data is read at build time, so a deployed site needs a new
build to pick it up).
