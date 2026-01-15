import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'magnetic_button.dart';

class NavButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const NavButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return MagneticButton(
          onTap: onTap,
          toxicity: 0.4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: -0.2, end: 0, duration: 400.ms);
  }
}
