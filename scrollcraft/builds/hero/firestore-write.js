// Writes the two new project fields to Firestore, and nothing else:
//   showcase      { mode, screens: [{ url, caption, notes: [{ label, y }] }] }
//   storeListings [{ store, title, developer, iconUrl }]
// The update mask names only these fields, so every existing field stays.
// Usage: FS_TOKEN=... node firestore-write.js [--write]   (dry run without)
const fs = require('fs');
const projects = require('./data/full');
const { STORES } = require('./icons');
const uploads = require('./data/uploads.json');
const backup = require('../../backups/projects-2026-10-25.json');

const S = (v) => ({ stringValue: v });
const I = (v) => ({ integerValue: String(v) });
const A = (vals) => ({ arrayValue: vals.length ? { values: vals } : {} });
const M = (fields) => ({ mapValue: { fields } });

const docBySlug = {};
for (const d of backup.documents) {
  const title = d.fields.title.stringValue;
  const p = projects.find((x) => x.title === title);
  if (p) docBySlug[p.slug] = d.name;
}

const plan = projects.map((p) => {
  const showcase = M({
    mode: S(p.mode),
    screens: A(p.shots.map(([f, caption, notes]) => {
      if (!uploads[f]) throw new Error('not uploaded: ' + f);
      return M({
        url: S(uploads[f]),
        caption: S(caption),
        notes: A((notes || '').split('|').filter(Boolean).map((n) => { const [label, y] = n.split('@'); return M({ label: S(label), y: I(Number(y)) }); })),
      });
    })),
  });
  const storeListings = A(STORES[p.slug].map((s) => M({ store: S(s.store), title: S(s.title), developer: S(s.dev), iconUrl: S(uploads[s.icon]) })));
  return { slug: p.slug, doc: docBySlug[p.slug], body: { fields: { showcase, storeListings } } };
});

(async () => {
  for (const x of plan) {
    if (!x.doc) throw new Error('no document for ' + x.slug);
    const screens = x.body.fields.showcase.mapValue.fields.screens.arrayValue.values || [];
    const notes = screens.reduce((n, s) => n + (s.mapValue.fields.notes.arrayValue.values || []).length, 0);
    console.log(`${x.slug.padEnd(17)} ${x.doc.split('/').pop()}  mode=${x.body.fields.showcase.mapValue.fields.mode.stringValue}  screens=${screens.length}  labels=${notes}  stores=${(x.body.fields.storeListings.arrayValue.values || []).length}`);
  }
  if (process.argv[2] !== '--write') return console.log('dry run: nothing written');
  for (const x of plan) {
    const url = `https://firestore.googleapis.com/v1/${x.doc}?updateMask.fieldPaths=showcase&updateMask.fieldPaths=storeListings`;
    const res = await fetch(url, { method: 'PATCH', headers: { Authorization: `Bearer ${process.env.FS_TOKEN}`, 'Content-Type': 'application/json' }, body: JSON.stringify(x.body) });
    console.log(x.slug, res.status, res.ok ? 'written' : await res.text());
  }
})();
