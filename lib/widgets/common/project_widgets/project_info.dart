import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../features/projects/domain/entities/project_entity.dart';
import '../../../core/constants/app_colors.dart';

class ProjectInfo extends StatelessWidget {
  final Project project;

  const ProjectInfo({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: isMobile ? 18 : 20,
              margin: EdgeInsets.only(right: isMobile ? 8 : 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [project.color, project.color.withValues(alpha: 0.5)],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: Text(
                project.title,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: isMobile ? 18 : (isTablet ? 20 : 22),
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  letterSpacing: 0.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: isMobile ? 8 : (isTablet ? 10 : 12)),
        Text(
          project.description,
          style: GoogleFonts.jetBrainsMono(
            fontSize: isMobile ? 12 : (isTablet ? 13 : 14),
            color: AppColors.textSecondary.withValues(alpha: 0.9),
            height: isMobile ? 1.5 : 1.6,
            letterSpacing: 0.1,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: isMobile ? 12 : (isTablet ? 14 : 16)),
        Wrap(
          spacing: isMobile ? 3 : 4,
          runSpacing: isMobile ? 3 : 4,
          children: project.tech
              .take(2)
              .map(
                (tech) => _TechTag(
                  label: tech,
                  color: project.color,
                  isMobile: isMobile,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _TechTag extends StatelessWidget {
  final String label;
  final Color color;
  final bool isMobile;

  const _TechTag({
    required this.label,
    required this.color,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 5 : 6,
        vertical: isMobile ? 2 : 3,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        label,
        style: GoogleFonts.jetBrainsMono(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
