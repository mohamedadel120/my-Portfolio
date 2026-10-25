// The apps section: desktop mid-entrance and settled, and phone.
const path = require('path');
const { chromium } = require(path.resolve('C:/Users/Lenovo/AppData/Local/Temp/claude/D--my-web-site/22f29d05-3454-4001-a61e-e10846890fb4/scratchpad/shots/node_modules/playwright-core'));
const wait = (ms) => new Promise((r) => setTimeout(r, ms));
(async () => {
  const b = await chromium.launch({ executablePath: 'C:/Program Files/Google/Chrome/Application/chrome.exe', headless: true });
  for (const [w, h, name] of [[1440, 900, 'desk'], [390, 844, 'phone']]) {
    const p = await b.newPage({ viewport: { width: w, height: h } });
    await p.goto('http://localhost:4500/d.html', { waitUntil: 'networkidle' });
    await p.evaluate(() => document.querySelector('#projects .apps').scrollIntoView({ block: 'start', behavior: 'instant' }));
    await p.evaluate(() => window.scrollBy(0, -80));
    await wait(350);
    await p.screenshot({ path: `lab/apps-${name}-enter.png` });
    await wait(3600);
    await p.screenshot({ path: `lab/apps-${name}-later.png` });
    await p.close();
  }
  await b.close();
})();
