import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/motion_css.dart';
import '../constants/theme.dart';
import 'project_showcase.vm.dart' if (dart.library.js_interop) 'project_showcase.web.dart';
import 'project_view.dart';
import 'shot_gallery.dart';

/// V2-D: one screen per project. Each project sits in its own tall slot and
/// its stage is `position: sticky`, so it stays on screen for a moment while
/// the visitor scrolls, then the next project takes over. The scroll only
/// moves between projects (about 1.3 screens each); screenshots are browsed
/// with the gallery inside the stage, so the page is a fraction of the
/// length of the original scroll-driven showcase.
///
/// Every project's text, links and screenshots are in the server-rendered
/// HTML (each slot is a complete section), so search engines see all of them
/// and the page works without JavaScript. The script only drives the "3 / 8"
/// indicator and the side navigation. On phones the sticky behaviour is off
/// and projects simply stack.
@client
class ProjectStageShowcase extends StatefulComponent {
  final List<Map<String, dynamic>> projects;

  const ProjectStageShowcase({super.key, required this.projects});

  @override
  State<ProjectStageShowcase> createState() => _ProjectStageShowcaseState();

  @css
  static List<StyleRule> get styles => [
    css('.sd', [
      css('&').styles(position: Position.relative()),
    ]),
    // Zero-height sticky layer that carries the navigation above the stages.
    css('.sd-chrome', [
      css('&').styles(
        position: Position.sticky(top: Unit.zero),
        height: Unit.zero,
        zIndex: ZIndex(5),
        raw: {'overflow': 'visible'},
      ),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.tablet.px), [
        css('&').styles(display: Display.none),
      ]),
    ]),
    css('.sd-nav', [
      css('&').styles(
        position: Position.absolute(right: 1.5.rem),
        display: Display.flex,
        flexDirection: FlexDirection.column,
        alignItems: AlignItems.end,
        gap: Gap.all(0.15.rem),
        margin: Margin.zero,
        padding: Padding.zero,
        raw: {'top': '50dvh', 'transform': 'translateY(-50%)', 'list-style': 'none'},
      ),
    ]),
    css('.sd-nav-item', [
      css('&').styles(
        minHeight: 2.rem,
        padding: Padding.symmetric(horizontal: 0.75.rem),
        border: Border.none,
        radius: BorderRadius.circular(0.5.rem),
        backgroundColor: Colors.transparent,
        color: AppColors.textTertiary,
        cursor: Cursor.pointer,
        fontFamily: FontFamily.list([AppFonts.body, FontFamilies.monospace]),
        fontSize: 0.75.rem,
        textAlign: TextAlign.right,
        raw: {'transition': 'color 160ms ease, background-color 160ms ease'},
      ),
      css('&:focus-visible').styles(raw: {'outline': '2px solid ${AppColors.primary.value}', 'outline-offset': '2px'}),
      css('&[aria-current="true"]').styles(color: AppColors.primary, fontWeight: FontWeight.w700),
    ]),
    RawMediaRule.hoverCapable([
      css('.sd-nav-item:hover').styles(color: AppColors.textPrimary),
    ]),
    css('.sd-skip', [
      css('&').styles(
        position: Position.absolute(right: 1.5.rem),
        display: Display.inlineFlex,
        alignItems: AlignItems.center,
        minHeight: 2.5.rem,
        padding: Padding.symmetric(horizontal: 1.rem),
        radius: BorderRadius.circular(0.5.rem),
        border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.25), width: 1.px),
        backgroundColor: AppColors.background.withValues(alpha: 0.8),
        color: AppColors.textPrimary,
        textDecoration: TextDecoration.none,
        fontSize: 0.8.rem,
        raw: {'top': '6rem', 'backdrop-filter': 'blur(6px)'},
      ),
      css('&:focus-visible').styles(raw: {'outline': '2px solid ${AppColors.primary.value}', 'outline-offset': '2px'}),
    ]),
    css('.sd-counter', [
      css('&').styles(
        position: Position.absolute(left: 2.rem),
        color: AppColors.textSecondary,
        fontSize: 0.85.rem,
        raw: {'top': '6.4rem', 'font-variant-numeric': 'tabular-nums', 'white-space': 'nowrap'},
      ),
    ]),
    // One slot per project. The stage is 100dvh and sticks for the extra
    // 30dvh of the slot, then scrolls away as the next slot arrives.
    css('.sd-slot', [
      css('&').styles(raw: {'height': '130dvh'}),
    ]),
    css('.sd-stage', [
      css('&').styles(
        position: Position.sticky(top: Unit.zero),
        display: Display.grid,
        alignItems: AlignItems.center,
        gap: Gap.all(3.rem),
        padding: Padding.symmetric(horizontal: 4.rem),
        overflow: Overflow.hidden,
        raw: {
          'height': '100dvh',
          'grid-template-columns': 'minmax(0, 26rem) minmax(0, 1fr)',
          'padding-block': '6rem 2rem',
          'padding-right': '12rem',
          'background': 'radial-gradient(circle at 65% 50%, color-mix(in srgb, var(--accent) 16%, ${AppColors.background.value}) 0%, ${AppColors.background.value} 65%)',
        },
      ),
    ]),
    css('.sd-media', [
      css('&').styles(raw: {'min-width': '0'}),
      // Short laptops: never let the screenshots outgrow the stage.
      css('.gal').styles(raw: {'--h': 'min(30rem, 56dvh)'}),
    ]),
    css('.sd-info', [
      css('&').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        gap: Gap.all(1.1.rem),
        raw: {'min-width': '0', 'max-height': 'calc(100dvh - 9rem)', 'overflow-y': 'auto', 'scrollbar-width': 'thin'},
      ),
    ]),
    css('.sd-title', [
      css('&').styles(
        color: AppColors.textPrimary,
        fontSize: Unit.expression('clamp(1.75rem, 3.4vw, 2.75rem)'),
        lineHeight: Unit.expression('1.12'),
      ),
    ]),
    css('.sd-meta', [
      css('&').styles(margin: Margin.zero, color: AppColors.textTertiary, fontSize: 0.85.rem),
    ]),
    css('.sd-description', [
      css('&').styles(
        margin: Margin.zero,
        color: AppColors.textSecondary,
        lineHeight: Unit.expression('1.7'),
        maxWidth: Unit.expression('65ch'),
        // Never truncate the description: if a very long one does not fit a short
        // screen, the info column scrolls instead (see .sd-info).
        raw: {'overflow-wrap': 'break-word'},
      ),
    ]),
    css('.sd-tech', [
      css('&').styles(
        display: Display.flex,
        flexWrap: FlexWrap.wrap,
        gap: Gap.all(0.45.rem),
        margin: Margin.zero,
        padding: Padding.zero,
        raw: {'list-style': 'none'},
      ),
      css('li').styles(
        padding: Padding.symmetric(horizontal: 0.7.rem, vertical: 0.3.rem),
        radius: BorderRadius.circular(0.5.rem),
        border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.18), width: 1.px),
        color: AppColors.textPrimary,
        fontSize: 0.78.rem,
      ),
    ]),
    css('.sd-links', [
      css('&').styles(display: Display.flex, flexWrap: FlexWrap.wrap, alignItems: AlignItems.center, gap: Gap.all(0.7.rem)),
    ]),
    css('.sd-link, .sd-cta', [
      css('&').styles(
        display: Display.inlineFlex,
        alignItems: AlignItems.center,
        minHeight: 2.75.rem,
        padding: Padding.symmetric(horizontal: 1.1.rem),
        radius: BorderRadius.circular(0.5.rem),
        textDecoration: TextDecoration.none,
        fontSize: 0.9.rem,
        fontWeight: FontWeight.w600,
        raw: {'transition': 'transform 160ms cubic-bezier(0.23, 1, 0.32, 1)'},
      ),
      css('&:active').styles(transform: Transform.scale(0.97)),
      css('&:focus-visible').styles(raw: {'outline': '2px solid ${AppColors.primary.value}', 'outline-offset': '3px'}),
    ]),
    css('.sd-link', [
      css('&').styles(color: AppColors.textPrimary, border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.3), width: 1.px)),
    ]),
    css('.sd-cta', [
      css('&').styles(backgroundColor: AppColors.primary, color: AppColors.background),
    ]),
    css('.sd-soon', [css('&').styles(color: AppColors.textSecondary, fontSize: 0.9.rem)]),
    // Tablets and phones: no sticky stage, projects simply stack.
    css.media(MediaQuery.screen(maxWidth: Breakpoints.tablet.px), [
      css('.sd-slot').styles(raw: {'height': 'auto'}),
      css('.sd-stage').styles(
        position: Position.static,
        raw: {
          'height': 'auto',
          'grid-template-columns': 'minmax(0, 1fr)',
          'padding': '3rem 1.25rem',
          'background': 'none',
          'border-top': '1px solid color-mix(in srgb, var(--accent) 60%, transparent)',
        },
      ),
      css('.sd-stage .gal').styles(raw: {'--h': '24rem'}),
      // Stacked layout: the page scrolls, not the info column.
      css('.sd-info').styles(raw: {'max-height': 'none', 'overflow-y': 'visible'}),

    ]),
  ];
}

