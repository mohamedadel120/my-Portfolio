import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_data.dart';
import '../common/section_title.dart';
import '../common/contact_button.dart';
import '../common/contact_info_item.dart';
import '../common/contact_form.dart';
import '../common/tech_grid_background.dart';
import '../common/scroll_triggered_animation.dart';
import '../common/gsap_stagger_animation.dart';
import '../common/scroll_speed_widget.dart';
import '../../utils/device_utils.dart';

class ContactSection extends StatelessWidget {
  final ValueListenable<double> scrollOffsetListenable;

  const ContactSection({super.key, required this.scrollOffsetListenable});

  @override
  Widget build(BuildContext context) {
    final viewportHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    // Estimate: All previous sections
    final sectionStartOffset = viewportHeight * 5;

    // Responsive breakpoints
    final isXS = DeviceUtils.isExtraSmall(screenWidth);
    final isMobile = DeviceUtils.isMobile(screenWidth);
    final isTablet = DeviceUtils.isTablet(screenWidth);
    final isLowSpec = DeviceUtils.isLowSpecDevice(context);

    // Responsive padding
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
                Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
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
                    child: const SectionTitle(
                      title: 'Get In Touch',
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
                        horizontal: isXS ? 16 : (isMobile ? 20 : 40),
                        vertical: isXS ? 10 : (isMobile ? 12 : 16),
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.1),
                            Theme.of(
                              context,
                            ).colorScheme.secondary.withValues(alpha: 0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Let\'s build something amazing together!',
                        style: GoogleFonts.poppins(
                          fontSize: isXS
                              ? 14
                              : (isMobile ? 16 : (isTablet ? 18 : 20)),
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: isMobile ? 40 : 60),
                  // Contact Form and Info Side by Side (stacked on mobile)
                  isMobile
                      ? Column(
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
                                    padding: EdgeInsets.all(
                                        isXS ? 16 : (isMobile ? 24 : 30)),
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
                                        BoxShadow(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary
                                              .withValues(alpha: 0.05),
                                          blurRadius: 50,
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      children: [
                                        ContactInfoItem(
                                          icon: Icons.email,
                                          label: 'Email',
                                          value: AppData.email,
                                          onTap: () async {
                                            final Uri emailUri = Uri(
                                              scheme: 'mailto',
                                              path: AppData.email,
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
                                          value: AppData.phone,
                                          onTap: () async {
                                            final Uri phoneUri = Uri(
                                              scheme: 'tel',
                                              path: AppData.phone,
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
                                          value: AppData.location,
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
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          'Connect With Me',
                                          style: GoogleFonts.poppins(
                                            fontSize: isXS ? 16 : 18,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      ContactButton(
                                        icon: Icons.email,
                                        label: 'Email',
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        onTap: () async {
                                          final Uri emailUri = Uri(
                                            scheme: 'mailto',
                                            path: AppData.email,
                                          );
                                          if (await canLaunchUrl(emailUri)) {
                                            await launchUrl(emailUri);
                                          }
                                        },
                                        delay: 0.ms,
                                        isVisible: true,
                                      ),
                                      const SizedBox(height: 15),
                                      ContactButton(
                                        icon: Icons.code,
                                        label: 'GitHub',
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.secondary,
                                        onTap: () async {
                                          final Uri githubUri = Uri.parse(
                                            'https://github.com/mohamedadel120',
                                          );
                                          if (await canLaunchUrl(githubUri)) {
                                            await launchUrl(githubUri);
                                          }
                                        },
                                        delay: 100.ms,
                                        isVisible: true,
                                      ),
                                      const SizedBox(height: 15),
                                      ContactButton(
                                        icon: Icons.link,
                                        label: 'LinkedIn',
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        onTap: () async {
                                          final Uri linkedInUri = Uri.parse(
                                            'https://www.linkedin.com/in/mohamed-adel-9454a1183/',
                                          );
                                          if (await canLaunchUrl(linkedInUri)) {
                                            await launchUrl(linkedInUri);
                                          }
                                        },
                                        delay: 200.ms,
                                        isVisible: true,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Contact Form
                            Expanded(
                              flex: 2,
                              child: GSAPEnhancedAnimation(
                                elementId: 'contact-form-desktop',
                                scrollOffset: scrollOffset,
                                sectionStartOffset: sectionStartOffset + 200,
                                viewportHeight: viewportHeight,
                                animationConfig: const {
                                  'opacity': {'from': 0, 'to': 1},
                                  'x': {'from': -80, 'to': 0},
                                },
                                child: ContactForm(
                                  isVisible: true,
                                  delay: 0.ms,
                                ),
                              ),
                            ),
                            SizedBox(width: isTablet ? 30 : 40),
                            // Contact Info
                            Expanded(
                              child: GSAPEnhancedAnimation(
                                elementId: 'contact-info-desktop',
                                scrollOffset: scrollOffset,
                                sectionStartOffset: sectionStartOffset + 300,
                                viewportHeight: viewportHeight,
                                animationConfig: const {
                                  'opacity': {'from': 0, 'to': 1},
                                  'x': {'from': 80, 'to': 0},
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(
                                        isTablet ? 24 : 30,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Theme.of(
                                              context,
                                            ).colorScheme.surface,
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
                                          BoxShadow(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withValues(alpha: 0.05),
                                            blurRadius: 50,
                                            spreadRadius: 0,
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          ContactInfoItem(
                                            icon: Icons.email,
                                            label: 'Email',
                                            value: AppData.email,
                                            onTap: () async {
                                              final Uri emailUri = Uri(
                                                scheme: 'mailto',
                                                path: AppData.email,
                                              );
                                              if (await canLaunchUrl(
                                                emailUri,
                                              )) {
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
                                            value: AppData.phone,
                                            onTap: () async {
                                              final Uri phoneUri = Uri(
                                                scheme: 'tel',
                                                path: AppData.phone,
                                              );
                                              if (await canLaunchUrl(
                                                phoneUri,
                                              )) {
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
                                            value: AppData.location,
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
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 8,
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
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Text(
                                            'Connect With Me',
                                            style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        ContactButton(
                                          icon: Icons.email,
                                          label: 'Email',
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          onTap: () async {
                                            final Uri emailUri = Uri(
                                              scheme: 'mailto',
                                              path: AppData.email,
                                            );
                                            if (await canLaunchUrl(emailUri)) {
                                              await launchUrl(emailUri);
                                            }
                                          },
                                          delay: 0.ms,
                                          isVisible: true,
                                        ),
                                        const SizedBox(height: 15),
                                        ContactButton(
                                          icon: Icons.code,
                                          label: 'GitHub',
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                          onTap: () async {
                                            final Uri githubUri = Uri.parse(
                                              'https://github.com/mohamedadel120',
                                            );
                                            if (await canLaunchUrl(githubUri)) {
                                              await launchUrl(githubUri);
                                            }
                                          },
                                          delay: 100.ms,
                                          isVisible: true,
                                        ),
                                        const SizedBox(height: 15),
                                        ContactButton(
                                          icon: Icons.link,
                                          label: 'LinkedIn',
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          onTap: () async {
                                            final Uri linkedInUri = Uri.parse(
                                              'https://www.linkedin.com/in/mohamed-adel-9454a1183/',
                                            );
                                            if (await canLaunchUrl(
                                              linkedInUri,
                                            )) {
                                              await launchUrl(linkedInUri);
                                            }
                                          },
                                          delay: 200.ms,
                                          isVisible: true,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                  SizedBox(height: isMobile ? 60 : 80),
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
                            Theme.of(
                              context,
                            ).colorScheme.surface.withValues(alpha: 0.9),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.1),
                            blurRadius: 20,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Text(
                        '© 2024 ${AppData.name} - ${AppData.title} Portfolio. Built with ❤️ using Flutter',
                        style: GoogleFonts.poppins(
                          fontSize: isXS ? 10 : (isMobile ? 12 : 14),
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.5),
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
  }
}
