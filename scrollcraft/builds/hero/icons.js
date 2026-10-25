// Store glyphs (Simple Icons, CC0), shared by the page generators.
exports.PLAY = '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M22.018 13.298l-3.919 2.218-3.515-3.493 3.543-3.521 3.891 2.202a1.49 1.49 0 0 1 0 2.594zM1.337.924a1.486 1.486 0 0 0-.112.568v21.017c0 .217.045.419.124.6l11.155-11.087L1.337.924zm12.207 10.065l3.258-3.238L3.45.195a1.466 1.466 0 0 0-.946-.179l11.04 10.973zm0 2.067l-11 10.933c.298.036.612-.016.906-.183l13.324-7.54-3.23-3.21z"/></svg>';
exports.APPLE = '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M12.152 6.896c-.948 0-2.415-1.078-3.96-1.04-2.04.027-3.91 1.183-4.961 3.014-2.117 3.675-.546 9.103 1.519 12.09 1.013 1.454 2.208 3.09 3.792 3.039 1.52-.065 2.09-.987 3.935-.987 1.831 0 2.35.987 3.96.948 1.637-.026 2.676-1.48 3.676-2.948 1.156-1.688 1.636-3.325 1.662-3.415-.039-.013-3.182-1.221-3.22-4.857-.026-3.04 2.48-4.494 2.597-4.559-1.429-2.09-3.623-2.324-4.39-2.376-2-.156-3.675 1.09-4.61 1.09zM15.53 3.83c.843-1.012 1.4-2.427 1.245-3.83-1.207.052-2.662.805-3.532 1.818-.78.896-1.454 2.338-1.273 3.714 1.338.104 2.715-.688 3.559-1.701"/></svg>';

// Each app's store listings, as the stores show them (title, developer and
// icon read from the listing pages on 25 Oct 2026).
exports.STORES = {
  gomla: [
    { store: 'play', label: 'Google Play', url: 'https://play.google.com/store/apps/details?id=com.gomla.store', title: 'Go Gomla', dev: 'Gomla Store', icon: 'icon-gomla-play.webp', device: 'Android' },
    { store: 'ios', label: 'App Store', url: 'https://apps.apple.com/eg/app/go-gomla/id6742806281', title: 'Go Gomla', dev: 'Gomla', icon: 'icon-gomla-ios.webp', device: 'iPhone' },
  ],
  stock: [
    { store: 'play', label: 'Google Play', url: 'https://play.google.com/store/apps/details?id=com.spark.stockclientapp', title: 'Stock - ستوك', dev: 'Stock Developer', icon: 'icon-stock-play.webp', device: 'Android' },
    { store: 'ios', label: 'App Store', url: 'https://apps.apple.com/eg/app/stock-b2b/id1639101527', title: 'Stock (B2B)', dev: 'Ahmed Adel', icon: 'icon-stock-ios.webp', device: 'iPhone' },
  ],
  albatal: [
    { store: 'play', label: 'Google Play', url: 'https://play.google.com/store/apps/details?id=com.albatal.alba', title: 'البطل', dev: 'Innovation Agency', icon: 'icon-albatal-play.webp', device: 'Android' },
  ],
  palleta: [
    { store: 'play', label: 'Google Play', url: 'https://play.google.com/store/apps/details?id=com.spark.palettalientapp', title: 'Paletta (B2B)', dev: 'Innovation Agency', icon: 'icon-palleta-play.webp', device: 'Android' },
    { store: 'ios', label: 'App Store', url: 'https://apps.apple.com/eg/app/paletta-b2b/id6760196797', title: 'Paletta (B2B)', dev: 'Ahmed Adel', icon: 'icon-palleta-ios.webp', device: 'iPhone' },
  ],
  'to-let': [
    { store: 'play', label: 'Google Play', url: 'https://play.google.com/store/apps/details?id=com.thefirst.tolet&amp;pcampaignid=web_share', title: 'to-let', dev: 'The First Agency', icon: 'icon-to-let-play.webp', device: 'Android' },
    { store: 'ios', label: 'App Store', url: 'https://apps.apple.com/us/app/to-let/id6758267446', title: 'to-let', dev: 'CLEVERNESS AGENCY FOR ADVERTISING', icon: 'icon-to-let-ios.webp', device: 'iPhone' },
  ],
  ureva: [],
  adruse: [],
  'drugza-tagpharma': [
    { store: 'play', label: 'Google Play', url: 'https://play.google.com/store/apps/details?id=com.app.drugza', title: 'Drugza', dev: 'Innovation Agency', icon: 'icon-drugza-tagpharma-play.webp', device: 'Android' },
  ],
};

// The hover/focus preview of a store listing: icon, title, developer, a few
// real screens, and where the link goes. Shown by CSS only.
exports.peek = (s, name, shots, downloads) => `<span class="peek" aria-hidden="true">
  <span class="peek-head"><img src="assets/${s.icon}" alt="" width="48" height="48"><span><b dir="auto">${s.title}</b><small>${s.dev}</small></span></span>
  ${shots.length ? `<span class="peek-shots">${shots.slice(0, 3).map((src) => `<img src="assets/${src}" alt="" width="600" height="1147" loading="lazy">`).join('')}</span>` : ''}
  <span class="peek-foot"><span>For ${s.device}</span><span>View on ${s.label} ↗</span></span>
</span>`;

// A store link with its preview: round icon (home) or full button (case study).
exports.storeLink = (s, name, shots, kind) => {
  const glyph = s.store === 'play' ? exports.PLAY : exports.APPLE;
  const aria = s.store === 'play' ? `Get ${name} on Google Play` : `Download ${name} on the App Store`;
  const inner = kind === 'button'
    ? `${glyph}<span><small>${s.store === 'play' ? 'Get it on' : 'Download on the'}</small><b>${s.label}</b></span>`
    : glyph;
  return `<span class="peek-wrap"><a class="${kind === 'button' ? 'store' : 'store-icon'}" href="${s.url}" target="_blank" rel="noopener noreferrer" aria-label="${aria}">${inner}</a>${exports.peek(s, name, shots)}</span>`;
};

// The two devices. With an iPhone version, the phone behind is that iPhone
// showing the same screen, and choosing it brings it to the front. Without
// one, the phone behind is the same Android device showing the next screen.
exports.devices = (name, shots, hasIos, h) => {
  const ghost = hasIos
    ? `<div class="ghost dev ios" role="button" tabindex="0" aria-label="Show ${name} on iPhone" data-swap><span class="dev-tag" aria-hidden="true">iPhone</span><img src="assets/${shots[0][0]}" alt="" width="600" height="${h}"></div>`
    : `<div class="ghost dev android" role="button" tabindex="0" aria-label="${name}: show the next screen"><img src="assets/${shots[1][0]}" alt="" width="600" height="${h}" loading="lazy"></div>`;
  const phone = `<div class="app-phone dev android" role="button" tabindex="0" aria-label="${name}: show the next screen"><span class="dev-tag" aria-hidden="true">Android</span>
            <div class="frames">${shots.map(([src, alt, notes], i) => `<img class="frame${i === 0 ? ' on' : ''}" src="assets/${src}" alt="${alt}" width="600" height="${h}"${i ? ' loading="lazy"' : ''} data-notes="${notes}">`).join('')}</div>
          </div>`;
  return ghost + '\n          ' + phone;
};
