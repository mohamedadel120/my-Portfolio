import 'package:flutter/material.dart';
import '../../utils/device_utils.dart';
import 'nav_bar_item.dart';

class CustomNavBar extends StatefulWidget {
  const CustomNavBar({super.key});

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = DeviceUtils.isDesktop(screenWidth);
    final primary = Theme.of(context).colorScheme.primary;

    // On Mobile/Tablet, we might want a simpler version or just a menu icon
    // For now, let's implement the Desktop bar as requested.

    if (!isDesktop) {
      return _buildMobileNavBar(context);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Center the tabs
        children: [
          // Glassmorphic Capsule Container
          MouseRegion(
            onEnter: (_) => setState(() => _isHovered = true),
            onExit: (_) => setState(() => _isHovered = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surface
                    .withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: _isHovered
                      ? primary.withValues(alpha: 0.5)
                      : Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.1),
                  width: _isHovered ? 1.5 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _isHovered
                        ? primary.withValues(alpha: 0.15)
                        : Colors.black.withValues(alpha: 0.1),
                    blurRadius: _isHovered ? 30 : 20,
                    spreadRadius: _isHovered ? 2 : 0,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  NavBarItem(
                    title: 'About',
                    onTap: () => Navigator.pushNamed(context, '/about'),
                  ),
                  const SizedBox(width: 32),
                  NavBarItem(
                    title: 'Experience',
                    onTap: () => Navigator.pushNamed(context, '/experience'),
                  ),
                  const SizedBox(width: 32),
                  NavBarItem(
                    title: 'Projects',
                    onTap: () => Navigator.pushNamed(context, '/projects'),
                  ),
                  const SizedBox(width: 32),
                  NavBarItem(
                    title: 'Contact',
                    onTap: () => Navigator.pushNamed(context, '/contact'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileNavBar(BuildContext context) {
    // Horizontal Scrollable List for Mobile
    return Container(
      height: 60,
      padding: const EdgeInsets.only(top: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          NavBarItem(
            title: 'About',
            onTap: () => Navigator.pushNamed(context, '/about'),
          ),
          const SizedBox(width: 16),
          NavBarItem(
            title: 'Experience',
            onTap: () => Navigator.pushNamed(context, '/experience'),
          ),
          const SizedBox(width: 16),
          NavBarItem(
            title: 'Projects',
            onTap: () => Navigator.pushNamed(context, '/projects'),
          ),
          const SizedBox(width: 16),
          NavBarItem(
            title: 'Contact',
            onTap: () => Navigator.pushNamed(context, '/contact'),
          ),
        ],
      ),
    );
  }
}
