import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/project.dart';

class ProjectHeader extends StatelessWidget {
  final Project project;
  final bool isVisible;
  final Duration delay;

  const ProjectHeader({
    super.key,
    required this.project,
    required this.isVisible,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    final logoSize = isMobile ? 28.0 : (isTablet ? 32.0 : 35.0);
    final fontSize = isMobile ? 16.0 : (isTablet ? 17.0 : 18.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (project.androidStoreUrl != null || project.iosStoreUrl != null) ...[
          Row(
            children: [
              if (project.androidStoreUrl != null)
                _StoreLink(
                  url: project.androidStoreUrl!,
                  label: 'Android',
                  icon: Icons.android_rounded,
                  color: const Color(0xFF3DDC84),
                  isVisible: isVisible,
                  delay: delay,
                ),
              if (project.androidStoreUrl != null &&
                  project.iosStoreUrl != null)
                const SizedBox(width: 8),
              if (project.iosStoreUrl != null)
                _StoreLink(
                  url: project.iosStoreUrl!,
                  label: 'iOS',
                  icon: Icons.phone_iphone_rounded,
                  color: Colors.white,
                  isVisible: isVisible,
                  delay: delay + 50.ms,
                ),
            ],
          ),
          SizedBox(height: isMobile ? 6 : (isTablet ? 8 : 10)),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(isMobile ? 8 : 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    project.color.withValues(alpha: 0.2),
                    project.color.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: project.color.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: project.logoUrl != null
                  ? Hero(
                      tag: 'project_logo_${project.title}',
                      child: Image.asset(
                        project.logoUrl!,
                        width: logoSize,
                        height: logoSize,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            _DefaultLogoIcon(
                              color: project.color,
                              size: fontSize,
                            ),
                      ),
                    )
                  : Hero(
                      tag: 'project_logo_text_${project.title}',
                      child: Material(
                        color: Colors.transparent,
                        child: _DefaultLogoIcon(
                          color: project.color,
                          size: fontSize,
                        ),
                      ),
                    ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    project.color.withValues(alpha: 0.2),
                    project.color.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: project.color.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.download_rounded, size: 14, color: project.color),
                  const SizedBox(width: 4),
                  Text(
                    project.downloads,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: project.color,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StoreLink extends StatelessWidget {
  final String url;
  final String label;
  final IconData icon;
  final Color color;
  final bool isVisible;
  final Duration delay;

  const _StoreLink({
    required this.url,
    required this.label,
    required this.icon,
    required this.color,
    required this.isVisible,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child:
          Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: color.withValues(alpha: 0.4), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 18, color: color),
                    const SizedBox(width: 4),
                    Text(
                      label,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
              .animate(autoPlay: isVisible)
              .fadeIn(delay: delay, duration: 400.ms)
              .scale(
                delay: delay,
                begin: const Offset(0.8, 0.8),
                duration: 400.ms,
              ),
    );
  }
}

class _DefaultLogoIcon extends StatelessWidget {
  final Color color;
  final double size;

  const _DefaultLogoIcon({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Text(
      '<>',
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.bold,
        fontFamily: 'monospace',
      ),
    );
  }
}
