import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import '../constants/theme.dart';
import '../data/profile_repository.dart';

/// Ported from `AboutDesktopView`'s bento grid (Identity / Impact /
/// Experience / Proficiency tiles) using CSS Grid instead of nested
/// `SizedBox`/`Row`/`Expanded` widgets. Skill bars use a CSS width instead
/// of a scroll-linked `AnimationController`. Every About feature card shows
/// a fixed bolt icon regardless of its `iconCode` Firestore field — that's
/// not a Jaspr limitation, `about_desktop_view.dart` in the Flutter app
/// does the same (the field is fetched but never actually used to pick an
/// icon), so this replicates existing behavior rather than "fixing" it.
class AboutSection extends AsyncStatelessComponent {
  const AboutSection({super.key});

  @override
  Future<Component> build(BuildContext context) async {
    final about = await fetchAboutData();

    return section(id: 'about', classes: 'about', [
      h2(classes: 'section-title', [.text('About Me')]),
      div(classes: 'about-grid', [
        div(classes: 'bento identity reveal', [
          h3(classes: 'bento-title', [.text('Identity')]),
          p(classes: 'identity-headline', [.text('Crafting Exceptional Digital Experiences')]),
          p(classes: 'identity-summary', [.text(about.professionalSummary)]),
        ]),
        div(
          classes: 'bento impact reveal',
          styles: Styles(raw: {'transition-delay': '80ms'}),
          [
            h3(classes: 'bento-title', [.text('Impact')]),
            div(classes: 'impact-stats', [
              div(classes: 'impact-stat', [
                span(classes: 'material-symbols-rounded impact-icon', [.text('download')]),
                span(classes: 'impact-value', [.text(about.downloadsCount)]),
                span(classes: 'impact-label', [.text('DOWNLOADS')]),
              ]),
              div(classes: 'impact-stat', [
                span(classes: 'material-symbols-rounded impact-icon', [.text('star')]),
                span(classes: 'impact-value', [.text(about.ratings)]),
                span(classes: 'impact-label', [.text('RATINGS')]),
              ]),
            ]),
          ],
        ),
        div(
          classes: 'bento features reveal',
          styles: Styles(raw: {'transition-delay': '160ms'}),
          [
            h3(classes: 'bento-title', [.text('Experience')]),
            div(classes: 'feature-grid', [
              for (final feature in about.features)
                div(classes: 'feature-card', [
                  span(classes: 'material-symbols-rounded feature-icon', [.text('bolt')]),
                  p(classes: 'feature-title', [.text(feature.title)]),
                  p(classes: 'feature-description', [.text(feature.description)]),
                ]),
            ]),
          ],
        ),
        div(
          classes: 'bento skills reveal',
          styles: Styles(raw: {'transition-delay': '240ms'}),
          [
          h3(classes: 'bento-title', [.text('Proficiency')]),
          div(classes: 'skill-list', [
            for (final (i, skill) in about.skills.indexed)
              div(classes: 'skill', [
                div(classes: 'skill-header', [
                  span([.text(skill.name)]),
                  span([.text('${(skill.progress * 100).round()}%')]),
                ]),
                div(classes: 'skill-track', [
                  div(
                    classes: skill.isPrimary ? 'skill-fill primary' : 'skill-fill secondary',
                    // The actual width is only reached once the bento tile's
                    // .reveal.revealed class lands (see .skill-fill CSS) --
                    // staggered per bar so they cascade in rather than all
                    // filling in lockstep.
                    styles: Styles(raw: {
                      '--target-width': '${(skill.progress * 100).round()}%',
                      'transition-delay': '${i * 100}ms',
                    }),
                    [],
                  ),
                ]),
              ]),
          ]),
        ]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.about', [
      css('&').styles(padding: Padding.symmetric(horizontal: 3.75.rem, vertical: 6.25.rem)),
    ]),
    css('.about-grid', [
      css('&').styles(
        display: Display.grid,
        gridTemplate: GridTemplate(
          columns: GridTracks([GridTrack(TrackSize.fr(2)), GridTrack(TrackSize.fr(1))]),
        ),
        gap: Gap.all(1.5.rem),
        margin: Margin.only(top: 3.75.rem),
      ),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.tablet.px), [
        css('&').styles(
          gridTemplate: GridTemplate(columns: GridTracks([GridTrack(TrackSize.fr(1))])),
        ),
      ]),
    ]),
    // Left column (Impact, short content) stacks above Skills (tall skill
    // list); Experience spans both of those rows on the right so its one
    // card fills the same total height instead of leaving row 3's right
    // cell empty -- the auto-placed grid used to size Impact's row to
    // match Experience's height (turning two short stats into a mostly
    // empty box) while leaving nothing at all next to the tall Skills list.
    css('.impact', [
      css('&').styles(
        gridPlacement: GridPlacement(rowStart: LinePlacement(2), columnStart: LinePlacement(1)),
        alignSelf: AlignSelf.start,
      ),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.tablet.px), [
        css('&').styles(gridPlacement: GridPlacement.auto, alignSelf: AlignSelf.auto),
      ]),
    ]),
    css('.features', [
      css('&').styles(
        gridPlacement: GridPlacement(
          rowStart: LinePlacement(2),
          rowEnd: LinePlacement.span(2),
          columnStart: LinePlacement(2),
        ),
        display: Display.flex,
        flexDirection: FlexDirection.column,
      ),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.tablet.px), [
        css('&').styles(gridPlacement: GridPlacement.auto),
      ]),
    ]),
    css('.skills', [
      css('&').styles(gridPlacement: GridPlacement(rowStart: LinePlacement(3), columnStart: LinePlacement(1))),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.tablet.px), [
        css('&').styles(gridPlacement: GridPlacement.auto),
      ]),
    ]),
    css('.bento', [
      css('&').styles(
        backgroundColor: AppColors.surface.withValues(alpha: 0.6),
        border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.08), width: 1.px),
        radius: BorderRadius.circular(1.25.rem),
        padding: Padding.all(2.rem),
        raw: {'transition': 'transform 250ms ease, border-color 250ms ease, box-shadow 250ms ease'},
      ),
      css('&:hover').styles(
        transform: Transform.translate(y: (-4).px),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1.px),
        raw: {'box-shadow': '0 15px 35px -12px ${AppColors.primary.withValues(alpha: 0.25).value}'},
      ),
      css('.bento-title').styles(
        color: AppColors.primary,
        fontFamily: FontFamily.list([FontFamily('Space Mono'), FontFamilies.monospace]),
        fontSize: 0.8.rem,
        letterSpacing: 2.px,
        textTransform: TextTransform.upperCase,
        margin: Margin.only(bottom: 1.5.rem),
      ),
    ]),
    css('.identity', [
      css('&').styles(gridPlacement: GridPlacement(columnStart: LinePlacement.span(2))),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.tablet.px), [
        css('&').styles(gridPlacement: GridPlacement(columnStart: LinePlacement.span(1))),
      ]),
      css('.identity-headline').styles(
        fontFamily: FontFamily.list([FontFamily('IBM Plex Mono'), FontFamilies.monospace]),
        fontSize: 2.25.rem,
        fontWeight: FontWeight.w900,
        lineHeight: Unit.expression('1.1'),
        letterSpacing: (-1).px,
        color: AppColors.textPrimary,
        margin: Margin.only(bottom: 1.25.rem),
      ),
      css('.identity-summary').styles(
        color: AppColors.textSecondary,
        fontFamily: FontFamily.list([FontFamily('JetBrains Mono'), FontFamilies.monospace]),
        fontSize: 1.rem,
        lineHeight: Unit.expression('1.6'),
      ),
    ]),
    css('.impact-stats', [
      css('&').styles(display: Display.flex, justifyContent: JustifyContent.spaceAround),
      css('.impact-stat').styles(display: Display.flex, flexDirection: FlexDirection.column, alignItems: AlignItems.center, gap: Gap.all(0.5.rem)),
      css('.impact-icon').styles(color: AppColors.primary, fontSize: 1.75.rem),
      css('.impact-value').styles(
        fontFamily: FontFamily.list([FontFamily('IBM Plex Mono'), FontFamilies.monospace]),
        fontSize: 2.rem,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      css('.impact-label').styles(
        color: AppColors.textTertiary,
        fontFamily: FontFamily.list([FontFamily('Space Mono'), FontFamilies.monospace]),
        fontSize: 0.7.rem,
        letterSpacing: 1.px,
      ),
    ]),
    css('.feature-grid', [
      css('&').styles(
        display: Display.grid,
        gridTemplate: GridTemplate(columns: GridTracks([GridTrack(TrackSize.fr(1)), GridTrack(TrackSize.fr(1))])),
        gap: Gap.all(1.rem),
        // .features is now a column flexbox so this can grow to fill the
        // taller, row-spanning card and center its 2x2 cards within it
        // instead of leaving them stranded at the top.
        raw: {'flex': '1', 'align-content': 'center'},
      ),
      css('.feature-card').styles(
        backgroundColor: Colors.white.withValues(alpha: 0.03),
        radius: BorderRadius.circular(1.rem),
        padding: Padding.all(1.rem),
        raw: {'transition': 'transform 200ms ease, background-color 200ms ease'},
      ),
      css('.feature-card:hover').styles(
        backgroundColor: Colors.white.withValues(alpha: 0.07),
        transform: Transform.translate(y: (-3).px),
      ),
      css('.feature-icon').styles(color: AppColors.primary, fontSize: 1.25.rem),
      css('.feature-title').styles(
        color: AppColors.textPrimary,
        fontFamily: FontFamily.list([FontFamily('IBM Plex Mono'), FontFamilies.monospace]),
        fontWeight: FontWeight.w700,
        fontSize: 0.9.rem,
        margin: Margin.only(top: 0.75.rem, bottom: 0.5.rem),
      ),
      css('.feature-description').styles(
        color: AppColors.textSecondary,
        fontFamily: FontFamily.list([FontFamily('JetBrains Mono'), FontFamilies.monospace]),
        fontSize: 0.8.rem,
        lineHeight: Unit.expression('1.4'),
      ),
    ]),
    css('.skill-list', [
      css('&').styles(display: Display.flex, flexDirection: FlexDirection.column, gap: Gap.all(1.25.rem)),
      css('.skill-header').styles(
        display: Display.flex,
        justifyContent: JustifyContent.spaceBetween,
        color: AppColors.textSecondary,
        fontFamily: FontFamily.list([FontFamily('JetBrains Mono'), FontFamilies.monospace]),
        fontSize: 0.85.rem,
        margin: Margin.only(bottom: 0.5.rem),
      ),
      css('.skill-track').styles(
        height: 6.px,
        backgroundColor: Colors.white.withValues(alpha: 0.08),
        radius: BorderRadius.circular(3.px),
        overflow: Overflow.hidden,
      ),
      // Starts at 0 and only grows to its real value once the bento tile's
      // .reveal.revealed class lands (IntersectionObserver-driven, see
      // components/scroll_reveal.dart) -- same on-scroll-into-view trigger
      // used for every other reveal animation on the site, in place of the
      // original Flutter version's scroll-linked AnimationController.
      css('.skill-fill').styles(
        height: 100.percent,
        width: Unit.zero,
        radius: BorderRadius.circular(3.px),
        raw: {'transition': 'width 1000ms ease'},
      ),
      css('.skill-fill.primary').styles(backgroundColor: AppColors.primary),
      css('.skill-fill.secondary').styles(backgroundColor: AppColors.secondary),
    ]),
    css('.reveal.revealed .skill-fill').styles(width: Unit.expression('var(--target-width)')),
  ];
}
