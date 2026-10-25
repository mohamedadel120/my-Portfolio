// Case study pages: the hero, each screen with its labels (via the step
// buttons), the rail, the stack; plus the hero on a phone.
// Usage: node shoot-cs.js stock|albatal
const path = require('path');
const { chromium } = require(path.resolve('C:/Users/Lenovo/AppData/Local/Temp/claude/D--my-web-site/22f29d05-3454-4001-a61e-e10846890fb4/scratchpad/shots/node_modules/playwright-core'));
const wait = (ms) => new Promise((r) => setTimeout(r, ms));
const slug = process.argv[2] || 'stock';
(async () => {
  const b = await chromium.launch({ executablePath: 'C:/Program Files/Google/Chrome/Application/chrome.exe', headless: true });
  const p = await b.newPage({ viewport: { width: 1440, height: 900 } });
  await p.goto(`http://localhost:4500/cs-${slug}.html`, { waitUntil: 'networkidle' });
  await wait(1500);
  await p.screenshot({ path: `lab/cs-${slug}-hero.png` });
  const n = await p.locator('.steps button').count();
  for (let i = 1; i < n; i++) {
    await p.locator('.steps button').nth(i).click();
    await wait(900);
    await p.locator('.rigwrap').screenshot({ path: `lab/cs-${slug}-screen-${i}.png` });
  }
  for (const id of ['screens', 'stack']) {
    await p.evaluate((id) => document.getElementById(id).scrollIntoView({ block: 'start', behavior: 'instant' }), id);
    await p.evaluate(() => scrollBy(0, -60));
    await wait(1500);
    await p.screenshot({ path: `lab/cs-${slug}-${id}.png` });
  }
  await p.close();
  const m = await b.newPage({ viewport: { width: 390, height: 844 } });
  await m.goto(`http://localhost:4500/cs-${slug}.html`, { waitUntil: 'networkidle' });
  await wait(1500);
  await m.screenshot({ path: `lab/cs-${slug}-phone.png`, fullPage: false });
  await m.evaluate(() => document.querySelector('.stores').scrollIntoView({ block: 'center', behavior: 'instant' }));
  await wait(600);
  await m.screenshot({ path: `lab/cs-${slug}-phone-stores.png` });
  await b.close();
})();
