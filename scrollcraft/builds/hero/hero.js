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
