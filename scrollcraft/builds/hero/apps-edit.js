// Regenerates the prototype's Projects block in d.html (and the apps.css
// slice of d.css) from the data below.
const fs = require('fs');
const { STORES, storeLink, devices } = require('./icons');
const projects = [
  {
    name: 'Stock', slug: 'stock', tint: '#E11D48', flip: false,
    desc: 'A B2B inventory management platform for businesses to track and manage their stock.',
    stack: ['Flutter', 'Firebase', 'Bloc', 'Clean Architecture', 'REST APIs'],
    platforms: 'Android · iOS', downloads: 10000, store: 'Google Play and App Store',
    play: 'https://play.google.com/store/apps/details?id=com.spark.stockclientapp', appStore: 'https://apps.apple.com/eg/app/stock-b2b/id1639101527',
    shots: [
      ['stock-home.webp', 'Stock home screen', 1147, 'SearchAppBar@13|CategoryGrid@55|CartBar@93'],
      ['stock-list.webp', 'Stock product list', 1147, 'ProductCard@22|UnitSelector@37|SectionHeader@58'],
      ['stock-3.webp', 'Stock category screen', 1147, 'SearchField@15|ProductCard@52|CartBar@93'],
    ],
  },
  {
    name: 'Albatal', slug: 'albatal', tint: '#D97706', flip: true,
    desc: 'A marketplace that connects sellers and customers, with a seller dashboard for inventory and orders.',
    stack: ['Flutter', 'Bloc', 'REST APIs', 'E-commerce', 'Seller System'],
    platforms: 'Android', downloads: 1000, store: 'Google Play',
    play: 'https://play.google.com/store/apps/details?id=com.albatal.alba', appStore: null,
    shots: [
      ['albatal.webp', 'Albatal home screen', 1300, 'Companies@22|CategoryRail@46|BottomNavigationBar@95'],
      ['albatal-2.webp', 'Albatal most sold', 1300, 'CategoryRail@15|ProductGrid@52|AddToCart@72'],
      ['albatal-3.webp', 'Albatal cart', 1300, 'CartItem@19|OrderSummary@36|CheckoutButton@81'],
    ],
  },
];

const app = (p) => `
    <article class="app${p.flip ? ' flip' : ''}" data-app>
      <div class="app-text">
        <h3>${p.name}</h3>
        <p>${p.desc}</p>
        <ul class="chips" aria-label="Stack">${p.stack.map((s, i) => `<li style="--i:${i}">${s}</li>`).join('')}</ul>
        <dl class="meta">
          <div><dt>platforms</dt><dd>${p.platforms}</dd></div>
          <div><dt>downloads</dt><dd><span data-count="${p.downloads}">${p.downloads.toLocaleString('en-US')}</span>+</dd></div>
          <div><dt>get it</dt><dd class="store-icons">${STORES[p.slug].map((s) => storeLink(s, p.name, p.shots.map((x) => x[0]), 'icon')).join('')}</dd></div>
        </dl>
        <a class="app-link" href="cs-${p.slug}.html" aria-label="Read the case study: ${p.name}">Read the case study <span aria-hidden="true">→</span></a>
      </div>
      <div class="app-stage" style="--tint: ${p.tint}">
        <span class="bg-word" aria-hidden="true">${p.name}</span>
        <div class="rigwrap">
          ${devices(p.name, p.shots.map(([src, alt, , notes]) => [src, alt, notes]), STORES[p.slug].some((s) => s.store === 'ios'), p.shots[0][2])}
          <ul class="notes" aria-hidden="true"></ul>
        </div>
        <div class="float-card" aria-hidden="true"><span class="dot"></span><span>${p.store}<b>${p.downloads.toLocaleString('en-US')}+ downloads</b></span></div>
        <div class="steps" role="group" aria-label="${p.name} screens">${p.shots.map(([, alt], i) => `<button type="button" aria-label="Show ${alt}"${i === 0 ? ' aria-current="true"' : ''}><span></span></button>`).join('')}</div>
        <p class="tap-hint" aria-hidden="true">tap or swipe the screen</p>
      </div>
    </article>`;

let h = fs.readFileSync('d.html', 'utf8');
const start = h.indexOf('<section class="section" id="projects">');
const end = h.indexOf('</section>', start) + '</section>'.length;
h = h.slice(0, start) + `<section class="section" id="projects">
  <p class="path"><b>~/</b>projects</p>
  <h2>Projects</h2>
  <div class="apps">${projects.map(app).join('')}
  </div>
</section>` + h.slice(end);
fs.writeFileSync('d.html', h);

let c = fs.readFileSync('d.css', 'utf8');
const s0 = c.indexOf('/* Projects: each app');
const s1 = c.indexOf('/* Experience:');
if (s0 < 0 || s1 < 0) throw new Error('markers not found');
c = c.slice(0, s0) + fs.readFileSync('apps.css', 'utf8') + '\n' + c.slice(s1);
fs.writeFileSync('d.css', c);
console.log('ok');
