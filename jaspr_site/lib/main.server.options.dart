// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/server.dart';
import 'package:jaspr_site/components/contact_form.dart' as _contact_form;
import 'package:jaspr_site/components/cta_link.dart' as _cta_link;
import 'package:jaspr_site/components/custom_cursor.dart' as _custom_cursor;
import 'package:jaspr_site/components/featured_label.dart' as _featured_label;
import 'package:jaspr_site/components/header.dart' as _header;
import 'package:jaspr_site/components/project_case_studies.dart'
    as _project_case_studies;
import 'package:jaspr_site/components/project_index_detail.dart'
    as _project_index_detail;
import 'package:jaspr_site/components/project_pinned_showcase.dart'
    as _project_pinned_showcase;
import 'package:jaspr_site/components/project_showcase.dart'
    as _project_showcase;
import 'package:jaspr_site/components/project_stage_showcase.dart'
    as _project_stage_showcase;
import 'package:jaspr_site/components/scroll_reveal.dart' as _scroll_reveal;
import 'package:jaspr_site/components/shot_gallery.dart' as _shot_gallery;
import 'package:jaspr_site/components/store_buttons.dart' as _store_buttons;
import 'package:jaspr_site/constants/theme.dart' as _theme;
import 'package:jaspr_site/sections/about_section.dart' as _about_section;
import 'package:jaspr_site/sections/contact_section.dart' as _contact_section;
import 'package:jaspr_site/sections/experience_section.dart'
    as _experience_section;
import 'package:jaspr_site/sections/expertise_section.dart'
    as _expertise_section;
import 'package:jaspr_site/sections/hero_section.dart' as _hero_section;
import 'package:jaspr_site/sections/projects_section.dart' as _projects_section;

/// Default [ServerOptions] for use with your Jaspr project.
///
/// Use this to initialize Jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'main.server.options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultServerOptions,
///   );
///
///   runApp(...);
/// }
/// ```
ServerOptions get defaultServerOptions => ServerOptions(
  clientId: 'main.client.dart.js',
  clients: {
    _contact_form.ContactForm: ClientTarget<_contact_form.ContactForm>(
      'contact_form',
      params: __contact_formContactForm,
    ),
    _custom_cursor.CustomCursor: ClientTarget<_custom_cursor.CustomCursor>(
      'custom_cursor',
    ),
    _header.Header: ClientTarget<_header.Header>(
      'header',
      params: __headerHeader,
    ),
    _project_index_detail.ProjectIndexDetail:
        ClientTarget<_project_index_detail.ProjectIndexDetail>(
          'project_index_detail',
          params: __project_index_detailProjectIndexDetail,
        ),
    _project_pinned_showcase.ProjectPinnedShowcase:
        ClientTarget<_project_pinned_showcase.ProjectPinnedShowcase>(
          'project_pinned_showcase',
          params: __project_pinned_showcaseProjectPinnedShowcase,
        ),
    _project_showcase.StickyProjectShowcase:
        ClientTarget<_project_showcase.StickyProjectShowcase>(
          'project_showcase',
          params: __project_showcaseStickyProjectShowcase,
        ),
    _project_stage_showcase.ProjectStageShowcase:
        ClientTarget<_project_stage_showcase.ProjectStageShowcase>(
          'project_stage_showcase',
          params: __project_stage_showcaseProjectStageShowcase,
        ),
    _scroll_reveal.ScrollReveal: ClientTarget<_scroll_reveal.ScrollReveal>(
      'scroll_reveal',
    ),
    _shot_gallery.ShotGallery: ClientTarget<_shot_gallery.ShotGallery>(
      'shot_gallery',
      params: __shot_galleryShotGallery,
    ),
  },
  styles: () => [
    ..._theme.styles,
    ..._contact_form.ContactForm.styles,
    ..._cta_link.CtaLink.styles,
    ..._custom_cursor.CustomCursor.styles,
    ..._featured_label.FeaturedLabel.styles,
    ..._header.Header.styles,
    ..._project_case_studies.ProjectCaseStudies.styles,
    ..._project_index_detail.ProjectIndexDetail.styles,
    ..._project_pinned_showcase.ProjectPinnedShowcase.styles,
    ..._project_showcase.StickyProjectShowcase.styles,
    ..._project_stage_showcase.ProjectStageShowcase.styles,
    ..._shot_gallery.ShotGalleryView.styles,
    ..._store_buttons.StoreButtons.styles,
    ..._about_section.AboutSection.styles,
    ..._contact_section.ContactSection.styles,
    ..._experience_section.ExperienceSection.styles,
    ..._expertise_section.ExpertiseSection.styles,
    ..._hero_section.HeroSection.styles,
    ..._projects_section.ProjectsSection.styles,
  ],
);

Map<String, Object?> __contact_formContactForm(_contact_form.ContactForm c) => {
  'recipientEmail': c.recipientEmail,
};
Map<String, Object?> __headerHeader(_header.Header c) => {'cvUrl': c.cvUrl};
Map<String, Object?> __project_index_detailProjectIndexDetail(
  _project_index_detail.ProjectIndexDetail c,
) => {'projects': c.projects};
Map<String, Object?> __project_pinned_showcaseProjectPinnedShowcase(
  _project_pinned_showcase.ProjectPinnedShowcase c,
) => {'projects': c.projects};
Map<String, Object?> __project_showcaseStickyProjectShowcase(
  _project_showcase.StickyProjectShowcase c,
) => {'projects': c.projects, 'refined': c.refined};
Map<String, Object?> __project_stage_showcaseProjectStageShowcase(
  _project_stage_showcase.ProjectStageShowcase c,
) => {'projects': c.projects};
Map<String, Object?> __shot_galleryShotGallery(_shot_gallery.ShotGallery c) => {
  'title': c.title,
  'images': c.images,
  'eagerFirst': c.eagerFirst,
};
