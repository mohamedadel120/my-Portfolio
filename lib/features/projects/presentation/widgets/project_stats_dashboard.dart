import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectStatsDashboard extends StatelessWidget {
  final Map<String, dynamic> stats;
  final bool isMobile;
  final bool isTablet;

  const ProjectStatsDashboard({
    super.key,
    required this.stats,
    required this.isMobile,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : (isTablet ? 24 : 28)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
            Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
            Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.15),
            blurRadius: 25,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(
            icon: Icons.apps_rounded,
            label: 'Projects',
            value: '${stats['totalProjects']}',
            color: Theme.of(context).colorScheme.primary,
            isMobile: isMobile,
            isTablet: isTablet,
          ),
          Container(
            width: 1,
            height: isMobile ? 40 : 50,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          ),
          _StatItem(
            icon: Icons.download_rounded,
            label: 'Downloads',
            value: '${(stats['totalDownloads'] / 1000).toStringAsFixed(0)}K+',
            color: Theme.of(context).colorScheme.secondary,
            isMobile: isMobile,
            isTablet: isTablet,
          ),
          Container(
            width: 1,
            height: isMobile ? 40 : 50,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          ),
          _StatItem(
            icon: Icons.star_rounded,
            label: 'Rating',
            value: stats['averageRating'].toStringAsFixed(1),
            color: Theme.of(context).colorScheme.primary,
            isMobile: isMobile,
            isTablet: isTablet,
          ),
          Container(
            width: 1,
            height: isMobile ? 40 : 50,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          ),
          _StatItem(
            icon: Icons.code_rounded,
            label: 'Tech Stacks',
            value: '${stats['techStacks']}',
            color: Theme.of(context).colorScheme.secondary,
            isMobile: isMobile,
            isTablet: isTablet,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isMobile;
  final bool isTablet;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.isMobile,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(isMobile ? 10 : 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color.withValues(alpha: 0.3),
                color.withValues(alpha: 0.15),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.4), width: 1.5),
          ),
          child: Icon(icon, color: color, size: isMobile ? 24 : 28),
        ),
        SizedBox(height: isMobile ? 8 : 12),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: isMobile ? 20 : (isTablet ? 24 : 28),
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: isMobile ? 11 : (isTablet ? 12 : 13),
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.7),
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}
