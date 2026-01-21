import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'constants/app_colors.dart';
import 'constants/app_data.dart'; // Added this import
import 'widgets/sections/hero_section.dart';
import 'widgets/sections/about_section.dart';
import 'widgets/sections/experience_section.dart';
import 'widgets/sections/projects_section.dart';
import 'widgets/sections/contact_section.dart';
import 'widgets/sections/expertise_section.dart';
import 'widgets/sections/why_choose_me_section.dart';
import 'widgets/sections/testimonials_section.dart';
import 'widgets/common/nav_button.dart';
import 'widgets/common/scroll_progress_indicator.dart';
import 'widgets/common/floating_action_menu.dart';
import 'widgets/common/scroll_to_top_button.dart';
import 'package:seo_renderer/seo_renderer.dart'; // Step 2: SEO Import
import 'widgets/common/custom_cursor.dart';
import 'utils/url_launcher_utils.dart';
import 'theme/theme_controller.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Error handling for Flutter web
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    if (kDebugMode) {
      print('Flutter Error: ${details.exception}');
      print('Stack trace: ${details.stack}');
    }
  };

  // Handle platform errors
  PlatformDispatcher.instance.onError = (error, stack) {
    if (kDebugMode) {
      print('Platform Error: $error');
      print('Stack trace: $stack');
    }
    return true;
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ThemeController
    final themeController = ThemeController();

    return RobotDetector(
      child: ListenableBuilder(
        listenable: themeController,
        builder: (context, _) {
          return MaterialApp(
            title: 'Mohamed Adel - Flutter Developer',
            debugShowCheckedModeBanner: false,
            scrollBehavior: CustomScrollBehavior(),
            // Define both themes
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            // Use controller's mode
            themeMode: themeController.themeMode,
            builder: (context, child) {
              return CustomCursor(child: child ?? const SizedBox.shrink());
            },
            home: PortfolioPage(themeController: themeController),
          );
        },
      ),
    );
  }
}

// Step 3: Custom MaterialScrollBehavior for touch and mouse dragging
class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}

class PortfolioPage extends StatefulWidget {
  final ThemeController? themeController;

  const PortfolioPage({super.key, this.themeController});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final AutoScrollController _scrollController = AutoScrollController();
  final ValueNotifier<double> _scrollOffsetNotifier = ValueNotifier<double>(0);
  double _maxScroll = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollOffsetNotifier.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Performance: Pre-cache critical assets early
    // Cache UI specific assets
    precacheImage(const AssetImage('assets/images/gomla/logo.webp'), context);
    // Add other critical logos or hero backgrounds here

