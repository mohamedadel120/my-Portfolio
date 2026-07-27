import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import '../components/contact_form.dart';
import '../constants/theme.dart';
import '../data/contact_repository.dart';

/// Ported from `ContactDesktopView` + `ContactInfoItem`/`ContactButton`.
/// The form itself is the one interactive piece of the whole site (see
/// components/contact_form.dart, a `@client` component) — everything else
/// here is static, server-rendered content.
class ContactSection extends AsyncStatelessComponent {
  const ContactSection({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final contact = await fetchContactData();

    return section(id: 'contact', classes: 'contact', [
      h2(classes: 'section-title', [.text('Get In Touch')]),
      p(classes: 'contact-subtitle', [.text("Let's build something amazing together!")]),
      div(classes: 'contact-grid', [
        div(classes: 'reveal', [ContactForm(recipientEmail: contact.email)]),
        div(
          classes: 'contact-side reveal',
          styles: Styles(raw: {'transition-delay': '120ms'}),
          [
          div(classes: 'contact-info-card', [
            _infoRow('mail', 'Email', contact.email, 'mailto:${contact.email}'),
            _infoRow('call', 'Phone', contact.phone, 'tel:${contact.phone}'),
            _infoRow('location_on', 'Location', contact.location, null),
          ]),
          div(classes: 'social-card', [
            p(classes: 'social-heading', [.text('Connect With Me')]),
            for (final link in contact.socialLinks)
              a(
                href: link.url,
                classes: link.name == 'GitHub' ? 'social-button secondary' : 'social-button',
                [
                  span(classes: 'material-symbols-rounded', [.text(link.iconKey)]),
                  .text(link.name),
                ],
              ),
          ]),
        ]),
      ]),
      p(classes: 'contact-footer', [.text('© 2026 Mohamed Adel - Flutter Developer Portfolio. Built with ❤️ using Flutter')]),
    ]);
  }

  Component _infoRow(String icon, String label, String value, String? href) {
    final content = [
      span(classes: 'material-symbols-rounded info-icon', [.text(icon)]),
      div([
        p(classes: 'info-label', [.text(label)]),
        p(classes: 'info-value', [.text(value)]),
      ]),
    ];
    return href != null ? a(href: href, classes: 'info-row', content) : div(classes: 'info-row', content);
  }

  @css
  static List<StyleRule> get styles => [
    css('.contact', [
      css('&').styles(padding: Padding.symmetric(horizontal: 3.75.rem, vertical: 6.25.rem)),
    ]),
    css('.contact-subtitle', [
      css('&').styles(
        color: AppColors.textSecondary,
        fontFamily: FontFamily.list([FontFamily('JetBrains Mono'), FontFamilies.monospace]),
        fontSize: 1.1.rem,
        margin: Margin.only(top: 1.5.rem),
      ),
    ]),
    css('.contact-grid', [
      css('&').styles(
        display: Display.grid,
        gridTemplate: GridTemplate(
          columns: GridTracks([GridTrack(TrackSize.fr(2)), GridTrack(TrackSize.fr(1))]),
        ),
        gap: Gap.all(2.5.rem),
        margin: Margin.only(top: 3.75.rem),
      ),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.tablet.px), [
        css('&').styles(gridTemplate: GridTemplate(columns: GridTracks([GridTrack(TrackSize.fr(1))]))),
      ]),
    ]),
    css('.contact-side', [
      css('&').styles(display: Display.flex, flexDirection: FlexDirection.column, gap: Gap.all(1.5.rem)),
    ]),
    css('.contact-info-card', [
      css('&').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        gap: Gap.all(1.25.rem),
        padding: Padding.all(1.75.rem),
        backgroundColor: AppColors.surface,
        radius: BorderRadius.circular(1.25.rem),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1.5.px),
      ),
    ]),
    css('.info-row', [
      css('&').styles(
        display: Display.flex,
        alignItems: AlignItems.center,
        gap: Gap.all(1.rem),
        textDecoration: TextDecoration.none,
      ),
      css('.info-icon').styles(
        color: AppColors.primary,
        fontSize: 1.5.rem,
        padding: Padding.all(0.5.rem),
        radius: BorderRadius.circular(0.6.rem),
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
      ),
      css('.info-label').styles(
        color: AppColors.textTertiary,
        fontFamily: FontFamily.list([FontFamily('Space Mono'), FontFamilies.monospace]),
        fontSize: 0.7.rem,
        letterSpacing: 1.px,
      ),
      css('.info-value').styles(
        color: AppColors.textPrimary,
        fontFamily: FontFamily.list([FontFamily('JetBrains Mono'), FontFamilies.monospace]),
        fontSize: 1.rem,
        margin: Margin.only(top: 0.2.rem),
      ),
    ]),
    css('.social-card', [
      css('&').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        gap: Gap.all(0.9.rem),
        padding: Padding.all(1.5.rem),
        backgroundColor: AppColors.surface,
        radius: BorderRadius.circular(1.25.rem),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 1.px),
      ),
      css('.social-heading').styles(
        color: AppColors.textPrimary,
        fontFamily: FontFamily.list([FontFamily('JetBrains Mono'), FontFamilies.monospace]),
        fontWeight: FontWeight.w700,
        fontSize: 1.1.rem,
      ),
    ]),
    css('.social-button', [
      css('&').styles(
        display: Display.flex,
        alignItems: AlignItems.center,
        gap: Gap.all(0.75.rem),
        color: AppColors.primary,
        textDecoration: TextDecoration.none,
        fontFamily: FontFamily.list([FontFamily('JetBrains Mono'), FontFamilies.monospace]),
        fontWeight: FontWeight.w600,
        fontSize: 0.95.rem,
        padding: Padding.symmetric(vertical: 0.75.rem, horizontal: 1.rem),
        radius: BorderRadius.circular(0.75.rem),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.4), width: 1.5.px),
      ),
      css('&.secondary').styles(color: AppColors.secondary, border: Border.all(color: AppColors.secondary.withValues(alpha: 0.4), width: 1.5.px)),
    ]),
    css('.contact-footer', [
      css('&').styles(
        margin: Margin.only(top: 3.75.rem),
        padding: Padding.all(1.25.rem),
        textAlign: TextAlign.center,
        color: AppColors.textPrimary.withValues(alpha: 0.5),
        fontFamily: FontFamily.list([FontFamily('JetBrains Mono'), FontFamilies.monospace]),
        fontSize: 0.9.rem,
        backgroundColor: AppColors.surface.withValues(alpha: 0.9),
        radius: BorderRadius.circular(0.9.rem),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1.5.px),
      ),
    ]),
  ];
}
