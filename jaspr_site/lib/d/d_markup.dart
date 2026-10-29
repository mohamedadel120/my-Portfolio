import '../data/contact_repository.dart';
import '../data/experience_repository.dart';
import '../data/profile_repository.dart';
import '../data/projects_repository.dart';
import '../sections/about_brief_section.dart' show groupSkills;
import 'd_project.dart';

// Design D's markup, as HTML strings. It is the scroll-craft prototype
// (scrollcraft/builds/hero) ported line for line, so the page matches what
// was reviewed and tested there; web/d/d.css and web/d/d.js style and drive
// it. Every Firestore value goes through esc().

String _lower(String s) => s.isEmpty ? s : s[0].toLowerCase() + s.substring(1);
String _num(int n) => n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');
String _title(String t) => '<span class="reveal-line"><span>${esc(t)}</span></span>';

// ----------------------------------------------------------------- shell

String dHeader({required String cvUrl, String? current}) {
  String link(String href, String text, String key) =>
      '<a href="$href"${current == key ? ' class="active" aria-current="page"' : ''}>$text</a>';
  final links = [
    link('/#top', 'HOME', 'home'),
    link('/#projects', 'PROJECTS', 'projects'),
    link('/#experience', 'EXPERIENCE', 'experience'),
    link('/#about', 'ABOUT', 'about'),
    link('/#contact', 'CONTACT', 'contact'),
  ].join();
  final cv = cvUrl.trim().isEmpty ? '' : '<a class="cv" href="${esc(cvUrl)}" target="_blank" rel="noopener noreferrer">Download CV</a>';
  return '''<div class="progress" aria-hidden="true"></div>
<header class="top">
  <a href="/#top" class="logo"><img src="/images/logo-teal-160.png" alt="Mohamed Adel, home" width="44" height="44"></a>
  <nav aria-label="Sections"${current != null ? ' data-fixed' : ''}>$links</nav>
  <details class="menu"><summary aria-label="Menu">Menu</summary><nav aria-label="Sections (menu)">$links</nav></details>
  $cv
</header>''';
}

String dFooter() => '<footer class="foot"><span>© ${DateTime.now().year} Mohamed Adel</span><span>Built with <b>Dart</b> &amp; <b>Jaspr</b></span></footer>';

// ------------------------------------------------------------------ hero

/// The hero's scene is built from a real project: its first screen, the
/// widget names on it (the inspector labels), its stores and downloads. The
/// code layer is illustrative, assembled from those widget names.
String dHero({required DProject? scene, required String location}) {
  final copy = '''<div class="copy">
    <p class="eyebrow"><b>flutter</b> developer · ${esc(location)}</p>
    <h1 id="hero-title">Flutter apps people actually download.</h1>
    <p class="sub">3+ years shipping Android and iOS apps, from first screen to store listing.</p>
    <div class="actions">
      <a class="btn primary" href="#projects">See the apps</a>
      <a class="btn" href="#contact">Get in touch</a>
    </div>
    <p class="stack-line">Dart · Bloc · Clean Architecture · Firebase · REST</p>
  </div>''';
  return '''<section class="hero" id="top" aria-labelledby="hero-title">
  <div class="grid" aria-hidden="true"></div>
  $copy
  ${scene == null ? '' : _heroScene(scene)}
</section>''';
}

