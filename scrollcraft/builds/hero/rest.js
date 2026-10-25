// Page-wide life for prototype D: progress line, scroll-spy nav, sections
// marked .seen once (heading reveal, skills file, underlines), the
// experience line drawn by scroll with jobs lighting up as they pass the
// middle, the email copy button and the prototype form.
(() => {
  const reduced = matchMedia('(prefers-reduced-motion: reduce)').matches;
  document.documentElement.classList.add('js');

  // Sections: .seen once a fifth is in view.
  const seen = new IntersectionObserver((entries) => {
    for (const e of entries) if (e.isIntersecting) { e.target.classList.add('seen'); seen.unobserve(e.target); }
  }, { threshold: 0.2 });
  document.querySelectorAll('.section').forEach((s) => seen.observe(s));

  // Scroll-spy: the nav marks the section holding the middle of the screen.
  // A page that names its own section (body data-page) keeps that mark.
  const fixedPage = document.body.dataset.page || document.querySelector('.top nav[data-fixed]');
  // Both navs (the pill and the phone Menu) follow; hrefs may be '#x' or '/#x'.
  const links = [...document.querySelectorAll('.top nav a')];
  const hash = (a) => '#' + (a.getAttribute('href').split('#')[1] || '');
  const spyTargets = ['#top', '#projects', '#experience', '#about', '#contact'].map((id) => [id, document.querySelector(id)]).filter(([, el]) => el);

  const log = document.querySelector('.log2');
  const jobs = [...document.querySelectorAll('.job')];
  const bar = document.querySelector('.progress');
  let queued = false;
  const update = () => {
    queued = false;
    const mid = innerHeight * 0.55;
    const max = document.documentElement.scrollHeight - innerHeight;
    bar.style.setProperty('--read', (max > 0 ? scrollY / max : 0).toFixed(4));
    let current = '#top';
    for (const [id, el] of spyTargets) if (el.getBoundingClientRect().top <= mid) current = id;
    if (!fixedPage) for (const a of links) a.classList.toggle('active', hash(a) === current);
    if (log) {
      const r = log.getBoundingClientRect();
      log.style.setProperty('--draw', reduced ? 1 : Math.max(0, Math.min(1, (mid - r.top) / r.height)).toFixed(4));
      for (const j of jobs) if (reduced || j.getBoundingClientRect().top < mid) j.classList.add('lit');
    }
  };
  addEventListener('scroll', () => { if (!queued) { queued = true; requestAnimationFrame(update); } }, { passive: true });
  addEventListener('resize', update);
  update();

  // Copy the email, with feedback on the button itself.
  for (const btn of document.querySelectorAll('[data-copy]')) {
    btn.addEventListener('click', async () => {
      try { await navigator.clipboard.writeText(btn.dataset.copy); btn.textContent = 'copied'; }
      catch { btn.textContent = 'press ⌘C'; }
      btn.classList.add('done');
      setTimeout(() => { btn.textContent = 'copy'; btn.classList.remove('done'); }, 1600);
    });
  }

  // Prototype form: shows the sending state, sends nothing.
  const form = document.querySelector('.form form');
  form?.addEventListener('submit', (e) => {
    e.preventDefault();
    const send = form.querySelector('.send'), status = form.querySelector('.status');
    if (!form.reportValidity()) return;
    send.classList.add('busy');
    status.className = 'status';
    status.textContent = '$ sending…';
    setTimeout(() => {
      send.classList.remove('busy');
      status.className = 'status ok';
      status.textContent = '✓ Prototype only: nothing was sent.';
    }, 950);
  });
})();
