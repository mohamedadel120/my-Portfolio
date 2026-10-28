// Design D. Built from the scroll-craft prototype (scrollcraft/builds/hero).
// Writes --p (0 at the top, 1 once 60% of the hero has scrolled past) and, on a
// fine pointer, --mx / --my (-1..1) for a small pointer drift. One rAF per
// frame at most; nothing runs while the hero is off screen or when the
// visitor asked for reduced motion.
(() => {
  const hero = document.querySelector('.hero');
  if (!hero || matchMedia('(prefers-reduced-motion: reduce)').matches) return;
  let queued = false, visible = true;
  const update = () => {
    queued = false;
    // The moment finishes in the first 60% of the hero, while it is still in view.
    const p = Math.min(1, Math.max(0, window.scrollY / (hero.offsetHeight * 0.6)));
    hero.style.setProperty('--p', p.toFixed(4));
  };
  const queue = () => { if (!queued && visible) { queued = true; requestAnimationFrame(update); } };
  new IntersectionObserver(([e]) => { visible = e.isIntersecting; if (visible) queue(); }).observe(hero);
  addEventListener('scroll', queue, { passive: true });
  addEventListener('resize', queue);
  update();
  if (matchMedia('(hover: hover) and (pointer: fine)').matches) {
    hero.addEventListener('pointermove', (e) => {
      const r = hero.getBoundingClientRect();
      hero.style.setProperty('--mx', (((e.clientX - r.left) / r.width) * 2 - 1).toFixed(3));
      hero.style.setProperty('--my', (((e.clientY - r.top) / r.height) * 2 - 1).toFixed(3));
    });
  }
})();

