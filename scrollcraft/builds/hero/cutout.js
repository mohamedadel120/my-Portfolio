// Cut the olive branch out of out/fore2.png into a real alpha PNG.
// Keyed by distance from the pure white background, so a
// soft alpha follows the leaf edges. Only the right side of the frame is kept.
// Usage: node cutout.js   (run from this folder; needs playwright-core)
const fs = require('fs');
const path = require('path');
const { chromium } = require(path.resolve('C:/Users/Lenovo/AppData/Local/Temp/claude/D--my-web-site/22f29d05-3454-4001-a61e-e10846890fb4/scratchpad/shots/node_modules/playwright-core'));
(async () => {
  const src = 'data:image/png;base64,' + fs.readFileSync('out/fore2.png').toString('base64');
  const browser = await chromium.launch({ executablePath: 'C:/Program Files/Google/Chrome/Application/chrome.exe', headless: true });
  const page = await browser.newPage();
  const out = await page.evaluate(async (src) => {
    const img = new Image();
    img.src = src;
    await img.decode();
    const c = document.createElement('canvas');
    c.width = img.width; c.height = img.height;
    const x = c.getContext('2d');
    x.drawImage(img, 0, 0);
    const d = x.getImageData(0, 0, c.width, c.height);
    const p = d.data;
    const keepFrom = c.width * 0.55, fade = c.width * 0.05;
    for (let i = 0; i < p.length; i += 4) {
      const px = (i / 4) % c.width;
      const r = p[i], g = p[i + 1], b = p[i + 2];
      const lum = (r + g + b) / 3;
      const ink = Math.min(1, Math.max(0, (246 - Math.min(r, g, b)) / 34));
      
      const side = Math.min(1, Math.max(0, (px - keepFrom) / fade));
      p[i + 3] = Math.round(255 * ink * side);
    }
    x.putImageData(d, 0, 0);
    // Keep only the right 45%, at half size: it is blurred on the page anyway.
    const crop = document.createElement('canvas');
    const cx = Math.round(c.width * 0.55);
    crop.width = Math.round((c.width - cx) / 2); crop.height = Math.round(c.height / 2);
    crop.getContext('2d').drawImage(c, cx, 0, c.width - cx, c.height, 0, 0, crop.width, crop.height);
    return crop.toDataURL('image/png');
  }, src);
  fs.writeFileSync('assets/branch.png', Buffer.from(out.split(',')[1], 'base64'));
  // A check image: the cutout on teal, so halos and leftovers show.
  await page.setContent(`<body style="margin:0;background:#0E7490"><img src="${out}" style="display:block;width:100%"></body>`);
  await page.setViewportSize({ width: 1231, height: 760 });
  await page.screenshot({ path: 'out/branch-check.png' });
  await browser.close();
})();
