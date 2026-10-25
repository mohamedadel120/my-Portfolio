// Writes a.html, b.html and c.html from one page; only data-moment differs.
const fs = require('fs');
const moments = { a: 'A. Apps rise from the headline', b: 'B. One phone comes closer', c: 'C. Calm depth' };

const page = (m) => `<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Hero ${m.toUpperCase()}</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Geist:wght@400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="hero.css">
<link rel="preload" as="image" href="assets/plate.webp" media="(min-width: 900px)">
<link rel="preload" as="image" href="assets/plate-m.webp" media="(max-width: 899px)">
</head>
<body>
<header class="top">
  <a href="#"><img src="assets/logo.png" alt="Mohamed Adel, home" width="44" height="44"></a>
  <nav aria-label="Sections"><a href="#">HOME</a><a href="#projects">PROJECTS</a><a href="#">EXPERIENCE</a><a href="#">ABOUT</a><a href="#">CONTACT</a></nav>
  <a class="cv" href="#">Download CV</a>
</header>

<main>
<section class="hero" id="hero" data-moment="${m}" aria-labelledby="hero-title">
  <div class="plane plate" aria-hidden="true">
    <picture>
      <source media="(max-width: 899px)" srcset="assets/plate-m.webp">
      <img src="assets/plate.webp" alt="" width="2400" height="1350" fetchpriority="high">
    </picture>
    <span class="shadow back"></span><span class="shadow front"></span><span class="shadow side"></span>
  </div>

  <div class="copy-ground" aria-hidden="true"></div>
  <div class="copy">
    <p class="eyebrow">Flutter developer, Cairo</p>
    <h1 id="hero-title">Flutter apps people actually download.</h1>
    <p class="sub">3+ years shipping Android and iOS apps, from first screen to store listing.</p>
    <div class="actions">
      <a class="btn primary" href="#projects">See the apps</a>
      <a class="btn" href="#">Get in touch</a>
    </div>
    <ul class="proof" aria-label="Downloads">
      <li>Gomla <b>10,000+</b></li><li>Stock <b>10,000+</b></li><li>Albatal <b>1,000+</b></li>
    </ul>
  </div>

  <div class="plane phones" aria-hidden="true">
    <div class="phone back"><img src="assets/stock-list.webp" alt="" width="600" height="1147"></div>
    <div class="phone side"><img src="assets/stock-home.webp" alt="" width="600" height="1147"></div>
    <div class="phone front"><img src="assets/albatal.webp" alt="" width="600" height="1300"></div>
  </div>

  <div class="plane branch" aria-hidden="true"><img src="assets/branch.webp" alt="" width="616" height="760"></div>
</section>

<section class="next" id="projects">
  <h2>Projects</h2>
  <p>The projects section starts here on the real site. This block only shows how the hero hands off to it.</p>
</section>
</main>

<nav class="switch" aria-label="Prototype">
${Object.keys(moments).map((k) => `  <a href="${k}.html"${k === m ? ' aria-current="page"' : ''} title="${moments[k]}">${k.toUpperCase()}</a>`).join('\n')}
</nav>
<script src="hero.js"></script>
</body>
</html>
`;

for (const m of Object.keys(moments)) fs.writeFileSync(`${m}.html`, page(m));
console.log('wrote', Object.keys(moments).map((m) => m + '.html').join(', '));
