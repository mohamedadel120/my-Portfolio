# Project story drafts (for your review)

Written only from the descriptions already in your Firestore `projects` collection.
Nothing here is published. Fields map to Firestore like this: **Problem** -> `problem`,
**Solution** is the existing `description`, **Outcome** -> `outcome`, **Role** -> `role`.

Legend
- (from you) taken from your own description
- (inferred) my guess about the problem; confirm, rewrite or delete
- [CONFIRM] a number or claim that needs your check before it can show

Wording is neutral (no "I" or "we") so it works either way; tell me which you prefer.

Role for every project: [YOUR ROLE] (I cannot know it; for example "Flutter developer, end to end").

---

## 1. Stock Mobile App
- **Problem** (inferred): Businesses that buy and sell in bulk often track stock by hand, so counts drift and reordering becomes guesswork.
- **Solution** (from you): A B2B inventory management platform to track and manage stock, built with Clean Architecture and Bloc so it scales.
- **Outcome** [CONFIRM]: 10,000+ downloads. (The 4.8-star claim is left out until you send real ratings.)

## 2. Gomla Mobile App
- **Problem** (inferred): Buying online needs a checkout people trust and an app that stays simple to use.
- **Solution** (from you): An e-commerce app on a Firebase backend with secure payment processing, built with Clean Architecture.
- **Outcome** [CONFIRM]: Your downloads field says 10,000+ but the description says 5,000+. Which is right?

## 3. Albatal Mobile App
- **Problem** (inferred): Sellers need a way to reach customers, and customers want one place to buy from many sellers.
- **Solution** (from you): A marketplace connecting sellers and customers, with a seller dashboard for inventory, order processing and analytics.
- **Outcome** [CONFIRM]: Your downloads field says 5,000+ but the description says 10,000+. Which is right?

## 4. Palleta Mobile App
- **Problem**: [YOUR INPUT] The current description is generic ("modern businesses"), so there is nothing honest to infer. What does Palleta help its users do?
- **Solution** (from you): A Flutter app on Clean Architecture with Bloc state management and Firebase services.
- **Outcome** (from you): In active development.

## 5. to-let
- **Problem** (inferred): Finding a place to rent is slow and scattered across many sources.
- **Solution** (from you): Streamlines renting into one simple interface: results tailored to budget and lifestyle, and chat between the two sides.
- **Outcome** [CONFIRM]: Your downloads field says 100. Show "100+ downloads", show "Live on the stores", or leave it out? Also the description is marketing copy ("The One-Click Revolution:"), worth rewriting as a normal description.

## 6. ureva
- **Problem** (inferred): Gold and diamond prices move every second, and buyers want to purchase at the current price with confidence.
- **Solution** (from you): An e-commerce platform for the Saudi gold and diamond market: second-by-second price updates, secure purchasing, instant notifications and maps, with fully automated CI/CD.
- **Outcome** (from you): Coming soon. No number to show.

## 7. Adruse Mobile App
- **Problem** (inferred): Parents and schools lack a clear, current view of how each student is progressing.
- **Solution** (from you): A learning management system with interactive modules, real-time progress tracking and a parent portal for monitoring performance.
- **Outcome**: Nothing numeric is stated ("LMS Platform" is a label, not a result). Add one only if you have it.

## 8. DrugZa - TagPharma
- **Problem** (inferred): Patients need access to medical and pharmacy information even when their connection is poor.
- **Solution** (from you): A healthcare app connecting patients with pharmaceutical services, using SQLite and Hive so it works offline.
- **Outcome** [CONFIRM]: "35% increase in customer engagement". Is this real, from which measure and period? If you cannot source it, it should go.

---

## What I need back
1. Fix the [CONFIRM] items (numbers for Gomla, Albatal, to-let, DrugZa).
2. Keep, rewrite or delete each (inferred) problem; write the Palleta problem.
3. Your role line, and "I" or "we".
4. Real ratings, when you have them.

When this is approved I will give you the exact field values to paste into each Firestore project document (or a ready JSON), and the story format will read them. I do not write to your production Firestore myself.
