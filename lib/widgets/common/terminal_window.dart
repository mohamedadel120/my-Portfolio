import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_colors.dart';

class TerminalWindow extends StatelessWidget {
  final List<String> commands;
  final double scrollOffset;
  final Duration delay;

  const TerminalWindow({
    super.key,
    required this.commands,
    required this.scrollOffset,
    Duration? delay,
  }) : delay = delay ?? const Duration(milliseconds: 0);

  @override
  Widget build(BuildContext context) {
    final parallaxY = scrollOffset * 0.15;
    final opacity = (1 - (scrollOffset / 800)).clamp(0.4, 1.0);

    return Transform.translate(
      offset: Offset(0, parallaxY),
      child: Opacity(
        opacity: opacity,
        child: SizedBox(
          width: 300,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Terminal header
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: const BoxDecoration(
                      color: Colors.yellow,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text(
                    'terminal',
                    style: GoogleFonts.spaceMono(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Terminal content
              ...commands.map((cmd) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '\$ ',
                          style: GoogleFonts.spaceMono(
                            fontSize: 14,
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            cmd,
                            style: GoogleFonts.spaceMono(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              // Cursor
              Container(
                width: 8,
                height: 16,
                color: AppColors.primary,
                margin: const EdgeInsets.only(top: 4),
              )
                  .animate(onPlay: (controller) => controller.repeat())
                  .fadeOut(duration: 500.ms)
                  .then()
                  .fadeIn(duration: 500.ms),
            ],
          ),
          ),
        ),
      )
          .animate()
          .fadeIn(delay: delay, duration: 800.ms)
          .scale(
            delay: delay,
            begin: const Offset(0.9, 0.9),
            duration: 800.ms,
          ),
    );
  }
}

