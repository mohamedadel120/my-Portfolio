// Experience (log half drawn), About (file written), Contact, on desktop;
// Experience and Contact on a phone; Experience with reduced motion.
const path = require('path');
const { chromium } = require(path.resolve('C:/Users/Lenovo/AppData/Local/Temp/claude/D--my-web-site/22f29d05-3454-4001-a61e-e10846890fb4/scratchpad/shots/node_modules/playwright-core'));
const wait = (ms) => new Promise((r) => setTimeout(r, ms));
(async () => {
  const b = await chromium.launch({ executablePath: 'C:/Program Files/Google/Chrome/Application/chrome.exe', headless: true });
  const run = async (w, h, tag, shots, reduced = false) => {
    const ctx = await b.newContext({ viewport: { width: w, height: h }, reducedMotion: reduced ? 'reduce' : 'no-preference' });
    const p = await ctx.newPage();
    await p.goto('http://localhost:4500/d.html', { waitUntil: 'networkidle' });
    for (const [name, sel, offset] of shots) {
      await p.evaluate(([sel, offset]) => { const el = document.querySelector(sel); window.scrollTo(0, el.getBoundingClientRect().top + scrollY + offset); }, [sel, offset]);
      await wait(1600);
      await p.screenshot({ path: `lab/rest-${tag}-${name}.png` });
    }
    await ctx.close();
  };
  await run(1440, 900, 'desk', [['exp', '#experience', 250], ['about', '#about', -60], ['contact', '#contact', -60]]);
  await run(390, 844, 'phone', [['exp', '#experience', 300], ['contact', '#contact', 380]]);
  await run(1440, 900, 'reduced', [['exp', '#experience', 250]], true);
  await b.close();
})();