    // Cache all project logos and gallery images for smoother scrolling
    for (var project in AppData.projects) {
      if (project.logoUrl != null) {
        precacheImage(AssetImage(project.logoUrl!), context);
      }
      if (project.galleryImages != null) {
        for (var image in project.galleryImages!) {
          precacheImage(AssetImage(image), context);
        }
      }
    }
  }

  Future<void> _scrollToSection(int index) async {
    await _scrollController.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.begin,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is ScrollUpdateNotification) {
                  _scrollOffsetNotifier.value = notification.metrics.pixels;
                  if (_maxScroll != notification.metrics.maxScrollExtent) {
                    setState(() {
                      _maxScroll = notification.metrics.maxScrollExtent;
                    });
                  }
                }
                return false;
              },
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  _buildAppBar(context),
                  _buildHeroSection(),
                  _buildAboutSection(),
                  _buildExpertiseSection(),
                  _buildExperienceSection(),
                  _buildProjectsSection(),
                  _buildWhyChooseMeSection(),
                  _buildTestimonialsSection(),
                  _buildContactSection(),
                ],
                // Use ClampingScrollPhysics on Web for smoother sticky effects
                physics: kIsWeb
                    ? const ClampingScrollPhysics()
                    : const BouncingScrollPhysics(),
              ),
            ),
            // Scroll progress indicator
            if (_maxScroll > 0)
              ValueListenableBuilder<double>(
                valueListenable: _scrollOffsetNotifier,
                builder: (context, offset, _) {
                  return ScrollProgressIndicator(
                    scrollOffset: offset,
                    maxScroll: _maxScroll,
                  );
                },
              ),
            // Floating action menu
            const RepaintBoundary(child: FloatingActionMenu()),
            // Scroll to top button
            Builder(
              builder: (context) {
                final screenWidth = MediaQuery.of(context).size.width;
                final isMobile = screenWidth < 768;
                return Positioned(
                  bottom: isMobile ? 100 : 30,
                  right: isMobile ? 20 : 30,
                  child: ValueListenableBuilder<double>(
                    valueListenable: _scrollOffsetNotifier,
                    builder: (context, offset, _) {
                      return ScrollToTopButton(
                        onTap: () => _scrollToSection(0),
                        isVisible: offset > 500,
                      );
                    },
                  ),
                );
              },
            ),
            // Tour guide character - commented out for now
            // if (_maxScroll > 0)
            //   TourGuideCharacter(
            //     scrollOffset: _scrollOffset,
            //     maxScroll: _maxScroll,
            //     currentSection: _getCurrentSection(),
            //   ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAppBarActions(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    if (isMobile) {
      // Show menu icon on mobile
      return [
        IconButton(
          icon: Icon(
            widget.themeController?.isDarkMode ?? true
                ? Icons.light_mode_rounded
                : Icons.dark_mode_rounded,
            color: AppColors.primary,
          ),
          onPressed: () => widget.themeController?.toggleTheme(),
        ),
        IconButton(
          icon: const Icon(Icons.menu, color: AppColors.primary),
          onPressed: () {
            // Show bottom sheet with navigation options
            showModalBottomSheet(
              context: context,
              backgroundColor: AppColors.surface,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) => Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    NavButton(
                      label: 'Home',
                      onTap: () {
                        Navigator.pop(context);
                        _scrollToSection(0);
                      },
                    ),
                    const SizedBox(height: 12),
                    NavButton(
                      label: 'About',
                      onTap: () {
                        Navigator.pop(context);
                        _scrollToSection(1);
                      },
                    ),
                    const SizedBox(height: 12),
                    NavButton(
                      label: 'Experience',
                      onTap: () {
                        Navigator.pop(context);
                        _scrollToSection(2);
                      },
                    ),
                    const SizedBox(height: 12),
                    NavButton(
                      label: 'Projects',
                      onTap: () {
                        Navigator.pop(context);
                        _scrollToSection(3);
                      },
                    ),
                    const SizedBox(height: 12),
                    NavButton(
                      label: 'Contact',
                      onTap: () {
                        Navigator.pop(context);
                        _scrollToSection(4);
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ];
    } else {
      // Show full navigation on tablet/desktop
      return [
        NavButton(label: 'Home', onTap: () => _scrollToSection(0)),
        NavButton(label: 'About', onTap: () => _scrollToSection(1)),
        NavButton(label: 'Experience', onTap: () => _scrollToSection(2)),
        NavButton(label: 'Projects', onTap: () => _scrollToSection(3)),
        NavButton(label: 'Contact', onTap: () => _scrollToSection(4)),
        const SizedBox(width: 10),
        IconButton(
          onPressed: () => widget.themeController?.toggleTheme(),
          icon: Icon(
            widget.themeController?.isDarkMode ?? true
                ? Icons.light_mode_rounded
                : Icons.dark_mode_rounded,
            color: AppColors.primary,
          ),
          tooltip: 'Toggle Theme',
        ),
        const SizedBox(width: 20),
      ];
    }
  }

  SliverAppBar _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      title: Builder(
        builder: (context) {
          final screenWidth = MediaQuery.of(context).size.width;
          final isMobile = screenWidth < 768;
          return Row(
            children: [
              // Logo placeholder
              Container(
                    width: isMobile ? 32 : 40,
                    height: isMobile ? 32 : 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    child: Icon(
                      Icons.code,
                      color: AppColors.primary,
                      size: isMobile ? 18 : 24,
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .scale(delay: 200.ms, duration: 400.ms),
              SizedBox(width: isMobile ? 8 : 12),
              Text(
                    isMobile ? '<MA />' : '<Mohamed Adel />',
                    style: GoogleFonts.poppins(
                      fontSize: isMobile ? 18 : 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 600.ms)
                  .slideX(begin: -0.3, end: 0, delay: 200.ms, duration: 600.ms),
            ],
          );
        },
      ),
      centerTitle: false,
      actions: _buildAppBarActions(context),
    );
  }

  Widget _buildHeroSection() {
    return SliverToBoxAdapter(
      child: AutoScrollTag(
        key: const ValueKey(0),
        index: 0,
        controller: _scrollController,
        child: HeroSection(
          scrollOffsetListenable: _scrollOffsetNotifier,
          onViewProjects: () => _scrollToSection(3), // Index 3 for Projects
          onContactMe: () => _scrollToSection(4), // Index 4 for Contact
          onDownloadCV: () => UrlLauncherUtils.downloadFile(AppData.cvUrl),
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return SliverToBoxAdapter(
      child: AutoScrollTag(
        key: const ValueKey(1),
        index: 1,
        controller: _scrollController,
        child: AboutSection(
          scrollOffsetListenable: _scrollOffsetNotifier,
          onDownloadCV: () => UrlLauncherUtils.downloadFile(AppData.cvUrl),
        ),
      ),
    );
  }

  Widget _buildExperienceSection() {
    return SliverToBoxAdapter(
      child: AutoScrollTag(
        key: const ValueKey(2),
        index: 2,
        controller: _scrollController,
        child: ExperienceSection(scrollOffsetListenable: _scrollOffsetNotifier),
      ),
    );
  }

  Widget _buildProjectsSection() {
    return SliverToBoxAdapter(
      child: AutoScrollTag(
        key: const ValueKey(3),
        index: 3,
        controller: _scrollController,
        child: ProjectsSection(scrollOffsetListenable: _scrollOffsetNotifier),
      ),
    );
  }

  Widget _buildExpertiseSection() {
    return SliverToBoxAdapter(
      child: ExpertiseSection(scrollOffsetListenable: _scrollOffsetNotifier),
    );
  }

  Widget _buildWhyChooseMeSection() {
    return SliverToBoxAdapter(
      child: WhyChooseMeSection(scrollOffsetListenable: _scrollOffsetNotifier),
    );
  }

  Widget _buildTestimonialsSection() {
    return SliverToBoxAdapter(
      child: TestimonialsSection(scrollOffsetListenable: _scrollOffsetNotifier),
    );
  }

  Widget _buildContactSection() {
    return SliverToBoxAdapter(
      child: AutoScrollTag(
        key: const ValueKey(4),
        index: 4,
        controller: _scrollController,
        child: ContactSection(scrollOffsetListenable: _scrollOffsetNotifier),
      ),
    );
  }
}