class _ProjectStageShowcaseState extends State<ProjectStageShowcase> {
  int _active = 0;

  late final List<ProjectView> _views = [for (final p in component.projects) ProjectView.fromMap(p)];

  String _slotId(int i) => 'sd-slot-$i';

  @override
  void initState() {
    super.initState();
    listenScroll(_recompute);
    // Deferred: setState must not run before the first build completes.
    scheduleTimeout(Duration.zero, _recompute);
  }

  void _recompute() {
    if (!mounted || _views.isEmpty) return;
    final probe = scrollY() + viewportHeight() * 0.4;
    var index = 0;
    for (var i = 0; i < _views.length; i++) {
      if (elementOffsetTop(_slotId(i)) <= probe) index = i;
    }
    if (index != _active) setState(() => _active = index);
  }

  void _goTo(int index) => smoothScrollTo(elementOffsetTop(_slotId(index)) + 4);

  @override
  Component build(BuildContext context) {
    if (_views.isEmpty) return div([]);

    return div(classes: 'sd', attributes: {'role': 'region', 'aria-label': 'Projects'}, [
      div(classes: 'sd-chrome', [
        a(href: '#contact', classes: 'sd-skip', [.text('Skip to contact')]),
        span(classes: 'sd-counter', attributes: {'aria-hidden': 'true'}, [.text('Project ${_active + 1} / ${_views.length}')]),
        ul(classes: 'sd-nav', attributes: {'aria-label': 'Jump to project'}, [
          for (final (i, view) in _views.indexed)
            li([
              button(
                classes: 'sd-nav-item',
                attributes: {'type': 'button', 'aria-current': i == _active ? 'true' : 'false'},
                events: {'click': (_) => _goTo(i)},
                [.text(view.title)],
              ),
            ]),
        ]),
      ]),
      for (final (i, view) in _views.indexed) _slot(view, i),
    ]);
  }

