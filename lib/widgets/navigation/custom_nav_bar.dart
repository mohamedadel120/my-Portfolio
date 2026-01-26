import 'package:flutter/material.dart';
import '../../utils/device_utils.dart';
import 'nav_bar_item.dart';

class CustomNavBar extends StatelessWidget {
  const CustomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = DeviceUtils.isDesktop(screenWidth);

    // On Mobile/Tablet, we might want a simpler version or just a menu icon
    // For now, let's implement the Desktop bar as requested.

    if (!isDesktop) {
      // Mobile Version (Simplified)
      // We can return just a Menu Icon here which opens a drawer/bottom sheet
      // But the user asked for "tabs". Tabs usually imply visible items.
      // On mobile, "Scrollable Tabs" in a horizontal list is common.
      return _buildMobileNavBar(context);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Center the tabs
        children: [
          // Glassmorphic Capsule Container
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 0,
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
