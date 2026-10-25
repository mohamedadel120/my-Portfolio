// Contact sheet of candidate screenshots. Usage: node sheet.js out.png url-or-file...
const fs = require('fs');
const path = require('path');
const { chromium } = require(path.resolve('C:/Users/Lenovo/AppData/Local/Temp/claude/D--my-web-site/22f29d05-3454-4001-a61e-e10846890fb4/scratchpad/shots/node_modules/playwright-core'));
const [out, ...srcs] = process.argv.slice(2);
(async () => {
  const b = await chromium.launch({ executablePath: 'C:/Program Files/Google/Chrome/Application/chrome.exe', headless: true });
  const p = await b.newPage({ viewport: { width: 1400, height: 520 } });
  const imgs = srcs.map((s, i) => `<figure style="margin:0"><img style="height:460px;border:1px solid #ccc" src="${s.startsWith('http') ? s : 'data:image/webp;base64,' + fs.readFileSync(s).toString('base64')}"><figcaption style="font:14px sans-serif">${i + 1}</figcaption></figure>`).join('');
  await p.setContent(`<body style="margin:8px;display:flex;gap:8px">${imgs}</body>`);
  await p.waitForTimeout(2500);
  await p.screenshot({ path: out });
  await b.close();
})();
