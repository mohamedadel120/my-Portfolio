import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TechStackFilter extends StatelessWidget {
  final Set<String> allTechStacks;
  final Set<String> selectedFilters;
  final Function(Set<String>) onFilterChanged;
  final bool isMobile;
  final bool isTablet;

  const TechStackFilter({
    super.key,
    required this.allTechStacks,
    required this.selectedFilters,
    required this.onFilterChanged,
    required this.isMobile,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final sortedTechStacks = allTechStacks.toList()..sort();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(
              Icons.filter_list_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: isMobile ? 20 : 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Filter by Tech Stack',
              style: GoogleFonts.jetBrainsMono(
                fontSize: isMobile ? 16 : (isTablet ? 18 : 20),
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
                letterSpacing: 0.2,
              ),
            ),
            const Spacer(),
            if (selectedFilters.isNotEmpty)
              TextButton.icon(
                onPressed: () => onFilterChanged({}),
                icon: Icon(
                  Icons.clear_rounded,
                  size: isMobile ? 16 : 18,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
                label: Text(
                  'Clear',
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: isMobile ? 12 : 14,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: isMobile ? 12 : 16),
        Wrap(
          spacing: isMobile ? 8 : 12,
          runSpacing: isMobile ? 8 : 12,
          children: sortedTechStacks.map((tech) {
            final isSelected = selectedFilters.contains(tech);
            return _FilterChip(
              label: tech,
              isSelected: isSelected,
              onTap: () {
                final newFilters = Set<String>.from(selectedFilters);
                if (isSelected) {
                  newFilters.remove(tech);
                } else {
                  newFilters.add(tech);
                }
                onFilterChanged(newFilters);
              },
              isMobile: isMobile,
              isTablet: isTablet,
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _FilterChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isMobile;
  final bool isTablet;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isMobile,
    required this.isTablet,
  });

  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: widget.isMobile ? 14 : 18,
            vertical: widget.isMobile ? 8 : 10,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.isSelected
                  ? [
                      Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.3),
                      Theme.of(
                        context,
                      ).colorScheme.secondary.withValues(alpha: 0.2),
                    ]
                  : [
                      Theme.of(
                        context,
                      ).colorScheme.surface.withValues(alpha: 0.8),
                      Theme.of(
                        context,
                      ).colorScheme.surface.withValues(alpha: 0.6),
                    ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isSelected
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.6)
                  : Theme.of(context).colorScheme.primary.withValues(
                        alpha: _isHovered ? 0.4 : 0.2,
                      ),
              width: widget.isSelected ? 2 : 1.5,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          transform: Matrix4.identity()..multiply(Matrix4.diagonal3Values(_isHovered ? 1.05 : 1.0, _isHovered ? 1.05 : 1.0, 1.0)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.isSelected)
                Icon(
                  Icons.check_circle_rounded,
                  size: widget.isMobile ? 16 : 18,
                  color: Theme.of(context).colorScheme.primary,
                ),
              if (widget.isSelected) const SizedBox(width: 6),
              Text(
                widget.label,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: widget.isMobile ? 12 : 14,
                  fontWeight:
                      widget.isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: widget.isSelected
                      ? Theme.of(context).colorScheme.onSurface
                      : Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.7),
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
