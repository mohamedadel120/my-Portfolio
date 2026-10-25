// Markup for a project's living stage, its home row and its case study page.
// Used by build.js for every project in data/full.js.
const { STORES, storeLink } = require('./icons');
const M = require('./data/manifest.json');
const size = (f) => M[f] || [600, 1200];
const img = (f, alt, cls = '', extra = '') => `<img${cls ? ` class="${cls}"` : ''} src="assets/${f}" alt="${alt}" width="${size(f)[0]}" height="${size(f)[1]}"${extra}>`;
const lower = (s) => s.charAt(0).toLowerCase() + s.slice(1);

// The devices on the stage.
//  screens + an App Store listing: Android in front, the iPhone behind on the
//    same screen; choosing it swaps them.
//  screens, Android only: the phone behind shows the next screen.
//  art: store artwork in a plain frame, no device and no device claims.
//  video: the screen recording, playing in the phone; no phone behind.
const devices = (p) => {
  const hasIos = STORES[p.slug].some((s) => s.store === 'ios');
  if (p.mode === 'video') {
    return `<div class="app-phone dev android" role="button" tabindex="0" aria-label="${p.name}: pause or play the recording"><span class="dev-tag" aria-hidden="true">screen recording</span>
            <div class="frames"><video class="frame on" src="assets/${p.video}" muted loop playsinline preload="metadata" aria-label="${p.name} screen recording"></video></div>
          </div>`;
  }
  const kind = p.mode === 'art' ? 'art' : 'android';
  const ghost = p.mode === 'screens' && hasIos
    ? `<div class="ghost dev ios" role="button" tabindex="0" aria-label="Show ${p.name} on iPhone" data-swap><span class="dev-tag" aria-hidden="true">iPhone</span>${img(p.shots[0][0], '')}</div>`
    : `<div class="ghost dev ${kind}" role="button" tabindex="0" aria-label="${p.name}: show the next ${p.mode === 'art' ? 'artwork' : 'screen'}">${img(p.shots[1][0], '', '', ' loading="lazy"')}</div>`;
  // The device tag names a platform only when the project lists one.
  const tag = p.mode === 'art' ? 'store artwork' : p.platforms.includes('Android') ? 'Android' : 'preview';
  const phone = `<div class="app-phone dev ${kind}" role="button" tabindex="0" aria-label="${p.name}: show the next ${p.mode === 'art' ? 'artwork' : 'screen'}"><span class="dev-tag" aria-hidden="true">${tag}</span>
            <div class="frames">${p.shots.map(([f, cap, notes], i) => img(f, `${p.name}: ${lower(cap)}${p.mode === 'art' ? '' : ' screen'}`, `frame${i === 0 ? ' on' : ''}`, `${i ? ' loading="lazy"' : ''} data-notes="${notes}"`)).join('')}</div>
          </div>`;
  return ghost + '\n          ' + phone;
};

const floatCard = (p) => {
  const stores = STORES[p.slug].map((s) => s.label).join(' and ');
  const line = p.meta.downloads ? `${p.meta.downloads.toLocaleString('en-US')}+ downloads` : p.meta.status || (stores ? 'Live' : '');
  if (!line) return '';
  return `<div class="float-card" aria-hidden="true"><span class="dot"></span><span>${stores ? `On ${stores}` : p.name}<b>${line}</b></span></div>`;
};

const stage = (p) => `<div class="app-stage" style="--tint: ${p.tint}">
        <span class="bg-word" aria-hidden="true">${p.name}</span>
        <div class="rigwrap">
          ${devices(p)}
          <ul class="notes" aria-hidden="true"></ul>
        </div>
        ${floatCard(p)}
        ${p.shots.length > 1 ? `<div class="steps" role="group" aria-label="${p.name} ${p.mode === 'art' ? 'artwork' : 'screens'}">${p.shots.map(([, cap], i) => `<button type="button" aria-label="Show ${lower(cap)}"${i === 0 ? ' aria-current="true"' : ''}><span></span></button>`).join('')}</div>` : ''}
        <p class="tap-hint" aria-hidden="true">${p.mode === 'video' ? 'tap to pause or play' : 'tap or swipe the screen'}</p>
      </div>`;

const meta = (p, icons) => `<dl class="meta">
          ${p.platforms ? `<div><dt>platforms</dt><dd>${p.platforms}</dd></div>` : ''}
          ${p.meta.downloads ? `<div><dt>downloads</dt><dd><span data-count="${p.meta.downloads}">${p.meta.downloads.toLocaleString('en-US')}</span>+</dd></div>` : ''}
          ${p.meta.status ? `<div><dt>status</dt><dd>${p.meta.status}</dd></div>` : ''}
          ${icons && STORES[p.slug].length ? `<div><dt>get it</dt><dd class="store-icons">${STORES[p.slug].map((s) => storeLink(s, p.name, p.shots.map((x) => x[0]), 'icon')).join('')}</dd></div>` : ''}
        </dl>`;

