// Builds the full-data prototype: the Projects block of d.html (every
// project) and one case study page per project. Run after export-all.js.
const fs = require('fs');
const { appRow, casePage } = require('./render');
const projects = require('./data/full');

let h = fs.readFileSync('d.html', 'utf8');
const start = h.indexOf('<section class="section" id="projects">');
const end = h.indexOf('</section>', start) + '</section>'.length;
h = h.slice(0, start) + `<section class="section" id="projects">
  <p class="path"><b>~/</b>projects</p>
  <h2><span class="reveal-line"><span>Projects</span></span></h2>
  <div class="apps">${projects.map(appRow).join('')}
  </div>
</section>` + h.slice(end);
fs.writeFileSync('d.html', h);

projects.forEach((p, i) => {
  const prev = projects[(i - 1 + projects.length) % projects.length];
  const next = projects[(i + 1) % projects.length];
  fs.writeFileSync(`cs-${p.slug}.html`, casePage(p, prev, next));
});
console.log('home:', projects.length, 'projects; case studies:', projects.map((p) => `cs-${p.slug}.html`).join(', '));

// d.css carries a copy of apps.css (between the Projects and Experience
// comments); keep it in step.
let c = fs.readFileSync('d.css', 'utf8');
const s0 = c.indexOf('/* Projects: each app');
const s1 = c.indexOf('/* Experience:');
if (s0 < 0 || s1 < 0) throw new Error('d.css markers not found');
c = c.slice(0, s0) + fs.readFileSync('apps.css', 'utf8') + '\n' + c.slice(s1);
fs.writeFileSync('d.css', c);
console.log('d.css synced with apps.css');