// The living apps section. While an app is in view its phone swipes through
// the real screens; each screen brings its own inspector labels (from the
// frame's data-notes, "Label@y%|..."), the phone behind shows the next one,
// the downloads count up once, and scroll writes --s (-1..1) so the planes
// move at different rates. A fine pointer tilts the phone and pauses it.
// Reduced motion: no autoplay, tilt, counting or scroll drift; the step
// buttons still switch screens and the labels still follow.
(() => {
  const reduced = matchMedia('(prefers-reduced-motion: reduce)').matches;
  const finePointer = matchMedia('(hover: hover) and (pointer: fine)').matches;
  const DWELL = 3200;
  document.documentElement.classList.add('js');
  const apps = [...document.querySelectorAll('[data-app]')];

  for (const app of apps) {
    // One project with unexpected data must not stop the others: if its
    // setup fails, it is shown as is (phone visible, no motion).
    try {
    const frames = [...app.querySelectorAll('.frame')];
    const steps = [...app.querySelectorAll('.steps button')];
    const phone = app.querySelector('.app-phone');
    const ghostEl = app.querySelector('.ghost');
    const ghost = ghostEl?.querySelector('img');
    // With an iPhone version the phone behind is that iPhone, on the same
    // screen; otherwise it is the next screen on the same Android device.
    const swaps = !!ghostEl?.hasAttribute('data-swap');
    const rig = app.querySelector('.rigwrap');
    const notes = app.querySelector('.notes');
    const counter = app.querySelector('[data-count]');
    let index = 0, timer = null, visible = false, hovered = false, counted = false;
    app.style.setProperty('--dwell', DWELL + 'ms');

    // A screen recording instead of screens: it plays while in view (unless
    // the visitor asked for reduced motion), and a tap pauses or plays it.
    const video = app.querySelector('video.frame');
    if (video) {
      let userPaused = reduced;
      const sync = () => { if (visible && !userPaused) video.play().catch(() => {}); else video.pause(); };
      new IntersectionObserver(([e]) => {
        visible = e.isIntersecting;
        if (visible) { app.classList.add('in'); setTimeout(() => app.classList.add('settled'), 950); }
        sync();
      }, { threshold: 0.3 }).observe(app);
      const toggle = () => { userPaused = !userPaused; sync(); };
      phone.addEventListener('click', toggle);
      phone.addEventListener('keydown', (e) => { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); toggle(); } });
      continue;
    }

    const label = (i) => {
      notes.replaceChildren(...(frames[i].dataset.notes || '').split('|').filter(Boolean).map((n, k) => {
        const [text, y] = n.split('@');
        const li = document.createElement('li');
        li.className = 'note ' + (k % 2 ? 'r' : 'l');
        li.style.setProperty('--y', y + '%');
        li.style.setProperty('--k', k);
        li.innerHTML = '<b></b><i></i>';
        li.firstChild.textContent = text;
        return li;
      }));
      if (ghost) ghost.src = frames[swaps ? i : (i + 1) % frames.length].src;
    };

    // Bring the phone behind to the front: Android and iPhone trade places.
    const swap = () => {
      const front = phone.classList.contains('ios') ? 'ios' : 'android';
      const back = front === 'ios' ? 'android' : 'ios';
      phone.classList.replace(front, back);
      ghostEl.classList.replace(back, front);
      const names = { ios: 'iPhone', android: 'Android' };
      phone.querySelector('.dev-tag').textContent = names[back];
      ghostEl.querySelector('.dev-tag').textContent = names[front];
      ghostEl.setAttribute('aria-label', `Show ${app.querySelector('h3, h1').textContent.trim()} on ${names[front]}`);
      if (!reduced) {
        rig.classList.remove('swapping');
        void rig.offsetWidth;
        rig.classList.add('swapping');
        setTimeout(() => rig.classList.remove('swapping'), 600);
      }
      schedule();
    };
    const pressGhost = () => (swaps ? swap() : show((index + 1) % frames.length));
    ghostEl?.addEventListener('click', pressGhost);
    ghostEl?.addEventListener('keydown', (e) => { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); pressGhost(); } });

    // A click on a store preview opens that store, like its icon. When it
    // opens, it shifts sideways (--dx) to stay 12 px inside the viewport.
    for (const wrap of app.querySelectorAll('.peek-wrap')) {
      const peek = wrap.querySelector('.peek');
      // A store link without listing data has no preview card.
      if (!peek) continue;
      peek.addEventListener('click', () => wrap.querySelector('a').click());
      const fit = () => requestAnimationFrame(() => {
        peek.style.setProperty('--dx', '0px');
        const r = peek.getBoundingClientRect();
        if (!r.width) return;
        const vw = document.documentElement.clientWidth;
        const dx = r.left < 12 ? 12 - r.left : r.right > vw - 12 ? vw - 12 - r.right : 0;
        peek.style.setProperty('--dx', dx + 'px');
      });
      wrap.addEventListener('pointerenter', fit);
      wrap.addEventListener('focusin', fit);
    }

    const show = (next) => {
      if (next === index) return;
      const old = frames[index];
      old.classList.remove('on');
      old.classList.add('out');
      setTimeout(() => old.classList.remove('out'), 520);
      frames[next].classList.add('on');
      steps[index].removeAttribute('aria-current');
      steps[next].setAttribute('aria-current', 'true');
      index = next;
      label(index);
      if (!reduced) {
        // A small swipe of the hand: the phone leans into the change.
        phone.style.setProperty('--nudge', '-10px');
        setTimeout(() => phone.style.setProperty('--nudge', '0px'), 220);
      }
      schedule();
    };
    const schedule = () => {
      clearTimeout(timer);
      if (reduced || !visible || hovered) return;
      timer = setTimeout(() => show((index + 1) % frames.length), DWELL);
    };
    steps.forEach((b, i) => b.addEventListener('click', () => show(i)));
    label(0);

    // Use it like the app: tap for the next screen (a ripple marks the
    // touch), swipe sideways for next or previous, Enter or Space likewise.
    const step = (dir) => show((index + dir + frames.length) % frames.length);
    let downX = null, downY = null;
    phone.addEventListener('pointerdown', (e) => { downX = e.clientX; downY = e.clientY; });
    phone.addEventListener('pointerup', (e) => {
      if (downX === null) return;
      const dx = e.clientX - downX, dy = e.clientY - downY;
      downX = null;
      if (Math.abs(dx) > 40 && Math.abs(dx) > Math.abs(dy)) { step(dx < 0 ? 1 : -1); return; }
      if (Math.abs(dx) > 10 || Math.abs(dy) > 10) return;
      const r = phone.getBoundingClientRect();
      const tap = document.createElement('span');
      tap.className = 'tap';
      tap.style.left = (e.clientX - r.left) + 'px';
      tap.style.top = (e.clientY - r.top) + 'px';
      phone.append(tap);
      setTimeout(() => tap.remove(), 500);
      step(1);
    });
    phone.addEventListener('pointercancel', () => { downX = null; });
    phone.addEventListener('keydown', (e) => {
      if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); step(1); }
      else if (e.key === 'ArrowRight') step(1);
      else if (e.key === 'ArrowLeft') step(-1);
    });

    const count = () => {
      if (counted || !counter) return;
      counted = true;
      if (reduced) return;
      const target = Number(counter.dataset.count);
      const t0 = performance.now(), dur = 1100;
      const tick = (t) => {
        const k = Math.min(1, (t - t0) / dur);
        counter.textContent = Math.round(target * (1 - Math.pow(1 - k, 3))).toLocaleString('en-US');
        if (k < 1) requestAnimationFrame(tick);
      };
      requestAnimationFrame(tick);
    };

    new IntersectionObserver(([e]) => {
      visible = e.isIntersecting;
      app.classList.toggle('offscreen', !visible);
      if (visible) {
        app.classList.add('in');
        setTimeout(() => app.classList.add('settled'), 950);
        count();
      }
      schedule();
    }, { threshold: 0.3 }).observe(app);

    const stage = app.querySelector('.app-stage');
    stage.addEventListener('pointerenter', () => { hovered = true; app.classList.add('paused'); schedule(); });
    stage.addEventListener('pointerleave', () => {
      hovered = false; app.classList.remove('paused');
      phone.style.setProperty('--rx', '0deg'); phone.style.setProperty('--ry', '0deg');
      schedule();
    });
    if (finePointer && !reduced) {
      stage.addEventListener('pointermove', (e) => {
        const r = stage.getBoundingClientRect();
        const x = (e.clientX - r.left) / r.width - 0.5, y = (e.clientY - r.top) / r.height - 0.5;
        phone.style.setProperty('--ry', (x * 16).toFixed(2) + 'deg');
        phone.style.setProperty('--rx', (y * -12).toFixed(2) + 'deg');
      });
    }
    } catch (err) {
      app.classList.add('in', 'settled');
      console.error('project stage:', err);
    }
  }

  // Scroll depth: --s is -1 when an app sits a full screen below the middle
  // of the viewport, 0 in the middle, 1 a full screen above. One rAF a frame.
  if (reduced) return;
  let queued = false;
  const update = () => {
    queued = false;
    const mid = innerHeight / 2;
    for (const app of apps) {
      const r = app.getBoundingClientRect();
      const s = Math.max(-1, Math.min(1, (mid - (r.top + r.height / 2)) / innerHeight));
      app.style.setProperty('--s', s.toFixed(3));
    }
  };
  addEventListener('scroll', () => { if (!queued) { queued = true; requestAnimationFrame(update); } }, { passive: true });
  update();
})();

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

  // The contact form posts to Web3Forms, the same service the site used
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
})();