String _heroScene(DProject p) {
  final screen = p.screens.first;
  final names = [for (final n in screen.notes) n.label];
  final bloc = p.stack.any((t) => t.toLowerCase().contains('bloc') || t.toLowerCase().contains('cubit'));
  String t(String s) => '<span class="t">${esc(s)}</span>';
  String k(String s) => '<span class="k">$s</span>';
  final appBar = names.isNotEmpty ? names.first : 'AppBar';
  final bottom = names.length > 1 ? names.last : null;
  final body = names.length > 2 ? names.sublist(1, names.length - 1) : const <String>[];
  // The lines between "Scaffold(" and its closing parenthesis.
  final scaffoldBody = [
    '  appBar: ${k('const')} ${t(appBar)}(),',
    '  body: ${t('CustomScrollView')}(slivers: [',
    for (final b in body) '    ${t(b)}(),',
    '  ]),',
    if (bottom != null) '  bottomNavigationBar: ${k('const')} ${t(bottom)}(),',
  ];
  final inner = bloc
      ? [
          '${k('return')} ${t('BlocBuilder')}&lt;${t('HomeCubit')}, ${t('HomeState')}&gt;(',
          '  builder: (context, state) =&gt; ${t('Scaffold')}(',
          for (final l in scaffoldBody) '  $l',
          '  ),',
          ');',
        ]
      : ['${k('return')} ${t('Scaffold')}(', ...scaffoldBody, ');'];
  final code = [
    '<span class="fname">lib/features/home/home_screen.dart</span>${k('class')} ${t('HomeScreen')} ${k('extends')} ${t('StatelessWidget')} {',
    '  ${k('const')} ${t('HomeScreen')}({${k('super')}.key});',
    '',
    '  <span class="c">@override</span>',
    '  ${t('Widget')} build(${t('BuildContext')} context) {',
    for (final l in inner) '    $l',
    '  }',
    '}',
  ].join('\n');
  // Widget boxes: each label's band, split halfway between neighbours.
  final ys = [for (final n in screen.notes) n.y];
  final boxes = [
    for (var i = 0; i < ys.length; i++)
      () {
        final top = i == 0 ? (ys[0] - 10).clamp(2, 100) : ((ys[i - 1] + ys[i]) / 2 + 1).round();
        final end = i == ys.length - 1 ? (ys[i] + 5).clamp(0, 97) : ((ys[i] + ys[i + 1]) / 2 - 1).round();
        return '<div class="box" style="top:$top%;height:${(end - top).clamp(4, 100)}%"><span>${esc(screen.notes[i].label)}</span></div>';
      }(),
  ].join('\n        ');
  final stores = p.stores.map((s) => s.label).join(' and ');
  final count = p.downloads;
  final storeCard = stores.isEmpty || count == null
      ? ''
      : '<div class="card store"><span class="dot"></span><span>${esc(p.name)} on $stores<b>${_num(count)}+ downloads</b></span></div>';
  // Store artwork has no widget names to build the code and boxes from, so
  // the scene shows the phone alone rather than made-up widgets.
  final layers = names.isEmpty
      ? ''
      : '''<pre class="layer code">$code</pre>
      <div class="layer wire"><div class="screen">
        $boxes
      </div></div>''';
  return '''<div class="scene${names.isEmpty ? ' art' : ''}" aria-hidden="true">
    <div class="rig">
      $layers
      <div class="layer device"><img src="${esc(screen.url)}" alt="" width="600" height="1200" fetchpriority="high"></div>
      <div class="card build">\$ flutter build appbundle --release<br><span class="ok">✓</span> Built app-release.aab</div>
      $storeCard
    </div>
  </div>''';
}

/// The project the hero shows: the one the owner marked Featured in the
/// dashboard (store artwork works too), else the first with labelled
/// screens and a download count, else the first with labelled screens.
DProject? heroProject(List<DProject> projects) {
  for (final p in projects) {
    if (p.item.featured && p.mode != ShowcaseMode.video && p.screens.isNotEmpty) return p;
  }
  bool hasScreens(DProject p) => p.mode == ShowcaseMode.screens && p.screens.isNotEmpty && p.screens.first.notes.isNotEmpty;
  for (final p in projects) {
    if (hasScreens(p) && p.downloads != null) return p;
  }
  for (final p in projects) {
    if (hasScreens(p)) return p;
  }
  return null;
}

// --------------------------------------------------------------- projects

String _peek(DStore s, DProject p) {
  // Without the listing from the dashboard, the card still shows what is
  // known: the project's own title, logo and screens. No developer is guessed.
  final l = s.listing;
  final title = l?.title ?? p.title;
  final developer = l?.developer ?? '';
  final logo = (p.item.logoUrl ?? '').trim();
  final iconUrl = l?.iconUrl ?? (logo.isEmpty ? null : logo);
  final icon = iconUrl == null ? '' : '<img src="${esc(iconUrl)}" alt="" width="48" height="48" loading="lazy">';
  final shots = p.screens.take(3).toList();
  return '''<span class="peek" aria-hidden="true">
  <span class="peek-head">$icon<span><b dir="auto">${esc(title)}</b>${developer.isEmpty ? '' : '<small>${esc(developer)}</small>'}</span></span>
  ${shots.isEmpty ? '' : '<span class="peek-shots">${shots.map((s) => '<img src="${esc(s.url)}" alt="" width="600" height="1200" loading="lazy">').join()}</span>'}
  <span class="peek-foot"><span>For ${s.device}</span><span>View on ${s.label} ↗</span></span>
</span>''';
}

