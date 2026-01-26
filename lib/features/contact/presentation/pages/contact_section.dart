import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/responsive/responsive_builder.dart';
import '../../../../injection_container.dart';
import '../cubit/contact_cubit.dart';
import 'mobile/contact_mobile_view.dart';
import 'desktop/contact_desktop_view.dart';

class ContactSection extends StatelessWidget {
  final ValueListenable<double> scrollOffsetListenable;

  const ContactSection({
    super.key,
    required this.scrollOffsetListenable,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ContactCubit>()..loadContactData(),
      child: ResponsiveBuilder(
        mobile:
            ContactMobileView(scrollOffsetListenable: scrollOffsetListenable),
        tablet: ContactMobileView(
            scrollOffsetListenable: scrollOffsetListenable), // Reuse mobile
        desktop:
            ContactDesktopView(scrollOffsetListenable: scrollOffsetListenable),
      ),
    );
  }
}
