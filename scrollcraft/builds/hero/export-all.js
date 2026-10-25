// Exports the chosen screens for the projects added with the full data,
// plus store icons, then writes data/manifest.json with every asset's size.
// Crops: Palleta's screens sit inside a phone mockup (screen cut out);
// Ureva's carry a "Device Preview" bar at the bottom (trimmed).
const fs = require('fs');
const path = require('path');
const { chromium } = require(path.resolve('C:/Users/Lenovo/AppData/Local/Temp/claude/D--my-web-site/22f29d05-3454-4001-a61e-e10846890fb4/scratchpad/shots/node_modules/playwright-core'));
const P = Object.fromEntries(JSON.parse(fs.readFileSync('data/projects.json', 'utf8')).map((p) => [p.slug, p]));
const PAL = [0.237, 0.225, 0.5235, 0.597];
const URE = [0, 0, 1, 0.925];
const jobs = [];
const add = (slug, picks, crop, w = 600) => picks.forEach((i, k) => jobs.push([P[slug].images[i], `assets/${slug}-${k + 1}.webp`, w, crop]));
add('gomla', [0, 1, 2, 3], null, 700);
add('palleta', [3, 2, 4, 1], PAL);
add('to-let', [0, 4, 8, 6, 20, 13], null);
add('ureva', [0, 2, 3, 5, 7], URE);
add('adruse', [4, 0, 3, 8, 10, 14], null);
const icon = (u, out) => jobs.push([u, `assets/${out}`, 160, null]);
icon('https://play-lh.googleusercontent.com/k69CNsb3KdNG59elIFAsfpsVyRYOLeV-iLibqJLy3ToNHFowVNhDiV8Pk4KBygbXEwyg8MCMQ9oV9KPsvR9b=s256', 'icon-gomla-play.webp');
icon('https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/23/21/3e/23213e5b-1d50-b37f-fe21-9598bb7bbfc2/Placeholder.mill/256x256bb.png', 'icon-gomla-ios.webp');
icon('https://play-lh.googleusercontent.com/fgp4GUF1V32CJ8nHcTc1yJJfiSGtkt9JsI8rEt3gz4oXtGQG8-LBVH_35grhF0RZQmyykHje3qXkehjUy8Lwqw=s256', 'icon-palleta-play.webp');
icon('https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/ea/c5/07/eac50785-e9fe-6663-a385-22b56d18a641/Placeholder.mill/256x256bb.png', 'icon-palleta-ios.webp');
icon('https://play-lh.googleusercontent.com/Sw6L9XzJOfB07_gTiU2Cu_7Dsp1QsxDR5sjO1FPrf0KubHK3GnuH5GgKd6VUgO7wf0I5-e9h5StCa_EsChbHtQ=s256', 'icon-to-let-play.webp');
icon('https://is1-ssl.mzstatic.com/image/thumb/PurpleSource211/v4/c8/29/9a/c8299a65-7e25-78ca-fe62-b33e8e7f69f8/Placeholder.mill/256x256bb.png', 'icon-to-let-ios.webp');
icon('https://play-lh.googleusercontent.com/kIka5keWc-RgogKvpiiYWIaV5sMal2ffp0Ne8k3ytdSML0y4zhntJQtg92yFe27jMZgghzeddnsCwk2YbjzjBw=s256', 'icon-drugza-tagpharma-play.webp');

(async () => {
  const browser = await chromium.launch({ executablePath: 'C:/Program Files/Google/Chrome/Application/chrome.exe', headless: true });
  const page = await browser.newPage();
  for (const [src, out, width, crop] of jobs) {
    if (fs.existsSync(out)) continue;
    const res = await page.evaluate(async ({ src, width, crop }) => {
      const bmp = await createImageBitmap(await (await fetch(src)).blob());
      const [sx, sy, sw, sh] = crop ? [crop[0] * bmp.width, crop[1] * bmp.height, crop[2] * bmp.width, crop[3] * bmp.height] : [0, 0, bmp.width, bmp.height];
      const w = Math.min(width, Math.round(sw)), h = Math.round(sh * (w / sw));
      const c = document.createElement('canvas'); c.width = w; c.height = h;
      c.getContext('2d').drawImage(bmp, sx, sy, sw, sh, 0, 0, w, h);
      return c.toDataURL('image/webp', 0.85);
    }, { src, width, crop });
    fs.writeFileSync(out, Buffer.from(res.split(',')[1], 'base64'));
    console.log('wrote', out);
  }
  // Sizes of everything in assets/, for width/height attributes.
  const manifest = {};
  for (const f of fs.readdirSync('assets').filter((f) => f.endsWith('.webp'))) {
    manifest[f] = await page.evaluate(async (src) => { const b = await createImageBitmap(await (await fetch(src)).blob()); return [b.width, b.height]; },
      'data:image/webp;base64,' + fs.readFileSync('assets/' + f).toString('base64'));
  }
  fs.writeFileSync('data/manifest.json', JSON.stringify(manifest, null, 1));
  console.log(Object.keys(manifest).length, 'assets in manifest');
  await browser.close();
})();
