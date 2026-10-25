import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import '../constants/motion_css.dart';
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
  /// True when this section is the whole page (its own route), so its
  /// title becomes the page's `<h1>` instead of an `<h2>`.
  final bool standalone;

  const AboutSection({super.key, this.standalone = false});

  @override
  Future<Component> build(BuildContext context) async {
    // Under the page's own h1 the tile titles are h2; under the home page's h2, h3.
    Component bentoTitle(String text) => standalone ? h2(classes: 'bento-title', [.text(text)]) : h3(classes: 'bento-title', [.text(text)]);
    final about = await fetchAboutData();

    return section(id: 'about', classes: 'about', [
      if (standalone)
        h1(classes: 'section-title', [.text('About Me')])
      else
        h2(classes: 'section-title', [.text('About Me')]),
      div(classes: 'about-grid', [
        div(classes: 'bento identity reveal', [
          bentoTitle('Identity'),
          p(classes: 'identity-headline', [.text('Crafting Exceptional Digital Experiences')]),
          p(classes: 'identity-summary', [.text(about.professionalSummary)]),
        ]),
        div(
          classes: 'bento impact reveal',
          styles: Styles(raw: {'transition-delay': '80ms'}),
          [
            bentoTitle('Impact'),
            div(classes: 'impact-stats', [
              div(classes: 'impact-stat', [
                span(classes: 'material-symbols-rounded impact-icon', [.text('download')]),
                span(classes: 'impact-value', [.text(about.downloadsCount)]),
                span(classes: 'impact-label', [.text('DOWNLOADS')]),
              ]),
              if (about.ratings.trim().isNotEmpty)
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
            bentoTitle('Experience'),
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
          bentoTitle('Proficiency'),
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
      css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile.px), [
        css('&').styles(padding: Padding.symmetric(horizontal: 1.25.rem, vertical: 4.rem)),
      ]),
    ]),
    css('.about-grid', [
      css('&').styles(
        display: Display.grid,
        gridTemplate: GridTemplate(
          columns: GridTracks([GridTrack(TrackSize.minmax(TrackSize(Unit.zero), TrackSize.fr(2))), GridTrack(TrackSize.minmax(TrackSize(Unit.zero), TrackSize.fr(1)))]),
        ),
        gap: Gap.all(1.5.rem),
        margin: Margin.only(top: 3.75.rem),
      ),
      css.media(MediaQuery.screen(maxWidth: Breakpoints.tablet.px), [
        css('&').styles(
          gridTemplate: GridTemplate(columns: GridTracks([GridTrack(TrackSize.minmax(TrackSize(Unit.zero), TrackSize.fr(1)))])),
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
      css.media(MediaQuery.screen(maxWidth: Breakpoints.mobile.px), [
        css('&').styles(padding: Padding.all(1.25.rem)),
      ]),
      css('&:hover').styles(
        transform: Transform.translate(y: (-4).px),
        border: Border.all(color: themed(AppColors.primary.withValues(alpha: 0.3), calm: AppColors.textPrimary.withValues(alpha: 0.16)), width: 1.px),
        raw: {'box-shadow': '0 15px 35px -12px ${AppColors.glow(0.25).value}'},
      ),
      css('.bento-title').styles(
        color: AppColors.primary,
        fontFamily: AppFonts.of(FontRole.accent, was: AppFonts.spaceMono),
        fontSize: AppType.size(TypeStep.label, was: 0.8.rem),
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
        fontFamily: AppFonts.of(FontRole.heading, was: AppFonts.ibmPlexMono),
        fontSize: AppType.size(TypeStep.h2, was: 2.25.rem),
        fontWeight: themed(FontWeight.w900, calm: AppFonts.active.headingWeight),
        lineHeight: Unit.expression('1.1'),
        letterSpacing: themed((-1).px, calm: (-0.02).em),
        color: AppColors.textPrimary,
        margin: Margin.only(bottom: 1.25.rem),
      ),
      css('.identity-summary').styles(
        color: AppColors.textSecondary,
        fontFamily: AppFonts.of(FontRole.text, was: AppFonts.jetBrainsMono),
        fontSize: AppType.size(TypeStep.body, was: 1.rem),
        lineHeight: Unit.expression('1.6'),
      ),
    ]),
    css('.impact-stats', [
      css('&').styles(display: Display.flex, justifyContent: JustifyContent.spaceAround),
      css('.impact-stat').styles(display: Display.flex, flexDirection: FlexDirection.column, alignItems: AlignItems.center, gap: Gap.all(0.5.rem)),
      css('.impact-icon').styles(color: AppColors.primary, fontSize: 1.75.rem),
      css('.impact-value').styles(
        fontFamily: AppFonts.of(FontRole.heading, was: AppFonts.ibmPlexMono),
        fontSize: AppType.size(TypeStep.h2, was: 2.rem),
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      css('.impact-label').styles(
        color: AppColors.textTertiary,
        fontFamily: AppFonts.of(FontRole.accent, was: AppFonts.spaceMono),
        fontSize: AppType.size(TypeStep.label, was: 0.7.rem),
        letterSpacing: 1.px,
      ),
    ]),
    css('.feature-grid', [
      css('&').styles(
        display: Display.grid,
        gridTemplate: GridTemplate(columns: GridTracks([GridTrack(TrackSize.minmax(TrackSize(Unit.zero), TrackSize.fr(1))), GridTrack(TrackSize.minmax(TrackSize(Unit.zero), TrackSize.fr(1)))])),
        gap: Gap.all(1.rem),
        // .features is now a column flexbox so this can grow to fill the
        // taller, row-spanning card and center its 2x2 cards within it
        // instead of leaving them stranded at the top.
        raw: {'flex': '1', 'align-content': 'center'},
      ),
      // Two 120px-wide cards can't hold "Performance" plus its blurb on a
      // phone, so they stack there.
      css.media(MediaQuery.screen(maxWidth: 420.px), [
        css('&').styles(raw: {'grid-template-columns': 'minmax(0, 1fr)'}),
      ]),
      css('.feature-card').styles(
        backgroundColor: AppColors.textPrimary.withValues(alpha: 0.03),
        radius: BorderRadius.circular(1.rem),
        padding: Padding.all(1.rem),
        raw: {'transition': 'transform 200ms ease, background-color 200ms ease'},
      ),
      css('.feature-card:hover').styles(
        backgroundColor: AppColors.textPrimary.withValues(alpha: 0.07),
        transform: Transform.translate(y: (-3).px),
      ),
      css('.feature-icon').styles(color: AppColors.primary, fontSize: 1.25.rem),
      css('.feature-title').styles(
        color: AppColors.textPrimary,
        fontFamily: AppFonts.of(FontRole.heading, was: AppFonts.ibmPlexMono),
        fontWeight: FontWeight.w700,
        fontSize: AppType.size(TypeStep.body, was: 0.9.rem),
        margin: Margin.only(top: 0.75.rem, bottom: 0.5.rem),
      ),
      css('.feature-description').styles(
        color: AppColors.textSecondary,
        fontFamily: AppFonts.of(FontRole.text, was: AppFonts.jetBrainsMono),
        fontSize: AppType.size(TypeStep.small, was: 0.8.rem),
        lineHeight: Unit.expression('1.4'),
      ),
    ]),
    css('.skill-list', [
      css('&').styles(display: Display.flex, flexDirection: FlexDirection.column, gap: Gap.all(1.25.rem)),
      css('.skill-header').styles(
        display: Display.flex,
        justifyContent: JustifyContent.spaceBetween,
        color: AppColors.textSecondary,
        fontFamily: AppFonts.of(FontRole.text, was: AppFonts.jetBrainsMono),
        fontSize: AppType.size(TypeStep.small, was: 0.85.rem),
        margin: Margin.only(bottom: 0.5.rem),
      ),
      css('.skill-track').styles(
        height: 6.px,
        backgroundColor: AppColors.textPrimary.withValues(alpha: 0.08),
        radius: BorderRadius.circular(3.px),
        overflow: Overflow.hidden,
      ),
      // Rendered at its real value, so the bar is right without scripts and
      // with reduced motion. When the reveal script runs, a tile still below
      // the fold starts at scaleX(0) and grows once .revealed lands (see
      // components/scroll_reveal.dart). Scaling instead of animating width
      // keeps it off the layout path.
      css('.skill-fill').styles(
        height: 100.percent,
        width: Unit.expression('var(--target-width)'),
        radius: BorderRadius.circular(3.px),
        raw: {'transform-origin': 'left center', 'transition': 'transform 900ms cubic-bezier(0.23, 1, 0.32, 1)'},
      ),
      css('.skill-fill.primary').styles(backgroundColor: AppColors.primary),
      css('.skill-fill.secondary').styles(backgroundColor: AppColors.secondary),
    ]),
    MotionRule.allowed([
      css('html.reveal-ready .reveal:not(.revealed) .skill-fill').styles(raw: {'transform': 'scaleX(0)'}),
    ]),
    MotionRule.reduced([
      css('.skill-fill').styles(raw: {'transition': 'none'}),
    ]),
  ];
}
