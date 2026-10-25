// Responsive audit: every page at 11 widths. Reports sideways scroll and
// the elements that stick out past the viewport (ignoring ones inside a
// scroller or a clipping box, which cannot cause page scroll), and tiny tap
// targets on phone widths. Writes lab/resp-<page>-<w>.png (first screen).
const path = require('path');
const { chromium } = require(path.resolve('C:/Users/Lenovo/AppData/Local/Temp/claude/D--my-web-site/22f29d05-3454-4001-a61e-e10846890fb4/scratchpad/shots/node_modules/playwright-core'));
const BASE = process.env.BASE || 'http://localhost:4500';
const pages = process.argv.slice(2).length ? process.argv.slice(2) : ['d', 'cs-stock', 'cs-gomla', 'cs-drugza-tagpharma', 'cs-adruse'];
const url = (pg) => BASE.includes('4500') ? `${BASE}/${pg}.html` : `${BASE}${pg}`;
const widths = [320, 360, 375, 390, 414, 768, 834, 1024, 1280, 1440, 1920];
(async () => {
  const b = await chromium.launch({ executablePath: 'C:/Program Files/Google/Chrome/Application/chrome.exe', headless: true });
  const report = [];
  for (const pg of pages) {
    for (const w of widths) {
      const ctx = await b.newContext({ viewport: { width: w, height: w < 768 ? 844 : 900 }, isMobile: w < 768, hasTouch: w < 768 });
      const p = await ctx.newPage();
      await p.goto(url(pg), { waitUntil: 'networkidle' });
      // Let entrances finish everywhere: walk the page once.
      await p.evaluate(async () => { for (let y = 0; y < document.body.scrollHeight; y += innerHeight * 0.8) { scrollTo(0, y); await new Promise((r) => setTimeout(r, 120)); } scrollTo(0, 0); });
      await p.waitForTimeout(600);
      const r = await p.evaluate((w) => {
        const vw = document.documentElement.clientWidth;
        const clipped = (el) => { for (let a = el.parentElement; a && a !== document.body; a = a.parentElement) { const s = getComputedStyle(a); if (s.overflowX !== 'visible' || s.overflow !== 'visible') return true; } return false; };
        const out = [];
        for (const el of document.querySelectorAll('body *')) {
          const rc = el.getBoundingClientRect();
          if (!rc.width || getComputedStyle(el).position === 'fixed') continue;
          if ((rc.right > vw + 1 || rc.left < -1) && !clipped(el)) out.push(`${el.tagName.toLowerCase()}.${[...el.classList].join('.')} [${Math.round(rc.left)}..${Math.round(rc.right)}]`);
        }
        const small = w < 768 ? [...document.querySelectorAll('a, button, [role="button"]')].filter((e) => { const rc = e.getBoundingClientRect(); return rc.width && rc.height && (rc.width < 40 || rc.height < 40) && getComputedStyle(e).visibility !== 'hidden'; }).map((e) => `${e.tagName.toLowerCase()}.${[...e.classList].join('.')}(${Math.round(e.getBoundingClientRect().width)}x${Math.round(e.getBoundingClientRect().height)}) "${(e.getAttribute('aria-label') || e.textContent).trim().slice(0, 24)}"`) : [];
        return { scroll: document.documentElement.scrollWidth - vw, offenders: [...new Set(out)].slice(0, 8), small: [...new Set(small)].slice(0, 8) };
      }, w);
      await p.screenshot({ path: `lab/resp-${pg.replace(/W/g, '_')}-${w}.png` });
      report.push({ page: pg, w, ...r });
      await ctx.close();
    }
  }
  await b.close();
  for (const r of report) {
    const bad = r.scroll > 0 || r.offenders.length;
    console.log(`${bad ? 'FAIL' : 'ok  '} ${r.page} @${r.w}: sideways=${r.scroll}px${r.offenders.length ? '\n     out: ' + r.offenders.join('\n          ') : ''}${r.small.length ? '\n     small: ' + r.small.join(' | ') : ''}`);
  }
})();
