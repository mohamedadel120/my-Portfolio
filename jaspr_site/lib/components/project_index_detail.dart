import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/motion_css.dart';
import '../constants/theme.dart';
import 'project_view.dart';

/// V2-B: an index of every project next to one detail panel. Visitors scan
/// the whole list at a glance and open what interests them; nothing is
/// hijacked from the scroll.
///
/// Every project's panel is in the server-rendered HTML (only the active one
/// is visible; the others carry the `hidden` attribute), so the content is
/// indexable and, if scripts fail, the first project is still fully usable.
/// Project data arrives as plain maps because `@client` constructor
/// parameters must be serialisable.
@client
class ProjectIndexDetail extends StatefulComponent {
  final List<Map<String, dynamic>> projects;

  const ProjectIndexDetail({super.key, required this.projects});

  @override
  State<ProjectIndexDetail> createState() => _ProjectIndexDetailState();

  @css
  static List<StyleRule> get styles => [
    css('.idx', [
      css('&').styles(
        display: Display.grid,
        gap: Gap.all(2.5.rem),
        raw: {'grid-template-columns': 'minmax(12rem, 18rem) minmax(0, 1fr)'},
      ),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.tablet.px), [
        css('&').styles(raw: {'grid-template-columns': 'minmax(0, 1fr)'}),
      ]),
    ]),
    css('.idx-list', [
      css('&').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        gap: Gap.all(0.25.rem),
        margin: Margin.zero,
        padding: Padding.zero,
        raw: {'list-style': 'none', 'align-self': 'start', 'position': 'sticky', 'top': '6rem'},
      ),
      // On narrow screens the index becomes a single scrollable row.
      css.media(MediaQuery.screen(maxWidth: Breakpoints.tablet.px), [
        css('&').styles(
          flexDirection: FlexDirection.row,
          gap: Gap.all(0.5.rem),
          raw: {'position': 'static', 'overflow-x': 'auto', 'padding-bottom': '0.5rem', 'scrollbar-width': 'thin'},
        ),
      ]),
    ]),
    css('.idx-item', [
      css('&').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        gap: Gap.all(0.15.rem),
        width: 100.percent,
        minHeight: 2.75.rem,
        padding: Padding.symmetric(horizontal: 1.rem, vertical: 0.75.rem),
        radius: BorderRadius.circular(0.75.rem),
        border: Border.all(color: Colors.transparent, width: 1.px),
        backgroundColor: Colors.transparent,
        color: AppColors.textSecondary,
        cursor: Cursor.pointer,
        textAlign: TextAlign.left,
        fontFamily: FontFamily.list([AppFonts.body, FontFamilies.monospace]),
        raw: {'transition': 'background-color 160ms ease, color 160ms ease, transform 160ms cubic-bezier(0.23, 1, 0.32, 1)'},
      ),
      css('&:active').styles(transform: Transform.scale(0.98)),
      css('&:focus-visible').styles(raw: {'outline': '2px solid ${AppColors.primary.value}', 'outline-offset': '2px'}),
      css('&[aria-current="true"]').styles(
        color: AppColors.textPrimary,
        backgroundColor: AppColors.surface,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4), width: 1.px),
      ),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.tablet.px), [
        css('&').styles(raw: {'flex': '0 0 auto', 'width': 'auto'}),
      ]),
    ]),
    css('.idx-name', [css('&').styles(fontSize: 1.rem, fontWeight: FontWeight.w600)]),
    css('.idx-stack', [
      css('&').styles(fontSize: 0.75.rem, color: AppColors.textTertiary),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.tablet.px), [css('&').styles(display: Display.none)]),
    ]),
    css('.idx-panel', [
      css('&').styles(
        display: Display.grid,
        gap: Gap.all(2.rem),
        raw: {'grid-template-columns': 'minmax(0, 16rem) minmax(0, 1fr)', 'align-items': 'start'},
      ),
      css('&[hidden]').styles(display: Display.none),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile.px), [
        css('&').styles(raw: {'grid-template-columns': 'minmax(0, 1fr)'}),
      ]),
    ]),
    MotionRule.allowed([
      css('.idx-panel:not([hidden])').styles(raw: {'animation': 'idxIn 220ms cubic-bezier(0.23, 1, 0.32, 1)'}),
    ]),
    css.keyframes('idxIn', {
      'from': Styles(opacity: 0, transform: Transform.translate(y: 8.px)),
      'to': Styles(opacity: 1, transform: Transform.translate(y: 0.px)),
    }),
    css('.idx-media', [
      css('&').styles(display: Display.flex, flexDirection: FlexDirection.column, gap: Gap.all(0.75.rem)),
    ]),
    css('.idx-screen', [
      css('&').styles(
        width: 100.percent,
        maxWidth: 16.rem,
        radius: BorderRadius.circular(1.75.rem),
        border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.15), width: 1.px),
        backgroundColor: AppColors.surface,
        overflow: Overflow.hidden,
        raw: {
          'aspect-ratio': '9 / 19.5',
          'box-shadow': '0 24px 48px -20px color-mix(in srgb, var(--accent) 50%, transparent)',
        },
      ),
      css('img, video').styles(width: 100.percent, height: 100.percent, raw: {'object-fit': 'cover', 'display': 'block'}),
    ]),
    css('.idx-thumbs', [
      css('&').styles(
        display: Display.flex,
        flexWrap: FlexWrap.wrap,
        gap: Gap.all(0.4.rem),
        margin: Margin.zero,
        padding: Padding.zero,
        raw: {'list-style': 'none'},
      ),
      css('button').styles(
        width: 2.75.rem,
        height: 2.75.rem,
        padding: Padding.zero,
        radius: BorderRadius.circular(0.5.rem),
        border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.2), width: 1.px),
        backgroundColor: AppColors.surface,
        overflow: Overflow.hidden,
        cursor: Cursor.pointer,
      ),
      css('button[aria-current="true"]').styles(border: Border.all(color: AppColors.primary, width: 2.px)),
      css('button:focus-visible').styles(raw: {'outline': '2px solid ${AppColors.primary.value}', 'outline-offset': '2px'}),
      css('img').styles(width: 100.percent, height: 100.percent, raw: {'object-fit': 'cover', 'display': 'block'}),
    ]),
    css('.idx-info', [
      css('&').styles(display: Display.flex, flexDirection: FlexDirection.column, gap: Gap.all(1.25.rem)),
    ]),
    css('.idx-title', [
      css('&').styles(
        color: AppColors.textPrimary,
        fontSize: Unit.expression('clamp(1.6rem, 3.5vw, 2.4rem)'),
        lineHeight: Unit.expression('1.15'),
      ),
    ]),
    css('.idx-description', [
      css('&').styles(
        margin: Margin.zero,
        color: AppColors.textSecondary,
        lineHeight: Unit.expression('1.75'),
        maxWidth: Unit.expression('65ch'),
      ),
    ]),
    css('.idx-facts', [
      css('&').styles(display: Display.flex, flexDirection: FlexDirection.column, gap: Gap.all(0.9.rem), margin: Margin.zero),
      css('dt').styles(color: AppColors.textTertiary, fontSize: 0.8.rem),
      css('dd').styles(margin: Margin.only(top: 0.2.rem), color: AppColors.textPrimary, maxWidth: Unit.expression('65ch'), lineHeight: Unit.expression('1.6')),
    ]),
    css('.idx-tech', [
      css('&').styles(
        display: Display.flex,
        flexWrap: FlexWrap.wrap,
        gap: Gap.all(0.5.rem),
        margin: Margin.zero,
        padding: Padding.zero,
        raw: {'list-style': 'none'},
      ),
      css('li').styles(
        padding: Padding.symmetric(horizontal: 0.75.rem, vertical: 0.35.rem),
        radius: BorderRadius.circular(0.5.rem),
        border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.18), width: 1.px),
        color: AppColors.textPrimary,
        fontSize: 0.8.rem,
      ),
    ]),
    css('.idx-links', [
      css('&').styles(display: Display.flex, flexWrap: FlexWrap.wrap, alignItems: AlignItems.center, gap: Gap.all(0.75.rem)),
    ]),
    css('.idx-link, .idx-cta', [
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
    css('.idx-link', [
      css('&').styles(color: AppColors.textPrimary, border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.3), width: 1.px)),
    ]),
    css('.idx-cta', [
      css('&').styles(backgroundColor: AppColors.primary, color: AppColors.background),
    ]),
    css('.idx-soon', [css('&').styles(color: AppColors.textSecondary, fontSize: 0.9.rem)]),
  ];
}

