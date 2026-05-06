import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_data.dart';
import '../../../../utils/url_launcher_utils.dart';
import '../../../../utils/device_utils.dart';
import '../../../hero/presentation/pages/hero_section.dart';
import '../../../about/presentation/pages/about_section.dart';
import '../../../expertise/presentation/pages/expertise_section.dart';
import '../../../experience/presentation/pages/experience_section.dart';
import '../../../projects/presentation/pages/projects_section.dart';
import '../../../contact/presentation/pages/contact_section.dart';
import '../../../../widgets/common/scroll_indicator.dart';
import '../../../../widgets/navigation/nav_bar_item.dart';

/// Responsive Home Page:
/// - Desktop: Single-page scroll with top nav bar and all sections stacked
/// - Mobile: Hero section only, with navigation drawer/buttons to other pages
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  final _scrollNotifier = ValueNotifier<double>(0.0);
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // Keys for scroll-to navigation (Desktop only)
  final _heroKey = GlobalKey();
  final _aboutKey = GlobalKey();
  final _expertiseKey = GlobalKey();
  final _experienceKey = GlobalKey();
  final _projectsKey = GlobalKey();
  final _contactKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    _scrollNotifier.value = _scrollController.offset;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _scrollNotifier.dispose();
    super.dispose();
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _onDownloadCV() {
    UrlLauncherUtils.launchURL(AppData.cvUrl);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = DeviceUtils.isMobile(screenWidth);

    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          // Main scrollable content (Desktop stack / Mobile Hero only)
          isMobile
              ? HeroSection(
                  scrollOffsetListenable: _scrollNotifier,
                  onViewProjects: () =>
                      Navigator.pushNamed(context, '/projects'),
                  onContactMe: () => Navigator.pushNamed(context, '/contact'),
                  onDownloadCV: _onDownloadCV,
                )
              : PrimaryScrollController(
                  controller: _scrollController,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                    children: [
                      KeyedSubtree(
                        key: _heroKey,
                        child: HeroSection(
                          scrollOffsetListenable: _scrollNotifier,
                          onViewProjects: () => _scrollToSection(_projectsKey),
                          onContactMe: () => _scrollToSection(_contactKey),
                          onDownloadCV: _onDownloadCV,
                        ),
                      ),
                      KeyedSubtree(
                        key: _aboutKey,
                        child: AboutSection(
                          scrollOffsetListenable: _scrollNotifier,
                        ),
                      ),
                      KeyedSubtree(
                        key: _expertiseKey,
                        child: ExpertiseSection(
                          scrollOffsetListenable: _scrollNotifier,
                        ),
                      ),
                      KeyedSubtree(
                        key: _experienceKey,
                        child: ExperienceSection(
                          scrollOffsetListenable: _scrollNotifier,
                        ),
                      ),
                      KeyedSubtree(
                        key: _projectsKey,
                        child: ProjectsSection(
                          scrollOffsetListenable: _scrollNotifier,
                        ),
                      ),
                      KeyedSubtree(
                        key: _contactKey,
                        child: ContactSection(
                          scrollOffsetListenable: _scrollNotifier,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

          // Floating Top Navigation Bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildNavBar(context, isMobile),
          ),

          // Side Scroll Indicator (Desktop only)
          if (!isMobile)
            Positioned(
              top: MediaQuery.of(context).size.height / 2, // Start from center
              bottom: 40, // Leave space at the bottom
              right: 40, // Slightly more padding
              child: ValueListenableBuilder<double>(
                valueListenable: _scrollNotifier,
                builder: (context, scrollOffset, _) {
                  double opacity = 1.0;
                  if (_scrollController.hasClients &&
                      _scrollController.position.hasContentDimensions) {
                    final max = _scrollController.position.maxScrollExtent;
                    if (max > 0) {
                      // Fade out only in the last 100 pixels
                      opacity = ((max - scrollOffset) / 100.0).clamp(0.0, 1.0);
                    }
                  }
                  return ScrollIndicator(
                    opacity: opacity,
                    isExpanded: true, // Enable expanded mode
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNavBar(BuildContext context, bool isMobile) {
    return _InteractiveNavBar(
      scrollNotifier: _scrollNotifier,
      isMobile: isMobile,
      onScrollToSection: (key) => _scrollToSection(key),
      onDownloadCV: _onDownloadCV,
      heroKey: _heroKey,
      aboutKey: _aboutKey,
      expertiseKey: _expertiseKey,
      experienceKey: _experienceKey,
      projectsKey: _projectsKey,
      contactKey: _contactKey,
    );
  }
}

class _InteractiveNavBar extends StatefulWidget {
  final ValueNotifier<double> scrollNotifier;
  final bool isMobile;
  final Function(GlobalKey) onScrollToSection;
  final VoidCallback onDownloadCV;
  final GlobalKey heroKey;
  final GlobalKey aboutKey;
  final GlobalKey expertiseKey;
  final GlobalKey experienceKey;
  final GlobalKey projectsKey;
  final GlobalKey contactKey;

  const _InteractiveNavBar({
    required this.scrollNotifier,
    required this.isMobile,
    required this.onScrollToSection,
    required this.onDownloadCV,
    required this.heroKey,
    required this.aboutKey,
    required this.expertiseKey,
    required this.experienceKey,
    required this.projectsKey,
    required this.contactKey,
  });

  @override
  State<_InteractiveNavBar> createState() => _InteractiveNavBarState();
}

class _InteractiveNavBarState extends State<_InteractiveNavBar> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return ValueListenableBuilder<double>(
      valueListenable: widget.scrollNotifier,
      builder: (context, scrollOffset, _) {
        final opacity =
            widget.isMobile ? 0.0 : (scrollOffset / 200).clamp(0.0, 1.0);

        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.symmetric(
              horizontal: widget.isMobile ? 20 : 40,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor.withValues(
                    alpha: widget.isMobile ? 0.0 : 0.7 + (opacity * 0.3),
                  ),
              border: Border(
                bottom: BorderSide(
                  color: _isHovered
                      ? primary.withValues(alpha: 0.5)
                      : Theme.of(context).colorScheme.primary.withValues(
                            alpha: widget.isMobile ? 0.0 : 0.1,
                          ),
                  width: _isHovered ? 2.0 : 1.0,
                ),
              ),
              boxShadow: _isHovered
                  ? [
                      BoxShadow(
                        color: primary.withValues(alpha: 0.15),
                        blurRadius: 20,
                        spreadRadius: 1,
                      )
                    ]
                  : [],
            ),
            child: Row(
              children: [
                // Logo / Name
                GestureDetector(
                  onTap: () => widget.isMobile
                      ? null
                      : widget.onScrollToSection(widget.heroKey),
                  child: Image.asset(
                    'assets/images/logo1.png',
                    height: widget.isMobile ? 32 : 75,
                    fit: BoxFit.contain,
                  ),
                ),

                const Spacer(),

                if (!widget.isMobile) ...[
                  // Navigation Links (Desktop)
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          NavBarItem(
                            title: 'HOME',
                            onTap: () =>
                                widget.onScrollToSection(widget.heroKey),
                          ),
                          NavBarItem(
                            title: 'ABOUT',
                            onTap: () =>
                                widget.onScrollToSection(widget.aboutKey),
                          ),
                          NavBarItem(
                            title: 'EXPERTISE',
                            onTap: () =>
                                widget.onScrollToSection(widget.expertiseKey),
                          ),
                          NavBarItem(
                            title: 'EXPERIENCE',
                            onTap: () =>
                                widget.onScrollToSection(widget.experienceKey),
                          ),
                          NavBarItem(
                            title: 'PROJECTS',
                            onTap: () =>
                                widget.onScrollToSection(widget.projectsKey),
                          ),
                          NavBarItem(
                            title: 'CONTACT',
                            onTap: () =>
                                widget.onScrollToSection(widget.contactKey),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildDownloadButton(context),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDownloadButton(BuildContext context) {
    return TextButton(
      onPressed: widget.onDownloadCV,
      style: TextButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      child: Text(
        'DOWNLOAD CV',
        style: GoogleFonts.spaceMono(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
