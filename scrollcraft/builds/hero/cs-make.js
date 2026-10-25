// Writes cs-stock.html and cs-albatal.html: case study pages in D's
// language. Content is the live site's (overview, stack, stores, screens).
const fs = require('fs');

const { STORES, storeLink, devices } = require('./icons');

const pages = {
  stock: {
    name: 'Stock', title: 'Stock Mobile App', tint: '#E11D48',
    overview: 'A powerful B2B inventory management platform designed for businesses to efficiently track and manage their stock. Built with clean architecture and Bloc pattern for scalable state management. The app has passed 10,000+ downloads.',
    platforms: 'Android · iOS', downloads: 10000,
    stack: ['Flutter', 'Firebase', 'Bloc', 'Clean Architecture', 'REST APIs'],
    play: 'https://play.google.com/store/apps/details?id=com.spark.stockclientapp',
    appStore: 'https://apps.apple.com/eg/app/stock-b2b/id1639101527',
    store: 'Google Play and App Store', h: 1147,
    shots: [
      ['stock-home.webp', 'Home', 'SearchAppBar@13|CategoryGrid@55|CartBar@93'],
      ['stock-list.webp', 'Product list', 'ProductCard@22|UnitSelector@37|SectionHeader@58'],
      ['stock-3.webp', 'Category', 'SearchField@15|ProductCard@52|CartBar@93'],
      ['stock-drawer.webp', 'Side menu', 'UserHeader@16|DrawerMenu@38|CartBar@86'],
      ['stock-orders.webp', 'My orders', 'TabBar@15|OrderTile@28|OrderList@62'],
      ['stock-login.webp', 'Sign in', 'BrandHeader@22|PhoneField@60|SignInButton@82'],
    ],
    prev: ['Gomla Mobile App', 'http://localhost:8098/projects/gomla'],
    next: ['Albatal Mobile App', 'cs-albatal.html'],
  },
  albatal: {
    name: 'Albatal', title: 'Albatal Mobile App', tint: '#D97706',
    overview: 'A full-featured marketplace platform that connects sellers and customers seamlessly. Includes a robust seller dashboard for inventory management, order processing, and analytics, while giving customers a smooth shopping experience.',
    platforms: 'Android', downloads: 1000,
    stack: ['Flutter', 'Bloc', 'REST APIs', 'E-commerce', 'Seller System'],
    play: 'https://play.google.com/store/apps/details?id=com.albatal.alba',
    appStore: null,
    store: 'Google Play', h: 1300,
    shots: [
      ['albatal.webp', 'Home', 'Companies@22|CategoryRail@46|BottomNavigationBar@95'],
      ['albatal-2.webp', 'Most sold', 'CategoryRail@15|ProductGrid@52|AddToCart@72'],
      ['albatal-3.webp', 'Cart', 'CartItem@19|OrderSummary@36|CheckoutButton@81'],
      ['albatal-4.webp', 'Checkout', 'ProductRail@17|CartItem@43|OrderSummary@61'],
    ],
    prev: ['Stock Mobile App', 'cs-stock.html'],
    next: ['Palleta Mobile App', 'http://localhost:8098/projects/palleta'],
  },
};

const title = (t) => `<span class="reveal-line"><span>${t}</span></span>`;

