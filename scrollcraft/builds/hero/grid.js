// Contact sheet of one project's images, numbered. Usage: node grid.js <slug>
const fs = require('fs'), path = require('path');
const { chromium } = require(path.resolve('C:/Users/Lenovo/AppData/Local/Temp/claude/D--my-web-site/22f29d05-3454-4001-a61e-e10846890fb4/scratchpad/shots/node_modules/playwright-core'));
const slug = process.argv[2];
const p = JSON.parse(fs.readFileSync('data/projects.json', 'utf8')).find((x) => x.slug === slug);
(async () => {
  const b = await chromium.launch({ executablePath: 'C:/Program Files/Google/Chrome/Application/chrome.exe', headless: true });
  const pg = await b.newPage({ viewport: { width: 1500, height: 400 } });
  await pg.setContent(`<body style="margin:6px;display:flex;flex-wrap:wrap;gap:6px;font:12px sans-serif">${p.images.map((s, i) => `<figure style="margin:0"><img src="${s}" style="height:240px;display:block;border:1px solid #ccc"><figcaption>${i}</figcaption></figure>`).join('')}</body>`);
  await pg.waitForLoadState('networkidle'); await pg.waitForTimeout(1500);
  await pg.screenshot({ path: `out/grid-${slug}.png`, fullPage: true });
  await b.close();
})();
