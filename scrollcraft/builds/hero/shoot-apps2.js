// Second app (flipped) on desktop, and the first app on a phone.
const path = require('path');
const { chromium } = require(path.resolve('C:/Users/Lenovo/AppData/Local/Temp/claude/D--my-web-site/22f29d05-3454-4001-a61e-e10846890fb4/scratchpad/shots/node_modules/playwright-core'));
const wait = (ms) => new Promise((r) => setTimeout(r, ms));
(async () => {
  const b = await chromium.launch({ executablePath: 'C:/Program Files/Google/Chrome/Application/chrome.exe', headless: true });
  let p = await b.newPage({ viewport: { width: 1440, height: 900 } });
  await p.goto('http://localhost:4500/d.html', { waitUntil: 'networkidle' });
  await p.evaluate(() => document.querySelectorAll('[data-app]')[1].scrollIntoView({ block: 'center', behavior: 'instant' }));
  await wait(1500);
  await p.screenshot({ path: 'lab/apps-desk-second.png' });
  await p.close();
  p = await b.newPage({ viewport: { width: 390, height: 844 } });
  await p.goto('http://localhost:4500/d.html', { waitUntil: 'networkidle' });
  await p.evaluate(() => document.querySelector('[data-app] .app-stage').scrollIntoView({ block: 'center', behavior: 'instant' }));
  await wait(1500);
  await p.screenshot({ path: 'lab/apps-phone-stage.png' });
  await b.close();
})();
