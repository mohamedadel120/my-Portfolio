import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CodeStyledSubtitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const CodeStyledSubtitle({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final tagTitle = title.replaceAll(' ', '');
    // We split by "Developer" to style it dynamically
    final parts = tagTitle.split(RegExp(r'Developer', caseSensitive: false));
    final List<TextSpan> titleSpans = [];

    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isNotEmpty) {
        titleSpans.add(
          TextSpan(
            text: parts[i],
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }
      if (i < parts.length - 1) {
        titleSpans.add(
          TextSpan(
            text: 'Developer',
            style: GoogleFonts.jetBrainsMono(
              color: colorScheme.primary,
              fontWeight: FontWeight.w500, // Medium
            ),
          ),
        );
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: GoogleFonts.firaCode(
            fontSize: 18,
            height: 1.5,
            color: colorScheme.onSurface,
          ),
          children: [
            TextSpan(
              text: '<',
              style: TextStyle(color: colorScheme.secondary),
            ),
            ...titleSpans,
            if (subtitle.isNotEmpty) ...[
              const TextSpan(text: ' '),
              TextSpan(
                text: 'experience',
                style: TextStyle(color: Colors.blueAccent[100]),
              ),
              TextSpan(
                text: '=',
                style: TextStyle(color: colorScheme.secondary),
              ),
              TextSpan(
                text: '"$subtitle"',
                style: TextStyle(color: Colors.greenAccent[200]),
              ),
            ],
            const TextSpan(text: ' '),
            TextSpan(
              text: '/>',
              style: TextStyle(color: colorScheme.secondary),
            ),
          ],
        ),
      ),
    );
  }
}
