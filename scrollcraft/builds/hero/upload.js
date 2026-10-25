// Uploads the prototype's optimized screens and store icons to imgbb with
// the admin dashboard's own key (read from its source, never printed), and
// records filename -> URL in data/uploads.json. Re-runs skip done files.
const fs = require('fs');
const src = fs.readFileSync('D:/adel/admin_dashboard/lib/core/widgets/multiple_image_upload_field.dart', 'utf8');
const key = (src.match(/'key':\s*'([^']+)'/) || [])[1];
if (!key) throw new Error('imgbb key not found in the dashboard source');

const projects = require('./data/full');
const files = new Set();
for (const p of projects) for (const [f] of p.shots) files.add(f);
for (const f of fs.readdirSync('assets')) if (f.startsWith('icon-') && f.endsWith('.webp')) files.add(f);

const out = fs.existsSync('data/uploads.json') ? JSON.parse(fs.readFileSync('data/uploads.json', 'utf8')) : {};
(async () => {
  for (const f of files) {
    if (out[f]) continue;
    const body = new URLSearchParams({ key, image: fs.readFileSync('assets/' + f).toString('base64'), name: f.replace(/\.webp$/, '') });
    const res = await fetch('https://api.imgbb.com/1/upload', { method: 'POST', body });
    const json = await res.json();
    if (!json.success) { console.log('FAILED', f, json.error && json.error.message); continue; }
    out[f] = json.data.url;
    fs.writeFileSync('data/uploads.json', JSON.stringify(out, null, 1));
    console.log('ok', f);
  }
  console.log(Object.keys(out).length, 'of', files.size, 'uploaded');
})();