String _storeLink(DStore s, DProject p, {required bool button}) {
  final glyph = s.store == 'play' ? playGlyph : appleGlyph;
  final aria = s.store == 'play' ? 'Get ${p.name} on Google Play' : 'Download ${p.name} on the App Store';
  final inner = button ? '$glyph<span><small>${s.store == 'play' ? 'Get it on' : 'Download on the'}</small><b>${s.label}</b></span>' : glyph;
  return '<span class="peek-wrap"><a class="${button ? 'store-btn' : 'store-icon'}" href="${esc(s.url)}" target="_blank" rel="noopener noreferrer" aria-label="${esc(aria)}">$inner</a>${_peek(s, p)}</span>';
}

String _img(String url, String alt, {String cls = '', String extra = ''}) =>
    '<img${cls.isEmpty ? '' : ' class="$cls"'} src="${esc(url)}" alt="${esc(alt)}" width="600" height="1200"$extra>';

String _devices(DProject p) {
  final name = esc(p.name);
  if (p.mode == ShowcaseMode.video && p.videoUrl != null) {
    return '''<div class="app-phone dev android" role="button" tabindex="0" aria-label="$name: pause or play the recording"><span class="dev-tag" aria-hidden="true">screen recording</span>
            <div class="frames"><video class="frame on" src="${esc(p.videoUrl!)}" muted loop playsinline preload="metadata" aria-label="$name screen recording"></video></div>
          </div>''';
  }
  final screens = p.screens;
  final art = p.mode == ShowcaseMode.art;
  final kind = art ? 'art' : 'android';
  final what = art ? 'artwork' : 'screen';
  final hasIos = p.item.hasIos;
  // The device tag names a platform only when the project lists one.
  final tag = art ? 'store artwork' : p.item.hasAndroid ? 'Android' : 'preview';
  final ghost = screens.length < 2 && !(hasIos && !art)
      ? ''
      : !art && hasIos
      ? '<div class="ghost dev ios" role="button" tabindex="0" aria-label="Show $name on iPhone" data-swap><span class="dev-tag" aria-hidden="true">iPhone</span>${_img(screens.first.url, '')}</div>'
      : '<div class="ghost dev $kind" role="button" tabindex="0" aria-label="$name: show the next $what">${_img(screens[1].url, '', extra: ' loading="lazy"')}</div>';
  final frames = [
    for (final (i, s) in screens.indexed)
      _img(s.url, '${p.name}: ${_lower(s.caption)}${art ? '' : ' screen'}', cls: 'frame${i == 0 ? ' on' : ''}',
          extra: '${i > 0 ? ' loading="lazy"' : ''} data-caption="${esc(s.caption)}" data-notes="${esc(s.notes.map((n) => '${n.label}@${n.y}').join('|'))}"'),
  ].join();
  return '''$ghost
          <div class="app-phone dev $kind" role="button" tabindex="0" aria-label="$name: show the next $what"><span class="dev-tag" aria-hidden="true">$tag</span>
            <div class="frames">$frames</div>
          </div>''';
}

String _floatCard(DProject p) {
  final stores = p.stores.map((s) => s.label).join(' and ');
  final line = p.downloads != null ? '${_num(p.downloads!)}+ downloads' : p.status ?? (stores.isNotEmpty ? 'Live' : '');
  if (line.isEmpty) return '';
  return '<div class="float-card" aria-hidden="true"><span class="dot"></span><span>${stores.isNotEmpty ? 'On $stores' : esc(p.name)}<b>${esc(line)}</b></span></div>';
}

/// The most screens shown as dashes under the phone; more get the pager.
const maxStepDashes = 8;
const _chevronLeft = '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M15 6l-6 6 6 6"/></svg>';
const _chevronRight = '<svg viewBox="0 0 24 24" aria-hidden="true"><path d="M9 6l6 6-6 6"/></svg>';

bool _hasStage(DProject p) => p.mode == ShowcaseMode.video ? p.videoUrl != null : p.screens.isNotEmpty;

