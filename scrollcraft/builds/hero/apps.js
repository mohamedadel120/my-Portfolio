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
    // Many screens get a pager (name, number, arrows) instead of dashes.
    const pagerNow = app.querySelector('.pager-now');
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

    // Screens are lazy; once one is shown its neighbours start loading, so a
    // tap or an arrow lands on a ready screen instead of a blank one.
    const warm = (i) => {
      for (const d of [1, -1]) {
        const f = frames[(i + d + frames.length) % frames.length];
        if (f && f.loading === 'lazy') f.loading = 'eager';
      }
    };
    const show = (next) => {
      if (next === index) return;
      const old = frames[index];
      old.classList.remove('on');
      old.classList.add('out');
      setTimeout(() => old.classList.remove('out'), 520);
      frames[next].classList.add('on');
      steps[index]?.removeAttribute('aria-current');
      steps[next]?.setAttribute('aria-current', 'true');
      index = next;
      warm(next);
      if (pagerNow) {
        pagerNow.querySelector('b').textContent = frames[next].dataset.caption || '';
        pagerNow.querySelector('span').textContent = `${next + 1}/${frames.length}`;
      }
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
    app.querySelectorAll('.pager button').forEach((b) => b.addEventListener('click', () => step(+b.dataset.dir)));
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
        warm(index);
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
