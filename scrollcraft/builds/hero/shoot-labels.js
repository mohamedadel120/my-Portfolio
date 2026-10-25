// Every screen of the given projects with its labels, one sheet each.
// Usage: node shoot-labels.js palleta to-let ureva adruse
const fs = require('fs');
const path = require('path');
const { chromium } = require(path.resolve('C:/Users/Lenovo/AppData/Local/Temp/claude/D--my-web-site/22f29d05-3454-4001-a61e-e10846890fb4/scratchpad/shots/node_modules/playwright-core'));
(async () => {
  const b = await chromium.launch({ executablePath: 'C:/Program Files/Google/Chrome/Application/chrome.exe', headless: true });
  for (const slug of process.argv.slice(2)) {
    const p = await b.newPage({ viewport: { width: 1440, height: 1000 }, reducedMotion: 'reduce' });
    await p.goto(`http://localhost:4500/cs-${slug}.html`, { waitUntil: 'networkidle' });
    const n = await p.locator('.cs-app .steps button').count();
    const files = [];
    for (let i = 0; i < n; i++) {
      await p.locator('.cs-app .steps button').nth(i).click();
      await p.waitForTimeout(250);
      const f = `lab/lbl-${slug}-${i}.png`;
      await p.locator('.cs-app .app-stage').screenshot({ path: f });
      files.push(f);
    }
    await p.setViewportSize({ width: 1800, height: 700 });
    await p.setContent(`<body style="margin:4px;display:flex;flex-wrap:wrap;gap:4px">${files.map((f) => `<img style="height:560px" src="data:image/png;base64,${fs.readFileSync(f).toString('base64')}">`).join('')}</body>`);
    await p.screenshot({ path: `out/labels-${slug}.png`, fullPage: true });
    await p.close();
  }
  await b.close();
})();