// Case study rail: --d (-1..1) per screen from the rail's centre, so phones
// turn toward you as they reach the middle; the arrow buttons step one
// screen at a time. Scrolling, swiping and keyboard all still work natively.
(() => {
  const rail = document.querySelector('.rail');
  if (!rail) return;
  const items = [...rail.querySelectorAll('figure')];
  let queued = false;
  const update = () => {
    queued = false;
    const r = rail.getBoundingClientRect();
    const mid = r.left + r.width / 2;
    for (const f of items) {
      const b = f.getBoundingClientRect();
      const d = Math.max(-1, Math.min(1, (b.left + b.width / 2 - mid) / (r.width / 2)));
      f.style.setProperty('--d', d.toFixed(3));
    }
  };
  rail.addEventListener('scroll', () => { if (!queued) { queued = true; requestAnimationFrame(update); } }, { passive: true });
  addEventListener('resize', update);
  update();

  const step = (dir) => {
    const w = items[0].getBoundingClientRect().width + parseFloat(getComputedStyle(rail).columnGap || 0);
    const smooth = !matchMedia('(prefers-reduced-motion: reduce)').matches;
    rail.scrollBy({ left: dir * w, behavior: smooth ? 'smooth' : 'auto' });
  };
  document.querySelector('[data-rail="prev"]')?.addEventListener('click', () => step(-1));
  document.querySelector('[data-rail="next"]')?.addEventListener('click', () => step(1));
})();
