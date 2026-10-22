import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import '../constants/theme.dart';
import '../data/testimonials_repository.dart';

/// Ported from the Flutter app's `TestimonialsSection`/`_TestimonialCard` —
/// quote icon, opinion, a fading divider and the author line, in a
/// two-column grid, with the author's name above their role and company.
/// No star rating: every stored `rating` was 5, which reads as a claim
/// nobody confirmed (the site shows no ratings until they are real).
class TestimonialsSection extends AsyncStatelessComponent {
  const TestimonialsSection({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final testimonials = await fetchTestimonials();

    return section(id: 'testimonials', classes: 'testimonials', [
      h2(classes: 'section-title', [.text('Their Opinions')]),
      div(classes: 'testimonials-grid', [
        for (final (i, t) in testimonials.indexed)
          figure(
            classes: 'testimonial-card reveal',
            styles: Styles(raw: {'--reveal-delay': '${i * 100}ms'}),
            [
              span(
                classes: 'material-symbols-rounded testimonial-quote-icon',
                attributes: {'aria-hidden': 'true'},
                [
                  .text('format_quote'),
                ],
              ),
              blockquote(classes: 'testimonial-opinion', [.text(t.opinion)]),
              div(classes: 'testimonial-divider', []),
              figcaption(classes: 'testimonial-author', [
                span(classes: 'testimonial-name', [.text(t.name)]),
                span(classes: 'testimonial-role', [
                  .text([t.role, t.company].where((part) => part.isNotEmpty).join(' • ')),
                ]),
              ]),
            ],
          ),
      ]),
    ]);
  }

  // The staggered reveal delay applies only to the scroll-in fade/slide
  // (`transform`); the hover lift uses the separate `translate` property so it
  // responds immediately instead of waiting out the card's stagger delay.
  static const _transition =
      'opacity 600ms ease-out var(--reveal-delay, 0ms), transform 600ms ease-out var(--reveal-delay, 0ms), '
      'translate 300ms ease, border-color 300ms ease, box-shadow 300ms ease';

  @css
  static List<StyleRule> get styles => [
    css('.testimonials', [
      css('&').styles(
        padding: Padding.symmetric(horizontal: 3.75.rem, vertical: 6.25.rem),
      ),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile.px), [
        css('&').styles(
          padding: Padding.symmetric(horizontal: 1.25.rem, vertical: 4.rem),
        ),
      ]),
    ]),
    css('.testimonials-grid', [
      css('&').styles(
        display: Display.grid,
        gap: Gap.all(1.75.rem),
        margin: Margin.only(top: 4.5.rem),
        raw: {'grid-template-columns': 'repeat(2, minmax(0, 1fr))'},
      ),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.tablet.px), [
        css('&').styles(raw: {'grid-template-columns': 'minmax(0, 1fr)'}),
      ]),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile.px), [
        css('&').styles(
          gap: Gap.all(1.25.rem),
          margin: Margin.only(top: 3.rem),
        ),
      ]),
    ]),
    css('.testimonial-card', [
      css('&').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        margin: Margin.zero,
        padding: Padding.all(2.rem),
        radius: BorderRadius.circular(1.5.rem),
        raw: {
          'background': themed(
            'linear-gradient(135deg, ${AppColors.primary.withValues(alpha: 0.1).value}, '
                '${AppColors.secondary.withValues(alpha: 0.08).value} 50%, ${AppColors.surface.value})',
            calm: AppColors.surface.value,
          ),
          'border': '${themed('1.5px', calm: '1px')} solid ${AppColors.outline(0.2).value}',
          'box-shadow': '0 4px 20px ${AppColors.glow(0.1).value}',
        },
      ),
      // Beats the global `.reveal` transition on specificity.
      css('&.reveal').styles(raw: {'transition': _transition}),
      css('&.reveal.revealed:hover').styles(
        raw: {
          'translate': '0 -6px',
          'border-color': AppColors.primary.withValues(alpha: 0.4).value,
          'box-shadow': '0 8px 30px ${AppColors.glow(0.25).value}',
        },
      ),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile.px), [
        css('&').styles(padding: Padding.all(1.5.rem)),
      ]),
    ]),
    css('.testimonial-quote-icon', [
      css('&').styles(
        alignSelf: AlignSelf.start,
        color: AppColors.primary,
        fontSize: 2.rem,
        padding: Padding.all(0.625.rem),
        radius: BorderRadius.circular(0.75.rem),
        raw: {
          'background': themed(
            'linear-gradient(90deg, ${AppColors.primary.withValues(alpha: 0.3).value}, ${AppColors.secondary.withValues(alpha: 0.2).value})',
            calm: AppColors.primary.withValues(alpha: 0.1).value,
          ),
        },
      ),
    ]),
    css('.testimonial-opinion', [
      css('&').styles(
        flex: Flex(grow: 1),
        margin: Margin.fromLTRB(Unit.zero, 1.25.rem, Unit.zero, Unit.zero),
        color: AppColors.textPrimary.withValues(alpha: 0.95),
        fontFamily: AppFonts.of(FontRole.text, was: AppFonts.jetBrainsMono),
        fontSize: AppType.size(TypeStep.body, was: 1.rem),
        // No italic file is loaded in the new directions; a synthesized slant
        // reads worse than upright text.
        fontStyle: themed(FontStyle.italic, calm: FontStyle.normal),
        lineHeight: Unit.expression('1.7'),
        letterSpacing: themed(0.2.px, calm: null),
      ),
    ]),
    css('.testimonial-divider', [
      css('&').styles(
        height: 1.px,
        margin: Margin.symmetric(vertical: 1.5.rem),
        raw: {'background': 'linear-gradient(90deg, ${AppColors.primary.withValues(alpha: 0.3).value}, transparent)'},
      ),
    ]),
    css('.testimonial-author', [
      css('&').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        gap: Gap.all(0.25.rem),
        fontFamily: AppFonts.of(FontRole.text, was: AppFonts.jetBrainsMono),
      ),
    ]),
    css('.testimonial-name', [
      css('&').styles(
        color: themed(AppColors.primary, calm: AppColors.textPrimary),
        fontSize: AppType.size(TypeStep.body, was: 1.05.rem),
        fontWeight: FontWeight.w700,
      ),
    ]),
    css('.testimonial-role', [
      css('&').styles(color: AppColors.textSecondary, fontSize: AppType.size(TypeStep.small, was: 0.875.rem)),
    ]),
  ];
}
