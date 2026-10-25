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
