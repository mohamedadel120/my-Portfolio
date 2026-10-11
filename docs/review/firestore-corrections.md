# Firestore corrections: what to change, document by document

Project: `my-website-bf9e6`, collection `projects`. Writes to this collection need a signed-in admin
(`firestore.rules`), so these edits are made by you in the Firebase console (or your admin
dashboard). Nothing below has been applied. Every value marked **ASK** needs your answer first;
the rest is ready to paste.

Field types matter: `featured` must be a **boolean**, everything else here is a **string**.

## Your answers (12 Oct)

- Gomla and Stock: 10,000+ downloads. Albatal: 1,000+. Every other project: no number.
- Gomla is the featured app and is listed first.
- Gomla headline: no "first app" claim; it shows what makes the app different instead (below).
- Still open: "I" or "we", your role per project, real ratings, the Palleta problem, and the AI technology Gomla uses.

Preview all of this locally before editing Firestore: start the `portfolio-preview-data` launch configuration.

## Document by document

### Gomla Mobile App  (`AGhUvszdz253QJcpp0wk`)
| Field | Type | Value |
| --- | --- | --- |
| `featured` | boolean | `true` |
| `highlight` | string | `Not just a beauty store: AI reads your skin, you try makeup on before you buy, and it arrives at your door.` (no "first" claim, as you asked; alternatives below) |
| `problem` | string | `Buying beauty products usually means going to a store to try them, and not every product suits every skin. Many customers first had to see a dermatologist just to learn their skin type before they could buy something suitable.` |
| `description` | string | `We built an app that uses AI to analyze your skin. It tells you your skin type, which products you need and which ones you do not. You can try products such as makeup virtually before buying, then order them and have them delivered to your door.` |
| `downloads` | string | `10,000+` |
| `tech` | array of strings | add the AI technology you used (**ASK**: own model, an API, on-device?), for example `AI` |
| `role`, `outcome`, `rating` | | **ASK** (#8, #9). Leave unset until you have them |

Other `highlight` wordings that show what sets Gomla apart without claiming it is the first or only one:

- `Skin analysis, virtual try-on and delivery, all in one app.`
- `Find out your skin type, try makeup on virtually, and get the right products delivered.`

Note: this replaces the current description ("comprehensive e-commerce solution ... 5,000+ downloads
... 4.8-star ratings"), which no longer matches the app.

### Stock Mobile App  (`2KVhxJcl6K73DYEN5UTm`)
| Field | Type | Value |
| --- | --- | --- |
| `description` | string | Remove the unverified rating. Suggested: `A powerful B2B inventory management platform designed for businesses to efficiently track and manage their stock. Built with clean architecture and Bloc pattern for scalable state management.` followed by `The app has passed 10,000+ downloads.` |
| `problem` | string | **Draft, confirm or rewrite:** `Businesses that buy and sell in bulk often track stock by hand, so counts drift and reordering becomes guesswork.` |
| `downloads` | string | `10,000+` (unchanged) |

### Albatal Mobile App  (`C76zqleRPNpSMqgOa6n2`)
| Field | Type | Value |
| --- | --- | --- |
| `description` | string | Suggested (rating and the 10,000+ claim removed): `A full-featured marketplace platform that connects sellers and customers seamlessly. Includes a robust seller dashboard for inventory management, order processing, and analytics, while giving customers a smooth shopping experience.` |
| `problem` | string | **Draft:** `Sellers need a way to reach customers, and customers want one place to buy from many sellers.` |
| `downloads` | string | `1,000+` |

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
| `downloads` | string | delete the field (or leave it empty): no number |

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
| `description` | string | `A specialized healthcare application connecting patients with pharmaceutical services. Features local data storage using SQLite and Hive for offline functionality, ensuring seamless access to medical information.` (the 35% claim removed) |
| `problem` | string | **Draft:** `Patients need access to medical and pharmacy information even when their connection is poor.` |
| `downloads` | string | delete the field (or leave it empty) |

## Ratings and figures in your other texts (About and Experience)

These sentences come from your own Firestore text, outside `projects`, and still show on the site.
They use the 4.8 rating you said is not confirmed yet, and the 35% figures:

| Where | Text on the site |
| --- | --- |
| `profile_info/main` > `professionalSummary` | "...10,000+ downloads and 4.8-star ratings on Google Play." |
| `experiences` (Stock role) | "Led design and maintenance of Stock App (B2B), achieving 10,000+ downloads and 4.8-star rating" |
| `experiences` (Innovation Company) | "Led design and implementation of Al-Taqwa Mobile App (1,000+ downloads, 4.8-star rating)" |
| `experiences` | "Delivered Tag-pharma & DrugZa Mobile App with 35% increase in customer engagement" |
| `experiences` (Innovation Company) | "Delivered Global Dent Mobile App with 35% increase in customer engagement" |

If the ratings are not confirmed, drop the "4.8-star" parts; if the 35% figures cannot be sourced,
drop those phrases. The download figures there match what you told me (Stock 10,000+).

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
