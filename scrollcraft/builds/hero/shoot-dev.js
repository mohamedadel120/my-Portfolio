// Stock's devices before and after choosing the iPhone, and the store
// previews on hover (Google Play, App Store) on the home prototype.
const path = require('path');
const { chromium } = require(path.resolve('C:/Users/Lenovo/AppData/Local/Temp/claude/D--my-web-site/22f29d05-3454-4001-a61e-e10846890fb4/scratchpad/shots/node_modules/playwright-core'));
(async () => {
  const b = await chromium.launch({ executablePath: 'C:/Program Files/Google/Chrome/Application/chrome.exe', headless: true });
  const p = await b.newPage({ viewport: { width: 1440, height: 900 } });
  await p.goto('http://localhost:4500/d.html', { waitUntil: 'networkidle' });
  const app = p.locator('[data-app]').first();
  await app.locator('.app-stage').scrollIntoViewIfNeeded();
  await p.waitForTimeout(1300);
  await app.locator('.app-stage').screenshot({ path: 'lab/dev-before.png' });
  // Click the visible right edge of the phone behind.
  const g = await app.locator('.ghost').boundingBox();
  await p.mouse.click(g.x + g.width - 20, g.y + g.height / 2);
  await p.waitForTimeout(300);
  await app.locator('.app-stage').screenshot({ path: 'lab/dev-mid.png' });
  await p.waitForTimeout(500);
  await app.locator('.app-stage').screenshot({ path: 'lab/dev-after.png' });
  const state = await app.evaluate((el) => ({ front: el.querySelector('.app-phone').className, back: el.querySelector('.ghost').className, backLabel: el.querySelector('.ghost').getAttribute('aria-label') }));
  console.log(JSON.stringify(state));
  for (const [i, name] of [[0, 'play'], [1, 'ios']]) {
    await p.mouse.move(10, 10);
    await app.locator('.store-icon').nth(i).hover();
    await p.waitForTimeout(350);
    const r = await app.locator('.peek-wrap').nth(i).boundingBox();
    await p.screenshot({ path: `lab/peek-${name}.png`, clip: { x: Math.max(0, r.x - 200), y: Math.max(0, r.y - 330), width: 520, height: 400 } });
  }
  await b.close();
})();
