// Each prototype at 0, 25, 50, 75% of the hero's scroll, desktop and phone,
// plus reduced motion; one contact sheet per prototype.
// Usage: node shoot.js [a b c]
const path = require('path');
const fs = require('fs');
const { chromium } = require(path.resolve('C:/Users/Lenovo/AppData/Local/Temp/claude/D--my-web-site/22f29d05-3454-4001-a61e-e10846890fb4/scratchpad/shots/node_modules/playwright-core'));
const which = process.argv.slice(2).length ? process.argv.slice(2) : ['a', 'b', 'c'];
const wait = (ms) => new Promise((r) => setTimeout(r, ms));
(async () => {
  const browser = await chromium.launch({ executablePath: 'C:/Program Files/Google/Chrome/Application/chrome.exe', headless: true });
  fs.mkdirSync('lab', { recursive: true });
  for (const m of which) {
    const shots = [];
    for (const [w, h, label, reduced] of [[1440, 900, 'desktop', false], [390, 844, 'phone', false], [1440, 900, 'reduced', true]]) {
      const ctx = await browser.newContext({ viewport: { width: w, height: h }, reducedMotion: reduced ? 'reduce' : 'no-preference', deviceScaleFactor: 1 });
      const page = await ctx.newPage();
      await page.goto(`http://localhost:4500/${m}.html`, { waitUntil: 'networkidle' });
      await page.evaluate(() => document.fonts.ready);
      for (const f of reduced ? [0, 0.5] : [0, 0.25, 0.5, 0.75]) {
        await page.evaluate((f) => window.scrollTo(0, f * document.querySelector('.hero').offsetHeight), f);
        await wait(250);
        const file = `lab/${m}-${label}-${Math.round(f * 100)}.png`;
        await page.screenshot({ path: file });
        shots.push([file, `${label} ${Math.round(f * 100)}%`, w]);
      }
      await ctx.close();
    }
    const page = await browser.newPage({ viewport: { width: 1800, height: 1000 } });
    const cells = shots.map(([f, cap, w]) => `<figure style="margin:0"><img style="height:${w < 500 ? 330 : 200}px;display:block;border:1px solid #bbb" src="data:image/png;base64,${fs.readFileSync(f).toString('base64')}"><figcaption style="font:12px sans-serif">${cap}</figcaption></figure>`).join('');
    await page.setContent(`<body style="margin:8px;display:flex;flex-wrap:wrap;gap:8px;align-items:flex-start">${cells}</body>`);
    await page.screenshot({ path: `lab/sheet-${m}.png`, fullPage: true });
    await page.close();
    console.log('sheet', m);
  }
  await browser.close();
})();
