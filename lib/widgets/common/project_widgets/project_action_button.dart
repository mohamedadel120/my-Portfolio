import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../features/projects/domain/entities/project_entity.dart';
import 'project_color.dart';
import '../project_image_gallery.dart';

class ProjectActionButton extends StatelessWidget {
  final Project project;
  final bool isHovered;

  const ProjectActionButton({
    super.key,
    required this.project,
    required this.isHovered,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 1,
          margin: EdgeInsets.symmetric(vertical: isMobile ? 8 : 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                project.uiColor.withValues(alpha: 0.3),
                project.uiColor.withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
        SizedBox(height: isMobile ? 8 : (isTablet ? 10 : 12)),
        GestureDetector(
          onTap: () {
            if (project.galleryImages != null &&
                project.galleryImages!.isNotEmpty) {
              showDialog(
                context: context,
                builder: (context) => ProjectImageGallery(
                  images: project.galleryImages!,
                  projectTitle: project.title,
                  projectColor: project.uiColor,
                ),
              );
            }
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 20,
                vertical: isMobile ? 10 : 12,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [project.uiColor, project.uiColor.withValues(alpha: 0.8)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isHovered ? 0.15 : 0.08),
                    blurRadius: isHovered ? 12 : 8,
                    spreadRadius: 0,
                    offset: Offset(0, isHovered ? 4 : 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Discover',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: isMobile ? 13 : 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: isMobile ? 16 : 18,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
