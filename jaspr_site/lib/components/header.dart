import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'header_scroll.vm.dart' if (dart.library.js_interop) 'header_scroll.web.dart';
import '../constants/theme.dart';

/// Ported from the Flutter app's `_InteractiveNavBar` (in
/// features/home/presentation/pages/home_page.dart) and `NavBarItem`
/// (widgets/navigation/nav_bar_item.dart) — logo, section links, CV button,
/// and a background that solidifies on scroll. The nav links render as a
/// "tubelight" pill capsule (backdrop-blurred rounded group, active item
/// gets a filled pill + a glowing bar above it), done in pure CSS instead
/// of the framer-motion `layoutId` spring the reference React version
/// uses. Links point at `/#section-id` so they work the same whether
/// you're already on `/` or navigating from `/about`, `/projects`, `/contact`.
///
/// Note: the Flutter app also wires up a `ThemeController.toggleTheme()`,
/// but no widget anywhere in the app ever calls it — there's no visible
/// light/dark toggle in the current UI, it's dead plumbing defaulting to
/// dark mode. Not porting a toggle button that never existed; `data-theme`
/// CSS variables are still in place in constants/theme.dart if that
/// changes later.
@client
class Header extends StatefulComponent {
  final String cvUrl;

  const Header({super.key, required this.cvUrl});

  @override
  State<Header> createState() => _HeaderState();

  @css
  static List<StyleRule> get styles => [
    css('.nav-bar', [
      css('&').styles(
        position: Position.fixed(top: Unit.zero, left: Unit.zero, right: Unit.zero),
        zIndex: ZIndex(100),
        padding: Padding.symmetric(horizontal: 2.5.rem, vertical: 1.5.rem),
        backgroundColor: AppColors.background.withValues(alpha: 0),
        transition: Transition('background-color', duration: 300.ms),
      ),
      css('&.scrolled').styles(
        backgroundColor: AppColors.background.withValues(alpha: 0.85),
        border: Border.only(
          bottom: BorderSide.solid(color: AppColors.primary.withValues(alpha: 0.15), width: 1.px),
        ),
      ),
      css('.nav-inner', [
        css('&').styles(
          display: Display.flex,
          alignItems: AlignItems.center,
          justifyContent: JustifyContent.spaceBetween,
          maxWidth: 1400.px,
          margin: Margin.symmetric(horizontal: Unit.auto),
        ),
      ]),
      css('.nav-logo', [
        css('&').styles(raw: {'transition': 'filter 250ms ease, transform 250ms ease'}),
        css('&:hover').styles(
          transform: Transform.scale(1.08),
          raw: {'filter': 'drop-shadow(0 0 10px ${AppColors.primary.withValues(alpha: 0.6).value})'},
        ),
      ]),
      css('.nav-logo img', [
        css('&').styles(height: 3.25.rem),
      ]),
      // "Tubelight" pill nav: a floating rounded capsule around the links,
      // each item pill-shaped, with a glowing bar ("lamp") fading in above
      // whichever one is active -- same links/hrefs/active-section logic as
      // before, just a capsule instead of plain inline text with brackets.
      css('.nav-links', [
        css('&').styles(
          display: Display.flex,
          alignItems: AlignItems.center,
          gap: Gap.all(0.3.rem),
          backgroundColor: AppColors.textPrimary.withValues(alpha: 0.05),
          border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.1), width: 1.px),
          radius: BorderRadius.circular(999.px),
          padding: Padding.all(0.45.rem),
          raw: {
            'backdrop-filter': 'blur(12px)',
            'box-shadow': '0 4px 20px rgba(0, 0, 0, 0.3)',
          },
        ),
        css('a', [
          css('&').styles(
            position: Position.relative(),
            display: Display.inlineBlock,
            color: AppColors.textSecondary,
            textDecoration: TextDecoration.none,
            fontFamily: FontFamily.list([FontFamily('Fira Code'), FontFamilies.monospace]),
            fontSize: 1.rem,
            fontWeight: FontWeight.w600,
            padding: Padding.symmetric(horizontal: 1.6.rem, vertical: 0.85.rem),
            radius: BorderRadius.circular(999.px),
            raw: {'transition': 'color 200ms, background-color 200ms'},
          ),
          css('&:hover').styles(color: AppColors.primary),
          css('&::before').styles(
            content: '',
            position: Position.absolute(top: (-0.5).rem, left: 50.percent),
            width: 2.rem,
            height: 0.2.rem,
            backgroundColor: AppColors.primary,
            radius: BorderRadius.only(topLeft: Radius.circular(999.px), topRight: Radius.circular(999.px)),
            opacity: 0,
            raw: {
              'transform': 'translateX(-50%)',
              'box-shadow': '0 0 16px 2px ${AppColors.primary.withValues(alpha: 0.6).value}',
              'transition': 'opacity 250ms ease',
            },
          ),
        ]),
        // Marks whichever link matches the section currently scrolled into
        // view -- same idea as the .nav-dot.active state in the Projects
        // showcase, just driven by section position instead of an index.
        css('a.active', [
          css('&').styles(color: AppColors.primary, backgroundColor: AppColors.primary.withValues(alpha: 0.08)),
          css('&::before').styles(opacity: 1),
          // The old inline "< LABEL />" bracket motif, now scoped to just
          // the active pill instead of every link's hover state.
          css('.nav-label::before').styles(
            content: '<',
            color: AppColors.secondary,
            margin: Margin.only(right: 0.3.rem),
          ),
          css('.nav-label::after').styles(
            content: '/>',
            color: AppColors.secondary,
            margin: Margin.only(left: 0.3.rem),
          ),
        ]),
      ]),
      css('.cv-button', [
        css('&').styles(
          backgroundColor: AppColors.primary,
          color: Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: 0.85.rem,
          padding: Padding.symmetric(horizontal: 1.6.rem, vertical: 1.rem),
          radius: BorderRadius.circular(4.px),
          textDecoration: TextDecoration.none,
          letterSpacing: 1.px,
          display: Display.inlineBlock,
          raw: {'transition': 'transform 200ms ease, box-shadow 200ms ease'},
        ),
        css('&:hover').styles(
          transform: Transform.scale(1.08),
          raw: {'box-shadow': '0 0 20px 2px ${AppColors.primary.withValues(alpha: 0.5).value}'},
        ),
      ]),
      css('.menu-toggle', [
        css('&').styles(
          backgroundColor: Colors.transparent,
          border: Border.none,
          color: AppColors.primary,
          fontSize: 1.5.rem,
          cursor: Cursor.pointer,
        ),
      ]),
      css('.desktop-only', [
        css('&').styles(display: Display.flex),
        css.media(MediaQuery.screen(maxWidth: Breakpoints.tablet.px), [
          css('&').styles(display: Display.none),
        ]),
      ]),
      css('.mobile-only', [
        css('&').styles(display: Display.none),
        css.media(MediaQuery.screen(maxWidth: Breakpoints.tablet.px), [
          css('&').styles(display: Display.flex),
        ]),
      ]),
    ]),
    css('.mobile-menu', [
      css('&').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.center,
        gap: Gap.all(1.5.rem),
        position: Position.fixed(top: Unit.zero, left: Unit.zero, right: Unit.zero, bottom: Unit.zero),
        zIndex: ZIndex(99),
        backgroundColor: AppColors.background.withValues(alpha: 0.97),
      ),
      css('a', [
        css('&').styles(
          color: AppColors.textPrimary,
          textDecoration: TextDecoration.none,
          fontFamily: FontFamily.list([FontFamily('Anton'), FontFamilies.sansSerif]),
          fontSize: 2.5.rem,
          letterSpacing: 1.px,
          opacity: 0,
          animation: Animation(
            name: 'fade-in-up',
            duration: 500.ms,
            fillMode: AnimationFillMode.forwards,
          ),
        ),
      ]),
      css('.mobile-menu-footer', [
        css('&').styles(
          position: Position.absolute(bottom: 2.5.rem),
          color: AppColors.textTertiary,
          fontSize: 0.7.rem,
          letterSpacing: 2.px,
        ),
      ]),
    ]),
    css.keyframes('fade-in-up', {
      '0%': Styles(opacity: 0, transform: Transform.translate(y: 30.px)),
      '100%': Styles(opacity: 1, transform: Transform.translate(y: 0.px)),
    }),
  ];
}

