// Regenerates the Experience and About blocks of d.html, adds Contact, the
// footer, the progress line and the scripts/styles for them. Real content
// only (from the live site's build).
const fs = require('fs');
let h = fs.readFileSync('d.html', 'utf8');

const jobs = [
  ['2025 – now', 'The First-Agency', 'Flutter Developer', ['Led the design and implementation of Tolet Mobile App', 'Added maintenance in the High-gold Mobile App']],
  ['2024 – 2025', 'Gomla', 'Flutter Developer (Part-time)', ['Enhanced the design and redesigned screens in Gomla-Mobile App', 'Reduced app load time through performance optimization using RiverPod']],
  ['2024 – 2025', 'Stock Tech', 'Flutter Developer', ['Led the design and implementation of Palleta Mobile App', 'Led design and maintenance of Stock App (B2B), achieving 10,000+ downloads', 'Delivered Tag-pharma &amp; DrugZa Mobile App', 'Reduced app load time through performance optimization using Bloc']],
  ['2023 – 2024', 'Freelance (Many Companies)', 'Flutter Developer', ['Developed and deployed 10+ cross-platform mobile applications', 'Optimized app performance through debugging and code refactoring', 'Improved user engagement through intuitive UI/UX design']],
  ['2022 – 2023', 'Innovation Company', 'Flutter Developer', ['Led design and implementation of Al-Taqwa Mobile App (1,000+ downloads)', 'Delivered Global Dent Mobile App', 'Reduced app load time through performance optimization']],
];
const title = (t) => `<h2><span class="reveal-line"><span>${t}</span></span></h2>`;

const experience = `<section class="section" id="experience">
  <p class="path"><b>~/</b>experience</p>
  ${title('Work Experience')}
  <div class="log2">${jobs.map(([when, co, role, items], k) => `
    <div class="job"><span class="when">${when}${k === 0 ? ' <span class="head">HEAD</span>' : ''}</span><h3>${co} <small>${role}</small></h3>
      <ul>${items.map((t, i) => `<li style="--i:${i}">${t}</li>`).join('')}</ul></div>`).join('')}
  </div>
</section>`;

const yaml = [
  ['c', '# skills.yaml'], ['k', 'mobile_and_ui:'], ['', '  - Flutter &amp; Dart'], ['', '  - UI/UX animations'], ['', '  - Responsive UI design'],
  ['k', 'architecture_and_state:'], ['', '  - Clean Architecture &amp; Bloc'], ['', '  - State management (Bloc, Cubit)'],
  ['k', 'backend_and_apis:'], ['', '  - Firebase &amp; REST APIs'], ['', '  - Supabase'], ['', '  - API integration (GraphQL)'],
  ['k', 'delivery:'], ['', '  - CI/CD &amp; DevOps'],
];
const about = `<section class="section" id="about">
  <p class="path"><b>~/</b>about</p>
  ${title('About Me')}
  <div class="about2">
    <p>Flutter Developer with 3+ years of experience in designing and deploying scalable, cross-platform mobile applications. Proficient in <mark>clean architecture</mark>, <mark>state management (Bloc/Provider)</mark>, and <mark>API integrations</mark>.</p>
    <div class="file">
      <div class="file-tab"><b>skills.yaml</b><span>${yaml.length} lines</span></div>
      <pre>${yaml.map(([cls, t], n) => `<span class="ln" style="--n:${n}">${cls ? `<span class="${cls}">${t}</span>` : t}${n === yaml.length - 1 ? '<span class="caret" aria-hidden="true"></span>' : ''}</span>`).join('')}</pre>
    </div>
  </div>
</section>`;

const contact = `<section class="section" id="contact">
  <p class="path"><b>~/</b>contact</p>
  ${title('Get In Touch')}
  <div class="contact2">
    <div>
      <p class="lead">Let's build something amazing together! Send a message and I'll respond as soon as possible.</p>
      <dl class="rows">
        <div class="row"><dt>email</dt><dd><a href="mailto:muhammed.adel611@gmail.com">muhammed.adel611@gmail.com</a></dd><button class="copy-btn" type="button" data-copy="muhammed.adel611@gmail.com" aria-label="Copy email address">copy</button></div>
        <div class="row"><dt>phone</dt><dd><a href="tel:+201000490576">+20 100 049 0576</a></dd><span></span></div>
        <div class="row"><dt>location</dt><dd>Cairo, Egypt</dd><span></span></div>
      </dl>
      <div class="socials"><a href="https://github.com/mohamedadel120" target="_blank" rel="noopener noreferrer">GitHub</a><a href="https://www.linkedin.com/in/mohamed-adel-9454a1183/" target="_blank" rel="noopener noreferrer">LinkedIn</a></div>
    </div>
    <div class="form">
      <div class="file-tab"><b>new_message</b><span>to: Mohamed</span></div>
      <form novalidate>
        <div class="field"><label for="f-name">name</label><input id="f-name" name="name" autocomplete="name" required></div>
        <div class="field"><label for="f-email">email</label><input id="f-email" name="email" type="email" autocomplete="email" required></div>
        <div class="field"><label for="f-msg">message</label><textarea id="f-msg" name="message" required></textarea></div>
        <button class="send" type="submit">Send Message</button>
        <p class="status" role="status"></p>
      </form>
    </div>
  </div>
</section>
<footer class="foot"><span>© 2026 Mohamed Adel</span><span>Built with <b>Dart</b> &amp; <b>Jaspr</b></span></footer>`;

const swap = (startMarker, html) => {
  const s = h.indexOf(startMarker);
  if (s < 0) throw new Error('missing ' + startMarker);
  const e = h.indexOf('</section>', s) + '</section>'.length;
  h = h.slice(0, s) + html + h.slice(e);
};
swap('<section class="section" id="experience">', experience);
swap('<section class="section" id="about">', about);
if (h.includes('<section class="section" id="contact">')) {
  const s = h.indexOf('<section class="section" id="contact">');
  const e = h.indexOf('</footer>', s) + '</footer>'.length;
  h = h.slice(0, s) + contact + h.slice(e);
} else {
  h = h.replace('<div style="height:30vh"></div>', contact);
}
// Projects title and nav targets.
h = h.replace('<h2>Projects</h2>', title('Projects'));
h = h.replace('<section class="hero" aria-labelledby="hero-title">', '<section class="hero" id="top" aria-labelledby="hero-title">');
h = h.replace('<nav aria-label="Sections"><a href="#">HOME</a>', '<nav aria-label="Sections"><a href="#top">HOME</a>');
h = h.replace('<a href="#">CONTACT</a></nav>', '<a href="#contact">CONTACT</a></nav>');
h = h.replace('<a class="btn" href="#">Get in touch</a>', '<a class="btn" href="#contact">Get in touch</a>');
if (!h.includes('rest.css')) h = h.replace('<link rel="stylesheet" href="d.css">', '<link rel="stylesheet" href="d.css">\n<link rel="stylesheet" href="rest.css">');
if (!h.includes('class="progress"')) h = h.replace('<header class="top">', '<div class="progress" aria-hidden="true"></div>\n<header class="top">');
if (!h.includes('rest.js')) h = h.replace('<script src="apps.js"></script>', '<script src="apps.js"></script>\n<script src="rest.js"></script>');
fs.writeFileSync('d.html', h);
console.log('ok');
