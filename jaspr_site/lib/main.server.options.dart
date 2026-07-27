// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/server.dart';
import 'package:jaspr_site/components/contact_form.dart' as _contact_form;
import 'package:jaspr_site/components/header.dart' as _header;
import 'package:jaspr_site/components/scroll_reveal.dart' as _scroll_reveal;
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
    _header.Header: ClientTarget<_header.Header>('header'),
    _scroll_reveal.ScrollReveal: ClientTarget<_scroll_reveal.ScrollReveal>(
      'scroll_reveal',
    ),
  },
  styles: () => [
    ..._theme.styles,
    ..._contact_form.ContactForm.styles,
    ..._header.Header.styles,
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
