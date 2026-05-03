import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../widgets/common/gsap_stagger_animation.dart';
import '../../../../widgets/common/adaptive_cursor.dart';
import '../../domain/entities/expertise_entity.dart';

class ExpertiseCard extends StatefulWidget {
  final Expertise expertise;
  final double scrollOffset;
  final double sectionStartOffset;
  final double viewportHeight;
  final int index;
  final bool isMobile;
  final bool isTablet;

  const ExpertiseCard({
    super.key,
    required this.expertise,
    required this.scrollOffset,
    required this.sectionStartOffset,
    required this.viewportHeight,
    required this.index,
    required this.isMobile,
    required this.isTablet,
  });

  @override
  State<ExpertiseCard> createState() => _ExpertiseCardState();
}

class _ExpertiseCardState extends State<ExpertiseCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    // Format index as 01, 02 etc.
    final indexStr = (widget.index + 1).toString().padLeft(2, '0');
    final primaryColor = Theme.of(context).colorScheme.primary;

    // Use GSAP Stagger for entrance
    return GSAPEnhancedAnimation(
      elementId: 'expertise-item-${widget.index}',
      scrollOffset: widget.scrollOffset,
      sectionStartOffset: widget.sectionStartOffset + (widget.index * 100),
      viewportHeight: widget.viewportHeight,
      animationConfig: const {
        'opacity': {'from': 0, 'to': 1},
        'y': {'from': 50, 'to': 0},
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Clickable(
          child: GestureDetector(
            onTap: () => _showExpertiseDetails(context, primaryColor),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              margin: const EdgeInsets.only(bottom: 0),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _isHovered ? primaryColor : Colors.white24,
                    width: 1,
                  ),
                  bottom: widget.index ==
                          3 // Assuming 4 items, add bottom border to last
                      ? BorderSide(
                          color: _isHovered ? primaryColor : Colors.white24,
                          width: 1,
                        )
                      : BorderSide.none,
                ),
                color: _isHovered
                    ? primaryColor.withValues(alpha: 0.03)
                    : Colors.transparent,
              ),
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
              child: widget.isMobile
                  ? _buildMobileLayout(indexStr, primaryColor)
                  : _buildDesktopLayout(indexStr, primaryColor),
            ),
          ),
        ),
      ),
    );
  }

  void _showExpertiseDetails(BuildContext context, Color primaryColor) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withValues(alpha: 0.8),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutBack,
                ),
                child: Container(
                  width: widget.isMobile ? double.infinity : 600,
                  margin: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: primaryColor.withValues(alpha: 0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: 0.1),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: BackdropFilter(
                      filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Stack(
                        children: [
                          Positioned(
                            top: -100,
                            right: -100,
                            child: Container(
                              width: 300,
                              height: 300,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryColor.withValues(alpha: 0.1),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(40),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: primaryColor.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: primaryColor.withValues(alpha: 0.2),
                                        ),
                                      ),
                                      child: Icon(
                                        widget.expertise.icon,
                                        size: 48,
                                        color: primaryColor,
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.expertise.title,
                                            style: GoogleFonts.orbitron(
                                              fontSize: 32,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              height: 1.1,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'EXPERTISE DETAILS',
                                            style: GoogleFonts.spaceMono(
                                              fontSize: 12,
                                              color: primaryColor.withValues(
                                                  alpha: 0.6),
                                              letterSpacing: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 32),
                                Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: Colors.white.withValues(alpha: 0.1),
                                ),
                                const SizedBox(height: 32),
                                Text(
                                  widget.expertise.description,
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    height: 1.6,
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                ),
                                const SizedBox(height: 40),
                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      foregroundColor: Colors.black,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      'CLOSE',
                                      style: GoogleFonts.spaceMono(
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopLayout(String indexStr, Color primaryColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Index
        SizedBox(
          width: 80,
          child: Text(
            indexStr,
            style: GoogleFonts.spaceMono(
              fontSize: 20,
              color: primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // Title
        Expanded(
          flex: 3,
          child: Text(
            widget.expertise.title,
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
              height: 1.1,
            ),
          ),
        ),

        // Description
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              widget.expertise.description,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white70,
                height: 1.6,
              ),
            ),
          ),
        ),

        // Tools / Icon Arrow
        SizedBox(
            width: 60,
            child: Align(
              alignment: Alignment.topRight,
              child: AnimatedRotation(
                duration: 300.ms,
                turns: _isHovered ? 0.125 : 0, // 45 degrees
                child: Icon(
                  Icons.arrow_outward_rounded,
                  color: _isHovered ? primaryColor : Colors.white24,
                  size: 32,
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildMobileLayout(String indexStr, Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          indexStr,
          style: GoogleFonts.spaceMono(
            fontSize: 16,
            color: primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          widget.expertise.title,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          widget.expertise.description,
          style: GoogleFonts.poppins(
            fontSize: 15,
            color: Colors.white70,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.arrow_forward_rounded,
            color: primaryColor,
          ),
        )
      ],
    );
  }
}
