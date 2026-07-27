import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';
import 'project_showcase.vm.dart' if (dart.library.js_interop) 'project_showcase.web.dart';

/// Ported from `StickyProjectShowcase` — a scroll-driven phone mockup that
/// stays pinned while cycling through each project's gallery images/video,
/// with the tech-stack word and left-side info panel advancing in sync.
///
/// The original hand-rolled its own sticky positioning by tracking the
/// element's absolute screen position every scroll frame and clamping a
/// `Transform.translate` offset — real CSS `position: sticky` (used for
/// `.showcase-stage` below) does that natively, so this port only needs
/// scroll math for *which project/image/tech-word is active*, not for
/// keeping the phone glued to the viewport. `@client` because it's the one
/// section that genuinely needs continuous scroll tracking; project data is
/// resolved server-side by ProjectsSection and passed in as plain maps
/// (not the ProjectItem class) since @client constructor params need to be
/// values simple enough for Jaspr to serialize for client hydration.
@client
class StickyProjectShowcase extends StatefulComponent {
  final List<Map<String, dynamic>> projects;

  const StickyProjectShowcase({super.key, required this.projects});

  @override
  State<StickyProjectShowcase> createState() => _StickyProjectShowcaseState();

  @css
  static List<StyleRule> get styles => [
    css('.sticky-showcase', [
      css('&').styles(position: Position.relative()),
    ]),
    css('.showcase-stage', [
      css('&').styles(
        position: Position.sticky(top: Unit.zero),
        height: 100.vh,
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.center,
        overflow: Overflow.hidden,
      ),
    ]),
    css('.showcase-bg', [
      css('&').styles(
        position: Position.absolute(top: Unit.zero, left: Unit.zero, right: Unit.zero, bottom: Unit.zero),
        zIndex: ZIndex(0),
        transition: Transition('background', duration: 800.ms),
        raw: {
          'background': 'radial-gradient(circle at 50% 50%, '
              'color-mix(in srgb, var(--accent) 15%, ${AppColors.background.value}) 0%, '
              '${AppColors.background.value} 70%)',
        },
      ),
    ]),
    css('.showcase-phone', [
      css('&').styles(position: Position.relative(), zIndex: ZIndex(1)),
    ]),
    css('.phone-frame', [
      css('&').styles(
        position: Position.relative(),
        width: 280.px,
        height: 580.px,
        padding: Padding.all(10.px),
        radius: BorderRadius.circular(2.75.rem),
        raw: {
          'background': 'linear-gradient(135deg, #555555 0%, #222222 40%, #111111 60%, #444444 100%)',
          'box-shadow': '0 30px 50px -10px rgba(0,0,0,0.5)',
        },
      ),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile.px), [
        css('&').styles(width: 220.px, height: 460.px),
      ]),
    ]),
    css('.phone-body', [
      css('&').styles(
        position: Position.relative(),
        width: 100.percent,
        height: 100.percent,
        overflow: Overflow.hidden,
        backgroundColor: Colors.black,
        radius: BorderRadius.circular(2.25.rem),
      ),
    ]),
    css('.phone-screen', [
      css('&').styles(position: Position.absolute(top: Unit.zero, left: Unit.zero, right: Unit.zero, bottom: Unit.zero)),
      css('img, video').styles(width: 100.percent, height: 100.percent, raw: {'object-fit': 'cover'}),
    ]),
    css('.phone-placeholder', [
      css('&').styles(
        width: 100.percent,
        height: 100.percent,
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.center,
        backgroundColor: Color.variable('--accent'),
      ),
      css('span').styles(color: Colors.white.withValues(alpha: 0.5), fontSize: 4.rem),
    ]),
    css('.phone-island', [
      css('&').styles(
        position: Position.absolute(top: 12.px, left: 50.percent),
        transform: Transform.translate(x: (-50).percent),
        width: 90.px,
        height: 26.px,
        backgroundColor: Colors.black,
        radius: BorderRadius.circular(1.rem),
        zIndex: ZIndex(2),
      ),
    ]),
    css('.showcase-info', [
      css('&').styles(
        position: Position.absolute(left: 4.rem, top: 50.percent),
        transform: Transform.translate(y: (-50).percent),
        zIndex: ZIndex(1),
        maxWidth: 26.rem,
      ),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.tablet.px), [
        css('&').styles(
          position: Position.absolute(left: 1.5.rem, right: 1.5.rem, bottom: 2.rem, top: Unit.expression('auto')),
          transform: Transform.none,
          maxWidth: Unit.expression('none'),
        ),
      ]),
    ]),
    css('.info-title', [
      css('&').styles(
        color: AppColors.textPrimary,
        fontFamily: FontFamily.list([FontFamily('IBM Plex Mono'), FontFamilies.monospace]),
        fontSize: 2.5.rem,
        margin: Margin.only(bottom: 1.25.rem),
      ),
    ]),
    css('.info-description', [
      css('&').styles(
        color: AppColors.textSecondary,
        fontFamily: FontFamily.list([FontFamily('JetBrains Mono'), FontFamilies.monospace]),
        fontSize: 1.rem,
        lineHeight: Unit.expression('1.6'),
        margin: Margin.only(bottom: 2.5.rem),
      ),
    ]),
    css('.info-links', [
      css('&').styles(display: Display.flex, gap: Gap.all(1.25.rem)),
      css('.store-btn').styles(
        display: Display.flex,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.center,
        width: 3.rem,
        height: 3.rem,
        radius: BorderRadius.circular(50.percent),
        border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.2), width: 1.px),
        color: AppColors.textPrimary,
      ),
      css('.store-btn span').styles(fontSize: 1.4.rem),
      css('.coming-soon').styles(
        color: AppColors.textSecondary,
        fontFamily: FontFamily.list([FontFamily('JetBrains Mono'), FontFamilies.monospace]),
        fontSize: 0.85.rem,
        padding: Padding.symmetric(horizontal: 1.rem, vertical: 0.6.rem),
        radius: BorderRadius.circular(1.5.rem),
        border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.2), width: 1.px),
      ),
    ]),
    css('.showcase-tech', [
      css('&').styles(
        position: Position.absolute(right: 4.rem, top: 50.percent),
        transform: Transform.translate(y: (-50).percent),
        zIndex: ZIndex(1),
        textAlign: TextAlign.right,
      ),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.tablet.px), [
        css('&').styles(display: Display.none),
      ]),
      css('.tech-label').styles(
        display: Display.block,
        color: AppColors.textSecondary,
        fontFamily: FontFamily.list([FontFamily('JetBrains Mono'), FontFamilies.monospace]),
        fontSize: 0.85.rem,
        letterSpacing: 2.px,
        margin: Margin.only(bottom: 1.25.rem),
      ),
      css('.tech-word').styles(
        display: Display.block,
        color: AppColors.textPrimary,
        fontFamily: FontFamily.list([FontFamily('IBM Plex Mono'), FontFamilies.monospace]),
        fontWeight: FontWeight.w700,
        fontSize: 2.5.rem,
      ),
    ]),
    css('.showcase-nav', [
      css('&').styles(
        position: Position.absolute(right: 1.5.rem, top: 50.percent),
        transform: Transform.translate(y: (-50).percent),
        zIndex: ZIndex(1),
        display: Display.flex,
        flexDirection: FlexDirection.column,
        alignItems: AlignItems.end,
        gap: Gap.all(0.75.rem),
      ),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.tablet.px), [
        css('&').styles(display: Display.none),
      ]),
      css('.nav-dot').styles(
        backgroundColor: Colors.transparent,
        border: Border.none,
        color: AppColors.textSecondary,
        fontFamily: FontFamily.list([FontFamily('Space Mono'), FontFamilies.monospace]),
        fontSize: 0.7.rem,
        letterSpacing: 1.px,
        cursor: Cursor.pointer,
        padding: Padding.symmetric(vertical: 0.25.rem),
        transition: Transition('color', duration: 200.ms),
      ),
      css('.nav-dot.active').styles(color: AppColors.primary, fontWeight: FontWeight.w700),
      css('.nav-dot:hover').styles(color: AppColors.primary),
    ]),
  ];
}

