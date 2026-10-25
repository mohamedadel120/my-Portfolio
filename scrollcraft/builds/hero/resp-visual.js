// Visual pass: the projects area, contact and a case study at phone,
// tablet, small laptop and wide widths, one sheet per width.
const fs = require('fs'), path = require('path');
const { chromium } = require(path.resolve('C:/Users/Lenovo/AppData/Local/Temp/claude/D--my-web-site/22f29d05-3454-4001-a61e-e10846890fb4/scratchpad/shots/node_modules/playwright-core'));
(async () => {
  const b = await chromium.launch({ executablePath: 'C:/Program Files/Google/Chrome/Application/chrome.exe', headless: true });
  for (const w of [320, 768, 1024, 1920]) {
    const h = w < 768 ? 740 : 900;
    const ctx = await b.newContext({ viewport: { width: w, height: h }, isMobile: w < 768, hasTouch: w < 768 });
    const p = await ctx.newPage();
    const shots = [];
    const at = async (url, sel, name, off = 0) => {
      await p.goto(url, { waitUntil: 'networkidle' });
      if (sel) await p.evaluate(([s, o]) => { const e = document.querySelector(s); scrollTo(0, e.getBoundingClientRect().top + scrollY + o); }, [sel, off]);
      await p.waitForTimeout(1600);
      const f = `lab/vis-${w}-${name}.png`; await p.screenshot({ path: f }); shots.push(f);
    };
    await at('http://localhost:4500/d.html', null, 'hero');
    await at('http://localhost:4500/d.html', '[data-app]', 'app1-text', -20);
    await at('http://localhost:4500/d.html', '[data-app] .app-stage', 'app1-stage', -20);
    await at('http://localhost:4500/d.html', '#contact', 'contact', 60);
    await at('http://localhost:4500/cs-to-let.html', null, 'cs');
    await ctx.close();
    const s = await b.newPage({ viewport: { width: 1900, height: 800 } });
    const ht = w < 768 ? 520 : 330;
    await s.setContent(`<body style="margin:4px;display:flex;flex-wrap:wrap;gap:4px">${shots.map((f) => `<img style="height:${ht}px;border:1px solid #bbb" src="data:image/png;base64,${fs.readFileSync(f).toString('base64')}">`).join('')}</body>`);
    await s.screenshot({ path: `out/vis-${w}.png`, fullPage: true });
    await s.close();
  }
  await b.close();
})();
