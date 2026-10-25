// Swipe left/right on the first app's phone; screenshot the meta row icons.
const path = require('path');
const { chromium } = require(path.resolve('C:/Users/Lenovo/AppData/Local/Temp/claude/D--my-web-site/22f29d05-3454-4001-a61e-e10846890fb4/scratchpad/shots/node_modules/playwright-core'));
(async () => {
  const b = await chromium.launch({ executablePath: 'C:/Program Files/Google/Chrome/Application/chrome.exe', headless: true });
  const p = await b.newPage({ viewport: { width: 1440, height: 900 } });
  await p.goto('http://localhost:4500/d.html', { waitUntil: 'networkidle' });
  const phone = p.locator('[data-app] .app-phone').first();
  await phone.scrollIntoViewIfNeeded();
  await p.waitForTimeout(1200);
  const on = () => p.evaluate(() => [...document.querySelector('[data-app]').querySelectorAll('.frame')].findIndex((f) => f.classList.contains('on')));
  const box = await phone.boundingBox();
  const swipe = async (dx) => { await p.mouse.move(box.x + box.width / 2, box.y + box.height / 2); await p.mouse.down(); await p.mouse.move(box.x + box.width / 2 + dx, box.y + box.height / 2, { steps: 6 }); await p.mouse.up(); await p.waitForTimeout(150); };
  const start = await on();
  await swipe(-120); const afterLeft = await on();
  await swipe(120); const afterRight = await on();
  console.log(JSON.stringify({ start, afterSwipeLeft: afterLeft, afterSwipeRight: afterRight }));
  await p.locator('[data-app] .meta').first().screenshot({ path: 'lab/meta-icons.png' });
  await b.close();
})();
