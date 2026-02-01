import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../utils/device_utils.dart';

class ProcessSection extends StatelessWidget {
  const ProcessSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = DeviceUtils.isMobile(screenWidth);

    final steps = [
      {
        'number': '01',
        'title': 'Discovery',
        'desc': 'Understanding goals & user needs.'
      },
      {
        'number': '02',
        'title': 'Strategy',
        'desc': 'Planning the roadmap & architecture.'
      },
      {
        'number': '03',
        'title': 'Prototype',
        'desc': 'Visualizing the solution & interactions.'
      },
      {
        'number': '04',
        'title': 'Delivery',
        'desc': 'Final polish & production launch.'
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 2,
                color: AppColors.primary,
              ),
              const SizedBox(width: 16),
              Text(
                'WORK PROCESS',
                style: GoogleFonts.spaceMono(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  letterSpacing: 4,
                ),
              ),
            ],
          ).animate().fadeIn().slideX(begin: -0.2),
          const SizedBox(height: 16),
          Text(
            'How I bring ideas to life.',
            style: GoogleFonts.poppins(
              fontSize: isMobile ? 32 : 48,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.1,
            ),
          ).animate().fadeIn(delay: 100.ms).moveY(begin: 20, end: 0),
          const SizedBox(height: 60),
          LayoutBuilder(
            builder: (context, constraints) {
              if (isMobile) {
                return Column(
                  children: steps.asMap().entries.map((entry) {
                    return _buildStepItem(context, entry.value, entry.key,
                        isMobile: true);
                  }).toList(),
                );
              } else {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: steps.asMap().entries.map((entry) {
                    return Expanded(
                      child: _buildStepItem(context, entry.value, entry.key,
                          isMobile: false),
                    );
                  }).toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(
      BuildContext context, Map<String, String> step, int index,
      {required bool isMobile}) {
    return Container(
      margin: EdgeInsets.only(
        bottom: isMobile ? 48 : 0,
        right: isMobile ? 0 : 32,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background Number (Large & Subtle)
          Positioned(
            top: -20,
            left: -10,
            child: Text(
              step['number']!,
              style: GoogleFonts.orbitron(
                fontSize: 80,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary.withValues(alpha: 0.03),
                letterSpacing: -2,
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(
                height: 2,
                width: 30,
                color: AppColors.primary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                step['title']!,
                style: GoogleFonts.orbitron(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                step['desc']!,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.textSecondary.withValues(alpha: 0.8),
                  height: 1.6,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate(delay: (200 * index).ms).fadeIn().moveY(begin: 40, end: 0);
  }
}