String _stage(DProject p) {
  if (!_hasStage(p)) return '';
  final screens = p.screens;
  final what = p.mode == ShowcaseMode.art ? 'artwork' : 'screens';
  // Up to 8 screens: one dash each. More than that: the screen's name, its
  // number and two arrows, since a row of many dashes is too small to read.
  final steps = p.mode == ShowcaseMode.video || screens.length < 2
      ? ''
      : screens.length > maxStepDashes
      ? '<div class="pager" role="group" aria-label="${esc(p.name)} $what">'
            '<button type="button" data-dir="-1" aria-label="Previous screen">$_chevronLeft</button>'
            '<span class="pager-now" aria-live="polite"><b dir="auto">${esc(screens.first.caption)}</b><span>1/${screens.length}</span></span>'
            '<button type="button" data-dir="1" aria-label="Next screen">$_chevronRight</button></div>'
      : '<div class="steps" role="group" aria-label="${esc(p.name)} $what">${[for (final (i, s) in screens.indexed) '<button type="button" aria-label="Show ${esc(_lower(s.caption))}"${i == 0 ? ' aria-current="true"' : ''}><span></span></button>'].join()}</div>';
  return '''<div class="app-stage" style="--tint: ${p.tint}">
        <span class="bg-word" aria-hidden="true">${esc(p.name)}</span>
        <div class="rigwrap">
          ${_devices(p)}
          <ul class="notes" aria-hidden="true"></ul>
        </div>
        ${_floatCard(p)}
        $steps
        <p class="tap-hint" aria-hidden="true">${p.mode == ShowcaseMode.video ? 'tap to pause or play' : 'tap or swipe the screen'}</p>
      </div>''';
}

String _meta(DProject p, {required bool icons}) {
  final parts = [
    if (p.platforms.isNotEmpty) '<div><dt>platforms</dt><dd>${p.platforms}</dd></div>',
    if (p.downloads case final d?) '<div><dt>downloads</dt><dd><span data-count="$d">${_num(d)}</span>+</dd></div>',
    if (p.status case final s?) '<div><dt>status</dt><dd>${esc(s)}</dd></div>',
    if (icons && p.stores.isNotEmpty) '<div><dt>get it</dt><dd class="store-icons">${p.stores.map((s) => _storeLink(s, p, button: false)).join()}</dd></div>',
  ];
  return parts.isEmpty ? '' : '<dl class="meta">${parts.join()}</dl>';
}

String _chips(DProject p) => p.stack.isEmpty
    ? ''
    : '<ul class="chips" aria-label="Stack">${[for (final (i, s) in p.stack.indexed) '<li style="--i:$i">${esc(s)}</li>'].join()}</ul>';

String _appRow(DProject p, int i) => '''
    <article class="app${i.isOdd ? ' flip' : ''}${_hasStage(p) ? '' : ' no-stage'}" data-app>
      <div class="app-text">
        <h3>${esc(p.name)}</h3>
        <p class="clamp" dir="auto">${esc(p.overview)}</p>
        ${_chips(p)}
        ${_meta(p, icons: true)}
        <a class="app-link" href="/projects/${p.slug}" aria-label="Read the case study: ${esc(p.name)}">Read the case study <span aria-hidden="true">→</span></a>
      </div>
      ${_stage(p)}
    </article>''';

String dProjects(List<DProject> projects, {bool standalone = false}) => '''<section class="section" id="projects">
  <p class="path"><b>~/</b>projects</p>
  ${standalone ? '<h1>' : '<h2>'}${_title('Projects')}${standalone ? '</h1>' : '</h2>'}
  <div class="apps">${[for (final (i, p) in projects.indexed) _appRow(p, i)].join()}
  </div>
</section>''';

// ------------------------------------------------------------- experience

String dExperience(List<ExperienceItem> jobs, {bool standalone = false}) => '''<section class="section" id="experience">
  <p class="path"><b>~/</b>experience</p>
  ${standalone ? '<h1>' : '<h2>'}${_title('Work Experience')}${standalone ? '</h1>' : '</h2>'}
  <div class="log2">${[
      for (final (k, j) in jobs.indexed)
        '''
    <div class="job"><span class="when">${esc(j.period)}${k == 0 ? ' <span class="head">HEAD</span>' : ''}</span><h3>${esc(j.company)} <small>${esc(j.role)}</small></h3>
      <ul>${[for (final (i, a) in j.achievements.indexed) '<li style="--i:$i">${esc(a)}</li>'].join()}</ul></div>''',
    ].join()}
  </div>
</section>''';

