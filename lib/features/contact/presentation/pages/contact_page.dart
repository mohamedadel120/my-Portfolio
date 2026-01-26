import 'package:flutter/material.dart';
import '../../../../core/navigation/feature_page_wrapper.dart';
import 'contact_section.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Contact Section typically 5.0 * H (last section)
    return FeaturePageWrapper(
      title: 'Contact',
      virtualOffset: MediaQuery.of(context).size.height * 5,
      builder: (context, scrollOffsetListenable) {
        return ContactSection(
          scrollOffsetListenable: scrollOffsetListenable,
        );
      },
    );
  }
}
