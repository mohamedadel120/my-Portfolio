// Delivery files: plate (desktop + phone crop), branch with alpha, and the
// first real screenshot of Gomla, Stock and Albatal, all as WebP.
// Usage: node export.js   (run from this folder)
const fs = require('fs');
const path = require('path');
const { chromium } = require(path.resolve('C:/Users/Lenovo/AppData/Local/Temp/claude/D--my-web-site/22f29d05-3454-4001-a61e-e10846890fb4/scratchpad/shots/node_modules/playwright-core'));

const local = (f) => 'data:image/png;base64,' + fs.readFileSync(f).toString('base64');
const jobs = [
  // [source, out, width, crop: [x, y, w, h] as shares of the source, quality]
  [local('out/plate.png'), 'assets/plate.webp', 2400, null, 0.8],
  // Phone: the lit right half of the desk and wall, portrait.
  [local('out/plate.png'), 'assets/plate-m.webp', 900, [0.42, 0, 0.32, 1], 0.8],
  [local('assets/branch.png'), 'assets/branch.webp', 1100, null, 0.85],
  // Real app screens (Gomla's gallery has only marketing art). Android
  // status and navigation bars are trimmed off the Stock screens.
  ['https://i.ibb.co/cKZ2k8cY/5a024da21f8b.webp', 'assets/stock-home.webp', 600, [0, 0.035, 1, 0.905], 0.85],
  ['https://i.ibb.co/2wWrdWb/ba6238199736.webp', 'assets/stock-list.webp', 600, [0, 0.035, 1, 0.905], 0.85],
  ['https://i.ibb.co/SwrrbHQ8/fbb0d3e111d5.png', 'assets/albatal.webp', 600, null, 0.85],
  // More real screens, so each project's phone can play through its app.
  ['https://i.ibb.co/JwV1bLNH/afa9d60e5465.png', 'assets/albatal-2.webp', 600, null, 0.85],
  ['https://i.ibb.co/jkhzYM3H/64a1cef6141e.png', 'assets/albatal-3.webp', 600, null, 0.85],
  ['https://i.ibb.co/WZ7wd59/1bab37a236ae.webp', 'assets/stock-3.webp', 600, [0, 0.035, 1, 0.905], 0.85],
  // Case study screens. The Stock account screen (9b7fbb.. is login; the
  // account one, ebd76a.., shows a phone number) is left out on purpose.
  ['https://i.ibb.co/vC6MPSxJ/ae1eed6af402.webp', 'assets/stock-drawer.webp', 600, [0, 0.035, 1, 0.905], 0.85],
  ['https://i.ibb.co/C3d3t5wS/9b7fbb069319.webp', 'assets/stock-login.webp', 600, [0, 0.035, 1, 0.905], 0.85],
  ['https://i.ibb.co/j994ycKn/e65ee03dcd20.webp', 'assets/stock-orders.webp', 600, [0, 0.035, 1, 0.905], 0.85],
  ['https://i.ibb.co/kgm7XBL8/8dc9bbc97f80.png', 'assets/albatal-4.webp', 600, null, 0.85],
  // App icons, from each store's own listing (for the store previews).
  ['https://play-lh.googleusercontent.com/5u1uLgVx2f_yO7kQ5ju4kRoi5JFvywAYUwznUA4IMINraDvTZVAQWhmDZ2KSp8HwIP2Tng2FqQRGtl_UAAAN8A=s256', 'assets/icon-stock-play.webp', 160, null, 0.9],
  ['https://is1-ssl.mzstatic.com/image/thumb/Purple221/v4/62/e1/3f/62e13fea-3688-c3fd-8047-153d31e722f7/AppIcon-1x_U007emarketing-0-8-0-85-220-0.png/256x256bb.png', 'assets/icon-stock-ios.webp', 160, null, 0.9],
  ['https://play-lh.googleusercontent.com/6onI2rqXSz6zymVs9pAroFznhzXFyFGsKysxhRzdcOSG5H-wCKT_UEip6hy7xSeWFWf5PcJlOEyv3ruBSrm7uQ=s256', 'assets/icon-albatal-play.webp', 160, null, 0.9],
];

(async () => {
  const browser = await chromium.launch({ executablePath: 'C:/Program Files/Google/Chrome/Application/chrome.exe', headless: true });
  const page = await browser.newPage();
  for (const [src, out, width, crop, q] of jobs) {
    const res = await page.evaluate(async ({ src, width, crop, q }) => {
      const blob = await (await fetch(src)).blob();
      const bmp = await createImageBitmap(blob);
      const [sx, sy, sw, sh] = crop ? [crop[0] * bmp.width, crop[1] * bmp.height, crop[2] * bmp.width, crop[3] * bmp.height] : [0, 0, bmp.width, bmp.height];
      const w = Math.min(width, Math.round(sw));
      const h = Math.round(sh * (w / sw));
      const c = document.createElement('canvas');
      c.width = w; c.height = h;
      c.getContext('2d').drawImage(bmp, sx, sy, sw, sh, 0, 0, w, h);
      return { url: c.toDataURL('image/webp', q), w, h, srcW: bmp.width, srcH: bmp.height };
    }, { src, width, crop, q });
    const buf = Buffer.from(res.url.split(',')[1], 'base64');
    fs.writeFileSync(out, buf);
    console.log(`${out}  ${res.w}x${res.h}  ${Math.round(buf.length / 1024)} KB  (source ${res.srcW}x${res.srcH})`);
  }
  await browser.close();
})();
