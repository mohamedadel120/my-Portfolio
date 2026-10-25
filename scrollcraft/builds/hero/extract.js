// Reads every project from the live site's build (case study pages and the
// home page order) into data/projects.json. Facts only: what the site shows.
const fs = require('fs');
const path = require('path');
const BUILD = 'D:/my_web_site/jaspr_site/build/jaspr';
const strip = (s) => s.replace(/<!--[\s\S]*?-->/g, '').replace(/<style[\s\S]*?<\/style>/g, '').replace(/<script[\s\S]*?<\/script>/g, '');
const text = (s) => s.replace(/<[^>]+>/g, ' ').replace(/&amp;/g, '&').replace(/&#39;/g, "'").replace(/&quot;/g, '"').replace(/\s+/g, ' ').trim();

// Home order: the case study links in the order the home page lists them.
const home = strip(fs.readFileSync(path.join(BUILD, 'index.html'), 'utf8'));
const order = [...new Set([...home.matchAll(/href="\/projects\/([a-z0-9-]+)"/g)].map((m) => m[1]))];

const projects = order.map((slug) => {
  const h = strip(fs.readFileSync(path.join(BUILD, 'projects', slug, 'index.html'), 'utf8'));
  const main = h.slice(h.indexOf('<main'), h.indexOf('</main>'));
  const title = text((main.match(/<h1[^>]*>([\s\S]*?)<\/h1>/) || [])[1] || slug);
  const overviewBlock = main.slice(main.indexOf('Overview'));
  const overview = text((overviewBlock.match(/<p[^>]*>([\s\S]*?)<\/p>/) || [])[1] || '');
  const builtBlock = main.slice(main.indexOf('Built with'));
  const stack = [...builtBlock.slice(0, builtBlock.indexOf('</ul>')).matchAll(/<li[^>]*>([\s\S]*?)<\/li>/g)].map((m) => text(m[1]));
  const flat = text(main);
  const downloads = (flat.match(/Downloads ([\d,]+\+?)/) || [])[1] || '';
  const available = (flat.match(/Available on ([A-Za-z ]+?)(?: Google| App|$)/) || [])[1] || '';
  const play = (main.match(/href="(https:\/\/play\.google\.com[^"]+)"/) || [])[1] || null;
  const appStore = (main.match(/href="(https:\/\/apps\.apple\.com[^"]+)"/) || [])[1] || null;
  const images = [...new Set([...main.matchAll(/src="(https:\/\/i\.ibb\.co[^"]+)"/g)].map((m) => m[1]))];
  const video = (main.match(/<video[^>]*src="([^"]+)"/) || main.match(/<source[^>]*src="([^"]+)"/) || [])[1] || null;
  return { slug, title, overview, stack, downloads, available: available.trim(), play, appStore, images, video };
});
fs.mkdirSync('data', { recursive: true });
fs.writeFileSync('data/projects.json', JSON.stringify(projects, null, 2));
for (const p of projects) console.log(`${p.slug} | ${p.title} | dl ${p.downloads || '-'} | ${p.available || '-'} | play ${!!p.play} ios ${!!p.appStore} | ${p.images.length} img | video ${!!p.video} | ${p.stack.join(', ')}`);