class _StickyProjectShowcaseState extends State<StickyProjectShowcase> {
  static const _rootId = 'sticky-project-showcase';
  static const _introHeight = 1400.0;
  static const _scrollPerImage = 800.0;

  int _activeIndex = 0;
  int _imageIndex = 0;
  int _techIndex = 0;

  List<Map<String, dynamic>> get _projects => component.projects;

  @override
  void initState() {
    super.initState();
    listenScroll(_recompute);
  }

  int _galleryCount(int i) => (_projects[i]['galleryImages'] as List?)?.length ?? 0;

  double _projectHeight(int i) => _introHeight + _galleryCount(i) * _scrollPerImage;

  double get _totalHeight {
    var total = 0.0;
    for (var i = 0; i < _projects.length; i++) {
      total += _projectHeight(i);
    }
    return total;
  }

  void _recompute() {
    if (_projects.isEmpty) return;
    final top = elementOffsetTop(_rootId);
    final relativeScroll = scrollY() - top;

    var index = 0;
    var sum = 0.0;
    var offset = 0.0;
    if (relativeScroll <= 0) {
      index = 0;
      offset = 0;
    } else {
      for (var i = 0; i < _projects.length; i++) {
        final h = _projectHeight(i);
        if (relativeScroll < sum + h) {
          index = i;
          offset = relativeScroll - sum;
          break;
        }
        sum += h;
        if (i == _projects.length - 1) {
          index = i;
          offset = h;
        }
      }
    }

    final galleryCount = _galleryCount(index);
    var imageIndex = 0;
    if (galleryCount > 0 && offset > _introHeight / 2) {
      final imageScroll = offset - _introHeight / 2;
      final totalImageScroll = galleryCount * _scrollPerImage;
      final progress = (imageScroll / totalImageScroll).clamp(0.0, 1.0);
      imageIndex = (progress * galleryCount).floor().clamp(0, galleryCount - 1);
    }

    final tech = (_projects[index]['tech'] as List).cast<String>();
    final projectProgress = (offset / _projectHeight(index)).clamp(0.0, 1.0);
    final techLimit = (projectProgress * tech.length).ceil().clamp(1, tech.length);
    final techIndex = techLimit - 1;

    if (index != _activeIndex || imageIndex != _imageIndex || techIndex != _techIndex) {
      setState(() {
        _activeIndex = index;
        _imageIndex = imageIndex;
        _techIndex = techIndex;
      });
    }
  }

