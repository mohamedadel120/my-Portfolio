import 'package:flutter/material.dart';

class PhoneFrame extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final Color frameColor;

  const PhoneFrame({
    super.key,
    required this.child,
    this.width = 300,
    this.height = 600,
    this.frameColor = const Color(0xFF2A2A2A), // Dark Titanium
  });

  @override
  Widget build(BuildContext context) {
    // Ratios for a realistic look (approx iPhone 15 Pro ratios)
    final double bezel = 6.0;
    final double frameThickness = 3.0;

    return SizedBox(
      width: width + 10, // Account for buttons bubbling out
      height: height,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // --- BUTTONS (Left Side - Volume) ---
          Positioned(
            left: 2,
            top: height * 0.18,
            child: const _SideButton(height: 26, width: 4),
          ),
          Positioned(
            left: 2,
            top: height * 0.24,
            child: const _SideButton(height: 40, width: 4),
          ),
          Positioned(
            left: 2,
            top: height * 0.31,
            child: const _SideButton(height: 40, width: 4),
          ),

          // --- BUTTONS (Right Side - Power) ---
          Positioned(
            right: 2,
            top: height * 0.25,
            child: const _SideButton(height: 60, width: 4),
          ),

          // --- MAIN FRAME ---
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(44),

              // Realistic Metal Shading Gradient
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF555555), // Light reflection
                  Color(0xFF222222), // Dark metal
                  Color(0xFF111111), // Shadow
                  Color(0xFF444444), // Rim light
                ],
                stops: [0.0, 0.4, 0.6, 1.0],
              ),

              boxShadow: [
                // Deep ambient shadow
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 50,
                  spreadRadius: -10,
                  offset: const Offset(0, 30),
                ),
                // Subtle outline glow
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.05),
                  blurRadius: 2,
                  spreadRadius: 1,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Container(
              margin: EdgeInsets.all(frameThickness), // The metal rim thickness
              decoration: BoxDecoration(
                color: Colors.black, // Inner black bezel
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Colors.black, width: bezel),
              ),
              child: Stack(
                children: [
                  // --- SCREEN CONTENT ---
                  ClipRRect(
                    borderRadius: BorderRadius.circular(34),
                    child: child,
                  ),

                  // --- DYNAMIC ISLAND ---
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: const EdgeInsets.only(top: 11),
                      width: width * 0.3, // Proportional
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),

                  // --- GLASS REFLECTION (Subtle) ---
                  IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(34),
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Colors.white.withValues(alpha: 0.03),
                            Colors.transparent,
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.2, 1.0],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SideButton extends StatelessWidget {
  final double height;
  final double width;

  const _SideButton({required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xFF222222),
        borderRadius: BorderRadius.circular(2),
        border: Border.all(color: const Color(0xFF444444), width: 0.5),
      ),
    );
  }
}