  Component _slot(ProjectView view, int index) {
    final headingId = 'sd-title-$index';
    return section(
      id: _slotId(index),
      classes: 'sd-slot',
      attributes: {'aria-labelledby': headingId},
      [
        div(classes: 'sd-stage', styles: Styles(raw: {'--accent': view.accentHex}), [
          div(classes: 'sd-info', [
            h3(id: headingId, classes: 'sd-title', [.text(view.title)]),
            if (view.downloads.isNotEmpty) p(classes: 'sd-meta', [.text(view.downloads)]),
            p(classes: 'sd-description', [.text(view.description)]),
            if (view.tech.isNotEmpty)
              ul(classes: 'sd-tech', attributes: {'aria-label': 'Technologies'}, [
                for (final item in view.tech) li([.text(item)]),
              ]),
            div(classes: 'sd-links', [
              if (view.androidUrl != null)
                a(
                  href: view.androidUrl!,
                  classes: 'sd-link',
                  target: Target.blank,
                  attributes: {'rel': 'noopener', 'aria-label': 'Get ${view.title} on Google Play (opens in a new tab)'},
                  [.text('Google Play')],
                ),
              if (view.iosUrl != null)
                a(
                  href: view.iosUrl!,
                  classes: 'sd-link',
                  target: Target.blank,
                  attributes: {'rel': 'noopener', 'aria-label': 'Get ${view.title} on the App Store (opens in a new tab)'},
                  [.text('App Store')],
                ),
              if (!view.hasStoreLink) span(classes: 'sd-soon', [.text('Coming soon')]),
              a(href: '#contact', classes: 'sd-cta', [.text('Build something like this')]),
            ]),
          ]),
          div(classes: 'sd-media', [
            if (view.images.isNotEmpty)
              ShotGalleryView(title: view.title, images: view.images, eagerFirst: index == 0)
            else if (view.videoUrl != null)
              video(src: view.videoUrl!, controls: true, muted: true, attributes: const {'playsinline': '', 'preload': 'none'}, [])
            else
              div([]),
          ]),
        ]),
      ],
    );
  }
}