class _ProjectIndexDetailState extends State<ProjectIndexDetail> {
  int _active = 0;
  int _shot = 0;

  late final List<ProjectView> _views = [for (final p in component.projects) ProjectView.fromMap(p)];

  void _select(int index) {
    if (index == _active) return;
    setState(() {
      _active = index;
      _shot = 0;
    });
  }

  @override
  Component build(BuildContext context) {
    if (_views.isEmpty) return div([]);

    return div(classes: 'idx', [
      ul(classes: 'idx-list', attributes: {'aria-label': 'Projects'}, [
        for (final (i, view) in _views.indexed)
          li([
            button(
              classes: 'idx-item',
              attributes: {
                'type': 'button',
                'aria-controls': 'idx-panel-$i',
                'aria-current': i == _active ? 'true' : 'false',
              },
              events: {'click': (_) => _select(i)},
              [
                span(classes: 'idx-name', [.text(view.title)]),
                if (view.tech.isNotEmpty) span(classes: 'idx-stack', [.text(view.tech.take(3).join(', '))]),
              ],
            ),
          ]),
      ]),
      div([for (final (i, view) in _views.indexed) _panel(view, i)]),
    ]);
  }

  Component _panel(ProjectView view, int index) {
    final isActive = index == _active;
    final shot = isActive ? _shot.clamp(0, view.images.isEmpty ? 0 : view.images.length - 1) : 0;

    return div(
      id: 'idx-panel-$index',
      classes: 'idx-panel',
      styles: Styles(raw: {'--accent': view.accentHex}),
      attributes: {'role': 'region', 'aria-label': view.title, if (!isActive) 'hidden': ''},
      [
        div(classes: 'idx-media', [
          div(classes: 'idx-screen', [
            if (view.images.isNotEmpty)
              img(
                src: view.images[shot],
                alt: '${view.title} screenshot ${shot + 1} of ${view.images.length}',
                attributes: {'decoding': 'async', if (index != 0) 'loading': 'lazy'},
              )
            else if (view.videoUrl != null)
              video(src: view.videoUrl!, controls: true, muted: true, attributes: const {'playsinline': '', 'preload': 'none'}, [])
            else
              div([]),
          ]),
          if (view.images.length > 1)
            ul(classes: 'idx-thumbs', attributes: {'aria-label': '${view.title} screenshots'}, [
              for (final (j, src) in view.images.indexed)
                li([
                  button(
                    attributes: {
                      'type': 'button',
                      'aria-label': 'Show screenshot ${j + 1} of ${view.images.length}',
                      'aria-current': j == shot ? 'true' : 'false',
                    },
                    events: {'click': (_) => setState(() => _shot = j)},
                    [img(src: src, alt: '', attributes: const {'loading': 'lazy', 'decoding': 'async'})],
                  ),
                ]),
            ]),
        ]),
        div(classes: 'idx-info', [
          h3(classes: 'idx-title', [.text(view.title)]),
          if (view.downloads.isNotEmpty) p(classes: 'idx-description', [.text(view.downloads)]),
          p(classes: 'idx-description', [.text(view.description)]),
          if (view.facts.isNotEmpty)
            dl(classes: 'idx-facts', [
              for (final (label, value) in view.facts)
                div([
                  dt([.text(label)]),
                  dd([.text(value)]),
                ]),
            ]),
          if (view.tech.isNotEmpty)
            ul(classes: 'idx-tech', attributes: {'aria-label': 'Technologies'}, [
              for (final item in view.tech) li([.text(item)]),
            ]),
          div(classes: 'idx-links', [
            if (view.androidUrl != null)
              a(
                href: view.androidUrl!,
                classes: 'idx-link',
                target: Target.blank,
                attributes: {'rel': 'noopener', 'aria-label': 'Get ${view.title} on Google Play (opens in a new tab)'},
                [.text('Google Play')],
              ),
            if (view.iosUrl != null)
              a(
                href: view.iosUrl!,
                classes: 'idx-link',
                target: Target.blank,
                attributes: {'rel': 'noopener', 'aria-label': 'Get ${view.title} on the App Store (opens in a new tab)'},
                [.text('App Store')],
              ),
            if (!view.hasStoreLink) span(classes: 'idx-soon', [.text('Coming soon')]),
            a(href: '#contact', classes: 'idx-cta', [.text('Build something like this')]),
          ]),
        ]),
      ],
    );
  }
}