  void _scrollToProject(int index) {
    final top = elementOffsetTop(_rootId);
    var target = top;
    for (var i = 0; i < index; i++) {
      target += _projectHeight(i);
    }
    smoothScrollTo(target + 10);
  }

  @override
  Component build(BuildContext context) {
    if (_projects.isEmpty) return div([]);

    final project = _projects[_activeIndex];
    final accent = Color.value((project['color'] as int) & 0xFFFFFF);
    final tech = (project['tech'] as List).cast<String>();
    final galleryImages = (project['galleryImages'] as List?)?.cast<String>() ?? const <String>[];
    final videoUrl = project['videoUrl'] as String?;
    final androidUrl = project['androidStoreUrl'] as String?;
    final iosUrl = project['iosStoreUrl'] as String?;
    final safeTechIndex = _techIndex.clamp(0, tech.length - 1);

    return div(
      id: _rootId,
      classes: 'sticky-showcase',
      styles: Styles(height: _totalHeight.px),
      [
        div(classes: 'showcase-stage', [
          div(classes: 'showcase-bg', styles: Styles(raw: {'--accent': accent.value}), []),
          div(classes: 'showcase-phone', [
            _buildPhone(project, videoUrl, galleryImages, accent),
          ]),
          div(classes: 'showcase-info', [
            h3(classes: 'info-title', [.text(project['title'] as String)]),
            p(classes: 'info-description', [.text(project['description'] as String)]),
            div(classes: 'info-links', [
              if (androidUrl != null)
                a(href: androidUrl, classes: 'store-btn', [span(classes: 'material-symbols-rounded', [.text('android')])]),
              if (iosUrl != null)
                // Material Symbols has no "Apple logo" icon (it's Google's
                // icon set) -- 'apple' silently falls back to literal text
                // that overflows the circular button. phone_iphone is the
                // closest real icon in the set.
                a(href: iosUrl, classes: 'store-btn', [span(classes: 'material-symbols-rounded', [.text('phone_iphone')])]),
              if (androidUrl == null && iosUrl == null) span(classes: 'coming-soon', [.text('Coming Soon')]),
            ]),
          ]),
          div(classes: 'showcase-tech', [
            span(classes: 'tech-label', [.text('TECHNOLOGIES')]),
            span(classes: 'tech-word', [.text(tech.isEmpty ? '' : tech[safeTechIndex])]),
          ]),
          div(classes: 'showcase-nav', [
            for (final (i, p) in _projects.indexed)
              button(
                classes: i == _activeIndex ? 'nav-dot active' : 'nav-dot',
                attributes: const {'type': 'button'},
                events: {'click': (_) => _scrollToProject(i)},
                [.text((p['title'] as String).toUpperCase())],
              ),
          ]),
        ]),
      ],
    );
  }

  Component _buildPhone(Map<String, dynamic> project, String? videoUrl, List<String> galleryImages, Color accent) {
    Component content;
    if (videoUrl != null) {
      content = video(
        key: ValueKey('video-${project['title']}'),
        src: videoUrl,
        autoplay: true,
        loop: true,
        muted: true,
        attributes: const {'playsinline': ''},
        [],
      );
    } else if (galleryImages.isNotEmpty) {
      final safeIndex = _imageIndex.clamp(0, galleryImages.length - 1);
      content = img(key: ValueKey('img-$safeIndex'), src: galleryImages[safeIndex], alt: project['title'] as String);
    } else {
      content = div(
        key: const ValueKey('placeholder'),
        classes: 'phone-placeholder',
        styles: Styles(raw: {'--accent': accent.value}),
        [span(classes: 'material-symbols-rounded', [.text('stacks')])],
      );
    }

    return div(classes: 'phone-frame', [
      div(classes: 'phone-body', [
        div(classes: 'phone-screen', [content]),
        div(classes: 'phone-island', []),
      ]),
    ]);
  }
}
