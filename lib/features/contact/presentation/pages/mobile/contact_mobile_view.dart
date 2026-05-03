import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../../utils/device_utils.dart';
import '../../../../../widgets/common/section_title.dart';
import '../../../../../widgets/common/contact_button.dart';
import '../../../../../widgets/common/contact_info_item.dart';
import '../../../../../widgets/common/contact_form.dart';
import '../../../../../widgets/common/tech_grid_background.dart';
import '../../../../../widgets/common/scroll_triggered_animation.dart';
import '../../../../../widgets/common/gsap_stagger_animation.dart'; // For GSAPEnhancedAnimation
import '../../../../../widgets/common/scroll_speed_widget.dart';
import '../../../../contact/presentation/cubit/contact_cubit.dart';
import '../../../../contact/presentation/cubit/contact_state.dart';

class ContactMobileView extends StatelessWidget {
  final ValueListenable<double> scrollOffsetListenable;

  const ContactMobileView({super.key, required this.scrollOffsetListenable});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactCubit, ContactState>(
      builder: (context, state) {
        if (state is ContactLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ContactError) {
          return Center(child: Text(state.message));
        }

        final contactData = (state as ContactLoaded).contactData;
        final viewportHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;
        // Estimate: All previous sections. But since we are using ResponsiveBuilder at top level,
        // passing exact offset might be tricky if we don't know index.
        // However, standard Contact Section is usually last.
        // Let's assume generic offset or just use relative.
        // Actually scrollOffset is global.
        // For animations, we need `sectionStartOffset`.
        // In the original code, it was `viewportHeight * 5`.
        // Should we keep that assumption? It depends on where it is placed.
        // For now, let's keep it consistent with original.
        final sectionStartOffset = viewportHeight * 5;

        final isXS = DeviceUtils.isExtraSmall(screenWidth);
        final isMobile = DeviceUtils.isMobile(screenWidth);
        final isLowSpec = DeviceUtils.isLowSpecDevice(context);

        final horizontalPadding = DeviceUtils.getHorizontalPadding(screenWidth);
        final verticalPadding = DeviceUtils.getVerticalPadding(screenWidth);

        return ValueListenableBuilder<double>(
          valueListenable: scrollOffsetListenable,
          builder: (context, scrollOffset, _) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0.0, 0.5, 1.0],
                  colors: [
                    Theme.of(context).colorScheme.surface,
                    Theme.of(context)
                        .colorScheme
                        .surface
                        .withValues(alpha: 0.95),
                    Theme.of(context).scaffoldBackgroundColor,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Tech grid background with parallax
                  ScrollSpeedWidget(
                    scrollOffset: scrollOffset,
                    sectionStartOffset: sectionStartOffset,
                    speed: -0.15, // Parallax effect
                    child: TechGridBackground(
                      scrollOffset: scrollOffset,
                      opacity: isLowSpec ? 0.03 : 0.08,
                    ),
                  ),

                  // Main content
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ScrollTriggeredAnimation(
                        scrollOffset: scrollOffset,
                        sectionStartOffset: sectionStartOffset,
                        delay: 0.ms,
                        child: SectionTitle(
                          title: contactData.title,
                          isVisible: true,
                        ),
                      ),
                      SizedBox(height: isMobile ? 24 : 40),
                      GSAPEnhancedAnimation(
                        elementId: 'contact-subtitle',
                        scrollOffset: scrollOffset,
                        sectionStartOffset: sectionStartOffset,
                        viewportHeight: viewportHeight,
                        animationConfig: const {
                          'opacity': {'from': 0, 'to': 1},
                          'y': {'from': 30, 'to': 0},
                          'scale': {'from': 0.95, 'to': 1.0},
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isXS ? 16 : 20,
                            vertical: isXS ? 10 : 12,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.1),
                                Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withValues(alpha: 0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            contactData.subtitle,
                            style: GoogleFonts.poppins(
                              fontSize: isXS ? 14 : 16,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.7),
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),

                      SizedBox(height: isMobile ? 40 : 60),

                      // Mobile Layout: Column
                      Column(
                        children: [
                          GSAPEnhancedAnimation(
                            elementId: 'contact-form-mobile',
                            scrollOffset: scrollOffset,
                            sectionStartOffset: sectionStartOffset + 100,
                            viewportHeight: viewportHeight,
                            animationConfig: const {
                              'opacity': {'from': 0, 'to': 1},
                              'x': {'from': -50, 'to': 0},
                            },
                            child: ContactForm(isVisible: true, delay: 0.ms),
                          ),
                          const SizedBox(height: 40),
                          GSAPEnhancedAnimation(
                            elementId: 'contact-info-mobile',
                            scrollOffset: scrollOffset,
                            sectionStartOffset: sectionStartOffset + 200,
                            viewportHeight: viewportHeight,
                            animationConfig: const {
                              'opacity': {'from': 0, 'to': 1},
                              'x': {'from': 50, 'to': 0},
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(isXS ? 16 : 24),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Theme.of(context).colorScheme.surface,
                                        Theme.of(context)
                                            .colorScheme
                                            .surface
                                            .withValues(alpha: 0.95),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withValues(alpha: 0.3),
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withValues(alpha: 0.1),
                                        blurRadius: 25,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      ContactInfoItem(
                                        icon: Icons.email,
                                        label: 'Email',
                                        value: contactData.email,
                                        onTap: () async {
                                          final Uri emailUri = Uri(
                                            scheme: 'mailto',
                                            path: contactData.email,
                                          );
                                          if (await canLaunchUrl(emailUri)) {
                                            await launchUrl(emailUri);
                                          }
                                        },
                                        delay: 0.ms,
                                        isVisible: true,
                                      ),
                                      const SizedBox(height: 20),
                                      ContactInfoItem(
                                        icon: Icons.phone,
                                        label: 'Phone',
                                        value: contactData.phone,
                                        onTap: () async {
                                          final Uri phoneUri = Uri(
                                            scheme: 'tel',
                                            path: contactData.phone,
                                          );
                                          if (await canLaunchUrl(phoneUri)) {
                                            await launchUrl(phoneUri);
                                          }
                                        },
                                        delay: 100.ms,
                                        isVisible: true,
                                      ),
                                      const SizedBox(height: 20),
                                      ContactInfoItem(
                                        icon: Icons.location_on,
                                        label: 'Location',
                                        value: contactData.location,
                                        onTap: () {},
                                        delay: 200.ms,
                                        isVisible: true,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 30),
                                // Social Media Buttons
                                Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: isXS ? 14 : 20,
                                        vertical: isXS ? 6 : 8,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withValues(alpha: 0.1),
                                            Theme.of(context)
                                                .colorScheme
                                                .secondary
                                                .withValues(alpha: 0.05),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        'Connect With Me',
                                        style: GoogleFonts.poppins(
                                          fontSize: isXS ? 16 : 18,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    ...contactData.socialLinks.map((link) {
                                      IconData icon;
                                      if (link.name == 'Email') {
                                        icon = Icons.email;
                                      } else if (link.name == 'GitHub') {
                                        icon = Icons.code;
                                      } else if (link.name == 'LinkedIn') {
                                        icon = Icons.link;
                                      } else {
                                        icon = Icons.link;
                                      }

                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 15),
                                        child: ContactButton(
                                          icon: icon,
                                          label: link.name,
                                          color: link.name == 'GitHub'
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .secondary
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                          onTap: () async {
                                            final Uri uri = Uri.parse(link.url);
                                            if (await canLaunchUrl(uri)) {
                                              await launchUrl(uri);
                                            }
                                          },
                                          delay: 100.ms,
                                          isVisible: true,
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: isMobile ? 60 : 80),

                      // Footer
                      GSAPEnhancedAnimation(
                        elementId: 'contact-footer',
                        scrollOffset: scrollOffset,
                        sectionStartOffset: sectionStartOffset + 500,
                        viewportHeight: viewportHeight,
                        animationConfig: const {
                          'opacity': {'from': 0, 'to': 1},
                          'y': {'from': 20, 'to': 0},
                        },
                        child: Container(
                          padding: EdgeInsets.all(isMobile ? 16 : 20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Theme.of(context).colorScheme.surface,
                                Theme.of(context)
                                    .colorScheme
                                    .surface
                                    .withValues(alpha: 0.9),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withValues(alpha: 0.1),
                                blurRadius: 20,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Text(
                            '© 2024 ${contactData.title.contains('Touch') ? 'Mohamed Adel' : ''} - Flutter Developer Portfolio. Built with ❤️ using Flutter',
                            // Using hardcoded name or data name. Original has AppData.
                            style: GoogleFonts.poppins(
                              fontSize: isXS ? 10 : 12,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.5),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