// ------------------------------------------------------------------ about

/// The phrases underlined in the summary, when the summary contains them.
const _marked = ['clean architecture', 'state management (Bloc/Provider)', 'API integrations'];

String dAbout(AboutData about, {bool standalone = false}) {
  var summary = esc(about.professionalSummary);
  for (final phrase in _marked) {
    final i = summary.toLowerCase().indexOf(esc(phrase).toLowerCase());
    if (i >= 0) {
      final end = i + esc(phrase).length;
      summary = '${summary.substring(0, i)}<mark>${summary.substring(i, end)}</mark>${summary.substring(end)}';
    }
  }
  final lines = <(String, String)>[('c', '# skills.yaml')];
  for (final g in groupSkills(about.skills)) {
    lines.add(('k', '${g.area.toLowerCase().replaceAll('&', 'and').replaceAll(RegExp(r'[^a-z0-9]+'), '_').replaceAll(RegExp(r'^_|_$'), '')}:'));
    for (final s in g.skills) {
      lines.add(('', '  - ${esc(s)}'));
    }
  }
  final pre = [
    for (final (n, (cls, text)) in lines.indexed)
      '<span class="ln" style="--n:$n">${cls.isEmpty ? text : '<span class="$cls">$text</span>'}${n == lines.length - 1 ? '<span class="caret" aria-hidden="true"></span>' : ''}</span>',
  ].join();
  return '''<section class="section" id="about">
  <p class="path"><b>~/</b>about</p>
  ${standalone ? '<h1>' : '<h2>'}${_title('About Me')}${standalone ? '</h1>' : '</h2>'}
  <div class="about2">
    <p>$summary</p>
    <div class="file">
      <div class="file-tab"><b>skills.yaml</b><span>${lines.length} lines</span></div>
      <pre>$pre</pre>
    </div>
  </div>
</section>''';
}

// ---------------------------------------------------------------- contact

String dContact(ContactData c, {required String formKey, bool standalone = false}) {
  final digits = c.phone.replaceAll(RegExp(r'[^\d+]'), '');
  final socials = [
    for (final s in c.socialLinks)
      if (s.url.startsWith('http')) '<a href="${esc(s.url)}" target="_blank" rel="noopener noreferrer">${esc(s.name)}</a>',
  ].join();
  return '''<section class="section" id="contact">
  <p class="path"><b>~/</b>contact</p>
  ${standalone ? '<h1>' : '<h2>'}${_title('Get In Touch')}${standalone ? '</h1>' : '</h2>'}
  <div class="contact2">
    <div>
      <p class="lead">Let's build something amazing together! Send a message and I'll respond as soon as possible.</p>
      <dl class="rows">
        <div class="row"><dt>email</dt><dd><a href="mailto:${esc(c.email)}">${esc(c.email)}</a></dd><button class="copy-btn" type="button" data-copy="${esc(c.email)}" aria-label="Copy email address">copy</button></div>
        ${c.phone.trim().isEmpty ? '' : '<div class="row"><dt>phone</dt><dd><a href="tel:${esc(digits)}">${esc(c.phone)}</a></dd><span></span></div>'}
        ${c.location.trim().isEmpty ? '' : '<div class="row"><dt>location</dt><dd>${esc(c.location)}</dd><span></span></div>'}
      </dl>
      ${socials.isEmpty ? '' : '<div class="socials">$socials</div>'}
    </div>
    <div class="form">
      <div class="file-tab"><b>new_message</b><span>to: Mohamed</span></div>
      <form novalidate data-key="${esc(formKey)}" data-to="${esc(c.email)}">
        <div class="field"><label for="f-name">name</label><input id="f-name" name="name" autocomplete="name" required></div>
        <div class="field"><label for="f-email">email</label><input id="f-email" name="email" type="email" autocomplete="email" required></div>
        <div class="field"><label for="f-msg">message</label><textarea id="f-msg" name="message" required></textarea></div>
        <button class="send" type="submit">Send Message</button>
        <p class="status" role="status"></p>
      </form>
    </div>
  </div>
</section>''';
}

