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
              : SingleChildScrollView(
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
              bottom: 40,
              right: 20, // Aligned with the mockup preference
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
                  return ScrollIndicator(opacity: opacity);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNavBar(BuildContext context, bool isMobile) {
    return ValueListenableBuilder<double>(
      valueListenable: _scrollNotifier,
      builder: (context, scrollOffset, _) {
        final opacity = isMobile ? 0.0 : (scrollOffset / 200).clamp(0.0, 1.0);

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 40,
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor.withValues(
                  alpha: isMobile ? 0.0 : 0.7 + (opacity * 0.3),
                ),
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.primary.withValues(
                      alpha: isMobile ? 0.0 : 0.1,
                    ),
              ),
            ),
          ),
          child: Row(
            children: [
              // Logo / Name
              GestureDetector(
                onTap: () => isMobile ? null : _scrollToSection(_heroKey),
                child: Text(
                  'MOHAMED ADEL',
                  style: GoogleFonts.orbitron(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    letterSpacing: 2,
                  ),
                ),
              ),

              const Spacer(),

              if (!isMobile) ...[
                // Navigation Links (Desktop)
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _navLink(context, 'HOME', _heroKey),
                        _navLink(context, 'ABOUT', _aboutKey),
                        _navLink(context, 'EXPERTISE', _expertiseKey),
                        _navLink(context, 'EXPERIENCE', _experienceKey),
                        _navLink(context, 'PROJECTS', _projectsKey),
                        _navLink(context, 'CONTACT', _contactKey),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _buildDownloadButton(context),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildDownloadButton(BuildContext context) {
    return TextButton(
      onPressed: _onDownloadCV,
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

  Widget _navLink(BuildContext context, String label, GlobalKey targetKey) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: () => _scrollToSection(targetKey),
        hoverColor: Colors.transparent,
        child: Text(
          label,
          style: GoogleFonts.spaceMono(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.white70,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
