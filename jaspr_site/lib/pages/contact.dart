import 'package:jaspr/jaspr.dart';

import '../components/page_meta.dart';
import '../sections/contact_section.dart';

/// Ported from `ContactPage`/`FeaturePageWrapper` — standalone direct-link
/// route showing just this one section.
class Contact extends StatelessComponent {
  const Contact({super.key});

  @override
  Component build(BuildContext context) => Component.fragment(const [
    PageMeta(
      path: '/contact',
      title: 'Contact - Mohamed Adel, Flutter Developer',
      description:
          'Get in touch with Mohamed Adel, Flutter developer in Cairo: send a message, email or call about your mobile app or an open role.',
    ),
    ContactSection(standalone: true),
  ]);
}
