// Bundles the tested prototype into the site's static files:
//   jaspr_site/web/d/d.css  = d.css (minus the old Experience/About blocks
//                             and the prototype switcher) + rest.css + cs.css
//   jaspr_site/web/d/d.js   = hero.js + apps.js + rest.js + cs.js
// The contact form posts to Web3Forms (key and recipient come from data-*
// attributes the server renders), replacing the prototype's fake send.
const fs = require('fs');
const OUT = 'D:/my_web_site/jaspr_site/web/d';
fs.mkdirSync(OUT, { recursive: true });

let d = fs.readFileSync('d.css', 'utf8');
const cut = (from, to) => {
  const a = d.indexOf(from);
  if (a < 0) return;
  const b = to ? d.indexOf(to, a) : d.length;
  d = d.slice(0, a) + (b < 0 ? '' : d.slice(b));
};
cut('/* Experience: the career as a log', '\n.switch');
cut('.switch {', '\n.switch a[aria-current="page"]');
d = d.replace(/\.switch a\[aria-current="page"\][^\n]*\n/, '').replace(/\.switch[^\n]*\n/g, '');
const css = [
  '/* Design D. Built from the scroll-craft prototype (scrollcraft/builds/hero). */',
  d, fs.readFileSync('rest.css', 'utf8'), fs.readFileSync('cs.css', 'utf8'),
].join('\n');
fs.writeFileSync(`${OUT}/d.css`, css);

let rest = fs.readFileSync('rest.js', 'utf8');
const formStart = rest.indexOf('  // Prototype form:');
const formEnd = rest.indexOf('})();', formStart);
rest = rest.slice(0, formStart) + `  // The contact form posts to Web3Forms, the same service the site used
  // before. Errors keep what the visitor typed and say what happened.
  const form = document.querySelector('.form form');
  form?.addEventListener('submit', async (e) => {
    e.preventDefault();
    const send = form.querySelector('.send'), status = form.querySelector('.status');
    if (!form.reportValidity()) return;
    const data = new FormData(form);
    send.classList.add('busy');
    send.disabled = true;
    status.className = 'status';
    status.textContent = '$ sending…';
    try {
      const res = await fetch('https://api.web3forms.com/submit', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', Accept: 'application/json' },
        body: JSON.stringify({
          access_key: form.dataset.key,
          subject: 'Portfolio Contact: ' + data.get('name'),
          from_name: data.get('name'),
          from_email: data.get('email'),
          message: data.get('message'),
          to: form.dataset.to,
        }),
      });
      const body = await res.json().catch(() => ({}));
      if (!res.ok || !body.success) throw new Error(body.message || 'not sent');
      form.reset();
      status.className = 'status ok';
      status.textContent = '✓ Sent. I will get back to you soon.';
    } catch {
      status.className = 'status err';
      status.textContent = '✕ Not sent. Please try again, or email me directly.';
    } finally {
      send.classList.remove('busy');
      send.disabled = false;
    }
  });
` + rest.slice(formEnd);
const js = ['// Design D. Built from the scroll-craft prototype (scrollcraft/builds/hero).',
  fs.readFileSync('hero.js', 'utf8'), fs.readFileSync('apps.js', 'utf8'), rest, fs.readFileSync('cs.js', 'utf8')].join('\n');
fs.writeFileSync(`${OUT}/d.js`, js);
console.log('d.css', Math.round(css.length / 1024), 'KB; d.js', Math.round(js.length / 1024), 'KB; switch left:', css.includes('.switch'), '; old log left:', css.includes('.entry {'));