const page = (slug, p) => `<!doctype html>
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
  <div class="crumbs"><a href="d.html#projects"><span aria-hidden="true">←</span> All projects</a><p class="path"><b>~/</b>projects/${slug}</p></div>
  <article class="app cs-app" data-app>
    <div class="app-text">
      <h1>${title(p.title)}</h1>
      <p>${p.overview}</p>
      <ul class="chips" aria-label="Stack">${p.stack.map((s, i) => `<li style="--i:${i}">${s}</li>`).join('')}</ul>
      <dl class="meta">
        <div><dt>platforms</dt><dd>${p.platforms}</dd></div>
        <div><dt>downloads</dt><dd><span data-count="${p.downloads}">${p.downloads.toLocaleString('en-US')}</span>+</dd></div>
      </dl>
      <div class="stores">${STORES[slug].map((s) => storeLink(s, p.name, p.shots.map((x) => x[0]), 'button')).join('')}</div>
    </div>
    <div class="app-stage" style="--tint: ${p.tint}">
      <span class="bg-word" aria-hidden="true">${p.name}</span>
      <div class="rigwrap">
        ${devices(p.name, p.shots.map(([src, cap, notes]) => [src, p.name + ': ' + cap.toLowerCase() + ' screen', notes]), STORES[slug].some((s) => s.store === 'ios'), p.h)}
        <ul class="notes" aria-hidden="true"></ul>
      </div>
      <div class="float-card" aria-hidden="true"><span class="dot"></span><span>${p.store}<b>${p.downloads.toLocaleString('en-US')}+ downloads</b></span></div>
      <div class="steps" role="group" aria-label="${p.name} screens">${p.shots.map(([, cap], i) => `<button type="button" aria-label="Show the ${cap.toLowerCase()} screen"${i === 0 ? ' aria-current="true"' : ''}><span></span></button>`).join('')}</div>
        <p class="tap-hint" aria-hidden="true">tap or swipe the screen</p>
    </div>
  </article>
</section>

<section class="section" id="screens">
  <p class="path"><b>~/</b>projects/${slug}/screens</p>
  <h2>${title('Screens')}</h2>
  <div class="rail-wrap">
    <div class="rail" tabindex="0" role="group" aria-label="${p.name} screens. Scroll sideways to browse.">${p.shots.map(([src, cap]) => `
      <figure><div class="ph"><img src="assets/${src}" alt="${p.name}: ${cap.toLowerCase()} screen" width="600" height="${p.h}" loading="lazy"></div><figcaption>${cap.toLowerCase().replace(/ /g, '_')}</figcaption></figure>`).join('')}
    </div>
    <div class="rail-nav"><button type="button" data-rail="prev" aria-label="Previous screen">←</button><button type="button" data-rail="next" aria-label="Next screen">→</button></div>
  </div>
</section>

<section class="section" id="stack">
  <p class="path"><b>~/</b>projects/${slug}/stack</p>
  <h2>${title('Built with')}</h2>
  <div class="stack2">
    <p>${p.name} runs on ${p.platforms.replace(' · ', ' and ')}. The stack below is what the app is built on.</p>
    <div class="file">
      <div class="file-tab"><b>stack.yaml</b><span>${p.stack.length + 2} lines</span></div>
      <pre><span class="ln" style="--n:0"><span class="c"># ${slug}</span></span><span class="ln" style="--n:1"><span class="k">stack:</span></span>${p.stack.map((s, i) => `<span class="ln" style="--n:${i + 2}">  - ${s}${i === p.stack.length - 1 ? '<span class="caret" aria-hidden="true"></span>' : ''}</span>`).join('')}</pre>
    </div>
  </div>
</section>

<nav class="pn" aria-label="More projects">
  <a href="${p.prev[1]}"><small>← previous</small><b>${p.prev[0]}</b></a>
  <a href="${p.next[1]}"><small>next →</small><b>${p.next[0]}</b></a>
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

for (const [slug, p] of Object.entries(pages)) fs.writeFileSync(`cs-${slug}.html`, page(slug, p));
// The home prototype's links now open these pages.
let d = fs.readFileSync('d.html', 'utf8');
d = d.replace(/href="http:\/\/localhost:8098\/projects\/(stock|albatal)"/g, 'href="cs-$1.html"');
fs.writeFileSync('d.html', d);
let a = fs.readFileSync('apps-edit.js', 'utf8');
a = a.replace('href="http://localhost:8098/projects/${p.slug}"', 'href="cs-${p.slug}.html"');
fs.writeFileSync('apps-edit.js', a);
console.log('wrote cs-stock.html, cs-albatal.html');
