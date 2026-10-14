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

  // Firestore / local data can omit a field or send it as int or double, so
  // read every stat defensively instead of casting.
  num _num(String key) {
    final value = stats[key];
    return value is num ? value : 0;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dividerColor = scheme.primary.withValues(alpha: 0.3);

    final items = [
      _StatItem(
        icon: Icons.apps_rounded,
        label: 'Projects',
        value: '${_num('totalProjects').toInt()}',
        color: scheme.primary,
        isMobile: isMobile,
        isTablet: isTablet,
      ),
      _StatItem(
        icon: Icons.download_rounded,
        label: 'Downloads',
        value: '${(_num('totalDownloads') / 1000).toStringAsFixed(0)}K+',
        color: scheme.secondary,
        isMobile: isMobile,
        isTablet: isTablet,
      ),
      _StatItem(
        icon: Icons.star_rounded,
        label: 'Rating',
        value: _num('averageRating').toStringAsFixed(1),
        color: scheme.primary,
        isMobile: isMobile,
        isTablet: isTablet,
      ),
      _StatItem(
        icon: Icons.code_rounded,
        label: 'Tech Stacks',
        value: '${_num('techStacks').toInt()}',
        color: scheme.secondary,
        isMobile: isMobile,
        isTablet: isTablet,
      ),
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 8 : (isTablet ? 20 : 28),
        vertical: isMobile ? 20 : (isTablet ? 24 : 28),
      ),
      // Elevation is declared once, by the border; the extra drop shadow
      // under a bordered gradient card read as a ghost card.
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.primary.withValues(alpha: 0.15),
            scheme.secondary.withValues(alpha: 0.1),
            scheme.surface.withValues(alpha: 0.9),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: scheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0)
                Container(
                  width: 1,
                  height: isMobile ? 40 : 50,
                  color: dividerColor,
                ),
              // Equal flexible columns so four stats never overflow a
              // 360px phone, whatever the label length.
              Expanded(child: items[i]),
            ],
          ],
        ),
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
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Semantics(
      label: '$label: $value',
      excludeSemantics: true,
      child: Column(
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
              border: Border.all(color: color.withValues(alpha: 0.4)),
            ),
            child: Icon(icon, color: color, size: isMobile ? 24 : 28),
          ),
          SizedBox(height: isMobile ? 8 : 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: GoogleFonts.jetBrainsMono(
                fontSize: isMobile ? 20 : (isTablet ? 24 : 28),
                fontWeight: FontWeight.bold,
                color: onSurface,
                letterSpacing: 0.5,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: GoogleFonts.jetBrainsMono(
              fontSize: isMobile ? 11 : (isTablet ? 12 : 13),
              color: onSurface.withValues(alpha: 0.7),
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