// ------------------------------------------------------------- case study

String dCaseStudy(DProject p, {required DProject? prev, required DProject? next}) {
  final screens = p.screens;
  final art = p.mode == ShowcaseMode.art;
  final story = [
    if (p.item.problem case final s?) ('problem', s),
    if (p.item.role case final s?) ('my_role', s),
    if (p.item.outcome case final s?) ('outcome', s),
  ];
  final rail = p.mode == ShowcaseMode.video || screens.isEmpty
      ? ''
      : '''
<section class="section" id="screens">
  <p class="path"><b>~/</b>projects/${p.slug}/${art ? 'artwork' : 'screens'}</p>
  <h2>${_title(art ? 'Store artwork' : 'Screens')}</h2>
  <div class="rail-wrap">
    <div class="rail${art ? ' art' : ''}" tabindex="0" role="group" aria-label="${esc(p.name)} ${art ? 'artwork' : 'screens'}. Scroll sideways to browse.">${[
          for (final s in screens)
            '''
      <figure><div class="ph">${_img(s.url, '${p.name}: ${_lower(s.caption)}', extra: ' loading="lazy"')}</div><figcaption>${esc(_lower(s.caption).replaceAll(' ', '_'))}</figcaption></figure>''',
        ].join()}
    </div>
    <div class="rail-nav"><button type="button" data-rail="prev" aria-label="Previous">←</button><button type="button" data-rail="next" aria-label="Next">→</button></div>
  </div>
</section>''';
  final storySection = story.isEmpty
      ? ''
      : '''
<section class="section" id="story">
  <p class="path"><b>~/</b>projects/${p.slug}/story</p>
  <h2>${_title('The story')}</h2>
  <dl class="story">${[for (final (k, v) in story) '<div><dt>$k</dt><dd dir="auto">${esc(v)}</dd></div>'].join()}</dl>
</section>''';
  final stackLines = p.stack.length + 2;
  return '''<section class="section cs-hero" id="top">
  <div class="crumbs"><a href="/#projects"><span aria-hidden="true">←</span> All projects</a><p class="path"><b>~/</b>projects/${p.slug}</p></div>
  <article class="app cs-app" data-app>
    <div class="app-text">
      <h1 dir="auto">${_title(p.title)}</h1>
      <p dir="auto">${esc(p.overview)}</p>
      ${_chips(p)}
      ${_meta(p, icons: false)}
      ${p.stores.isEmpty ? '' : '<div class="stores">${p.stores.map((s) => _storeLink(s, p, button: true)).join()}</div>'}
    </div>
    ${_stage(p)}
  </article>
</section>
$storySection$rail
<section class="section" id="stack">
  <p class="path"><b>~/</b>projects/${p.slug}/stack</p>
  <h2>${_title('Built with')}</h2>
  <div class="stack2">
    <p>${p.platforms.isEmpty ? '' : '${esc(p.name)} runs on ${p.platforms.replaceAll(' · ', ' and ')}. '}The stack below is what the app is built on.</p>
    <div class="file">
      <div class="file-tab"><b>stack.yaml</b><span>$stackLines lines</span></div>
      <pre><span class="ln" style="--n:0"><span class="c"># ${p.slug}</span></span><span class="ln" style="--n:1"><span class="k">stack:</span></span>${[for (final (i, s) in p.stack.indexed) '<span class="ln" style="--n:${i + 2}">  - ${esc(s)}${i == p.stack.length - 1 ? '<span class="caret" aria-hidden="true"></span>' : ''}</span>'].join()}</pre>
    </div>
  </div>
</section>
${prev == null || next == null ? '' : '''<nav class="pn" aria-label="More projects">
  <a href="/projects/${prev.slug}"><small>← previous</small><b>${esc(prev.title)}</b></a>
  <a href="/projects/${next.slug}"><small>next →</small><b>${esc(next.title)}</b></a>
</nav>'''}
<section class="section cs-close">
  <h2>${_title('Have an app in mind?')}</h2>
  <p>Tell me about it, and we can talk about how to build it for Android and iOS.</p>
  <a class="btn primary" href="/#contact">Let's build yours</a>
</section>''';
}
