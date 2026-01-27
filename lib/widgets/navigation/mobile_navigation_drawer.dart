import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MobileNavigationDrawer extends StatelessWidget {
  const MobileNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      elevation: 0,
      width: MediaQuery.of(context).size.width, // Full Screen
      child: Stack(
        children: [
          // 1. Heavy Blur Background
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                color:
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
              ),
            ),
          ),

          // 2. Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _CinematicMenuItem(
                  title: 'ABOUT',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/about');
                  },
                  delay: 200.ms,
                ),
                _CinematicMenuItem(
                  title: 'EXPERIENCE',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/experience');
                  },
                  delay: 300.ms,
                ),
                _CinematicMenuItem(
                  title: 'PROJECTS',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/projects');
                  },
                  delay: 400.ms,
                ),
                _CinematicMenuItem(
                  title: 'CONTACT',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/contact');
                  },
                  delay: 500.ms,
                ),
              ],
            ),
          ),

          // 3. Close Button (Top Right)
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.close_rounded,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
            ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
          ),

          // 4. Decoration (Optional)
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                '© 2024 MOHAMED ADEL',
                style: GoogleFonts.firaCode(
                  fontSize: 10,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                  letterSpacing: 2,
                ),
              ),
            ).animate().fadeIn(delay: 800.ms),
          ),
        ],
      ),
    );
  }
}

class _CinematicMenuItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Duration delay;

  const _CinematicMenuItem({
    required this.title,
    required this.onTap,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
          title,
          style: GoogleFonts.anton(
            // Cinematic Big Font
            fontSize: 50,
            letterSpacing: 2,
            height: 1.0,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        )
            .animate()
            .fadeIn(delay: delay, duration: 600.ms)
            .moveY(begin: 30, end: 0, delay: delay, curve: Curves.easeOutQuad),
      ),
    );
  }
}
