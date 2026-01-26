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

    // We want to format "Flutter Developer & 3+ Years Experience"
    // into something like:
    // <FlutterDeveloper experience="3+ Years" />

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.2),
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
            TextSpan(
              text: 'FlutterDeveloper',
              style: TextStyle(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
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
              text: '"3+ Years"',
              style: TextStyle(color: Colors.greenAccent[200]),
            ),
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
