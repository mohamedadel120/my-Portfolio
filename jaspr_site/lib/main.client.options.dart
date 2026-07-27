// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/client.dart';

import 'package:jaspr_site/components/contact_form.dart'
    deferred as _contact_form;
import 'package:jaspr_site/components/header.dart' deferred as _header;
import 'package:jaspr_site/components/scroll_reveal.dart'
    deferred as _scroll_reveal;

/// Default [ClientOptions] for use with your Jaspr project.
///
/// Use this to initialize Jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'main.client.options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultClientOptions,
///   );
///
///   runApp(...);
/// }
/// ```
ClientOptions get defaultClientOptions => ClientOptions(
  clients: {
    'contact_form': ClientLoader(
      (p) => _contact_form.ContactForm(
        recipientEmail: p['recipientEmail'] as String,
      ),
      loader: _contact_form.loadLibrary,
    ),
    'header': ClientLoader(
      (p) => _header.Header(),
      loader: _header.loadLibrary,
    ),
    'scroll_reveal': ClientLoader(
      (p) => _scroll_reveal.ScrollReveal(),
      loader: _scroll_reveal.loadLibrary,
    ),
  },
);