const chips = (p) => `<ul class="chips" aria-label="Stack">${p.stack.map((s, i) => `<li style="--i:${i}">${s}</li>`).join('')}</ul>`;

exports.appRow = (p, i) => `
    <article class="app${i % 2 ? ' flip' : ''}" data-app>
      <div class="app-text">
        <h3>${p.name}</h3>
        <p class="clamp">${p.overview}</p>
        ${chips(p)}
        ${meta(p, true)}
        <a class="app-link" href="cs-${p.slug}.html" aria-label="Read the case study: ${p.name}">Read the case study <span aria-hidden="true">→</span></a>
      </div>
      ${stage(p)}
    </article>`;

const title = (t) => `<span class="reveal-line"><span>${t}</span></span>`;

exports.casePage = (p, prev, next) => `<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${p.title} case study</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Geist:wght@400;500;600&family=Geist+Mono:wght@400;500&display=swap" rel="stylesheet">
<link rel="stylesheet" href="d.css">
<link rel="stylesheet" href="rest.css">
<link rel="stylesheet" href="cs.css">
</head>
<body data-page="projects">
<div class="progress" aria-hidden="true"></div>
<header class="top">
  <a href="d.html#top"><img src="assets/logo.png" alt="Mohamed Adel, home" width="44" height="44"></a>
  <nav aria-label="Sections"><a href="d.html#top">HOME</a><a href="d.html#projects" class="active" aria-current="page">PROJECTS</a><a href="d.html#experience">EXPERIENCE</a><a href="d.html#about">ABOUT</a><a href="d.html#contact">CONTACT</a></nav>
  <a class="cv" href="#">Download CV</a>
</header>

<main>
<section class="section cs-hero" id="top">
  <div class="crumbs"><a href="d.html#projects"><span aria-hidden="true">←</span> All projects</a><p class="path"><b>~/</b>projects/${p.slug}</p></div>
  <article class="app cs-app" data-app>
    <div class="app-text">
      <h1>${title(p.title)}</h1>
      <p>${p.overview}</p>
      ${chips(p)}
      ${meta(p, false)}
      ${STORES[p.slug].length ? `<div class="stores">${STORES[p.slug].map((s) => storeLink(s, p.name, p.shots.map((x) => x[0]), 'button')).join('')}</div>` : ''}
    </div>
    ${stage(p)}
  </article>
</section>
${p.shots.length ? `
<section class="section" id="screens">
  <p class="path"><b>~/</b>projects/${p.slug}/${p.mode === 'art' ? 'artwork' : 'screens'}</p>
  <h2>${title(p.mode === 'art' ? 'Store artwork' : 'Screens')}</h2>
  <div class="rail-wrap">
    <div class="rail${p.mode === 'art' ? ' art' : ''}" tabindex="0" role="group" aria-label="${p.name} ${p.mode === 'art' ? 'artwork' : 'screens'}. Scroll sideways to browse.">${p.shots.map(([f, cap]) => `
      <figure><div class="ph">${img(f, `${p.name}: ${lower(cap)}`, '', ' loading="lazy"')}</div><figcaption>${lower(cap).replace(/ /g, '_')}</figcaption></figure>`).join('')}
    </div>
    <div class="rail-nav"><button type="button" data-rail="prev" aria-label="Previous">←</button><button type="button" data-rail="next" aria-label="Next">→</button></div>
  </div>
</section>` : ''}

<section class="section" id="stack">
  <p class="path"><b>~/</b>projects/${p.slug}/stack</p>
  <h2>${title('Built with')}</h2>
  <div class="stack2">
    <p>${p.platforms ? `${p.name} runs on ${p.platforms.replace(' · ', ' and ')}. ` : ''}The stack below is what the app is built on.</p>
    <div class="file">
      <div class="file-tab"><b>stack.yaml</b><span>${p.stack.length + 2} lines</span></div>
      <pre><span class="ln" style="--n:0"><span class="c"># ${p.slug}</span></span><span class="ln" style="--n:1"><span class="k">stack:</span></span>${p.stack.map((s, i) => `<span class="ln" style="--n:${i + 2}">  - ${s}${i === p.stack.length - 1 ? '<span class="caret" aria-hidden="true"></span>' : ''}</span>`).join('')}</pre>
    </div>
  </div>
</section>

<nav class="pn" aria-label="More projects">
  <a href="cs-${prev.slug}.html"><small>← previous</small><b>${prev.title}</b></a>
  <a href="cs-${next.slug}.html"><small>next →</small><b>${next.title}</b></a>
</nav>

<section class="section cs-close">
  <h2>${title('Have an app in mind?')}</h2>
  <p>Tell me about it, and we can talk about how to build it for Android and iOS.</p>
  <a class="btn primary" href="d.html#contact">Let's build yours</a>
</section>
</main>
<footer class="foot"><span>© 2026 Mohamed Adel</span><span>Built with <b>Dart</b> &amp; <b>Jaspr</b></span></footer>

<script src="apps.js"></script>
<script src="rest.js"></script>
<script src="cs.js"></script>
</body>
</html>
`;