class _HeaderState extends State<Header> {
  bool _scrolled = false;
  bool _menuOpen = false;
  String? _activeSection;

  static const _links = [
    (label: 'HOME', href: '/#hero', id: 'hero'),
    (label: 'ABOUT', href: '/#about', id: 'about'),
    (label: 'EXPERTISE', href: '/#expertise', id: 'expertise'),
    (label: 'EXPERIENCE', href: '/#experience', id: 'experience'),
    (label: 'PROJECTS', href: '/#projects', id: 'projects'),
    (label: 'CONTACT', href: '/#contact', id: 'contact'),
  ];

  @override
  void initState() {
    super.initState();
    listenForScroll((scrolled) => setState(() => _scrolled = scrolled));
    listenForActiveSection(
      [for (final link in _links) link.id],
      (id) => setState(() => _activeSection = id),
    );
  }

  @override
  Component build(BuildContext context) {
    return header(classes: _scrolled ? 'nav-bar scrolled' : 'nav-bar', [
      div(classes: 'nav-inner', [
        a(href: '/#hero', classes: 'nav-logo', [
          img(src: 'images/logo1.png', alt: 'Mohamed Adel'),
        ]),
        nav(classes: 'nav-links desktop-only', [
          for (final link in _links)
            a(href: link.href, classes: link.id == _activeSection ? 'active' : null, [
              span(classes: 'nav-label', [.text(link.label)]),
            ]),
        ]),
        a(
          href: component.cvUrl,
          classes: 'cv-button desktop-only',
          attributes: const {'target': '_blank', 'rel': 'noopener noreferrer'},
          [.text('DOWNLOAD CV')],
        ),
        button(
          classes: 'menu-toggle mobile-only',
          attributes: {'aria-label': 'Toggle menu'},
          events: {'click': (_) => setState(() => _menuOpen = !_menuOpen)},
          [.text(_menuOpen ? '✕' : '☰')],
        ),
      ]),
      if (_menuOpen)
        div(classes: 'mobile-menu', [
          for (final (i, link) in _links.indexed)
            a(
              href: link.href,
              styles: Styles(raw: {'animation-delay': '${i * 80}ms'}),
              events: {'click': (_) => setState(() => _menuOpen = false)},
              [.text(link.label)],
            ),
          p(classes: 'mobile-menu-footer', [.text('© 2026 MOHAMED ADEL')]),
        ]),
    ]);
  }
}
