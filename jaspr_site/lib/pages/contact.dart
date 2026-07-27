import 'package:jaspr/jaspr.dart';

import '../sections/contact_section.dart';

/// Ported from `ContactPage`/`FeaturePageWrapper` — standalone direct-link
/// route showing just this one section.
class Contact extends StatelessComponent {
  const Contact({super.key});

  @override
  Component build(BuildContext context) => const ContactSection();
}
