import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/device_utils.dart';
import 'code_shape.dart' show CodeShapeType, CodeShapePainter;

class FloatingCodeShapes extends StatelessWidget {
  final double scrollOffset;

  const FloatingCodeShapes({
    super.key,
    required this.scrollOffset,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLowSpec = DeviceUtils.isLowSpecDevice(context);
    final isXS = DeviceUtils.isExtraSmall(screenSize.width);

    // Completely skip on low-spec devices for maximum performance
    if (isLowSpec) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : screenSize.width;
          final height = constraints.maxHeight.isFinite
              ? constraints.maxHeight
              : screenSize.height;

          final shapeCount = isXS ? 6 : 12;

          return SizedBox(
            width: width,
            height: height,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Floating code shapes with parallax effect
                ...List.generate(shapeCount, (index) {
                  final random = math.Random(index);
                  final type =
                      CodeShapeType.values[index % CodeShapeType.values.length];
                  final x = random.nextDouble() * width;
                  final y = random.nextDouble() * height;
                  final size =
                      (isXS ? 20 : 30) + random.nextDouble() * (isXS ? 30 : 50);
                  final parallaxSpeed = 0.1 + random.nextDouble() * 0.2;

                  return Positioned(
                    left: x + (scrollOffset * parallaxSpeed * 0.1),
                    top: y + (scrollOffset * parallaxSpeed),
                    child: RepaintBoundary(
                      child: Opacity(
                        opacity: 0.15 + random.nextDouble() * 0.2,
                        child: SizedBox(
                          width: size,
                          height: size,
                          child: CustomPaint(
                            painter: CodeShapePainter(
                              type: type,
                              size: size,
                              scrollOffset: scrollOffset,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                      .animate(onPlay: (controller) => controller.repeat())
                      .fadeIn(delay: (index * 100).ms, duration: 2000.ms)
                      .then()
                      .moveY(
                        begin: 0,
                        end: -20,
                        duration: 3000.ms,
                        curve: Curves.easeInOut,
                      )
                      .then()
                      .moveY(
                        begin: -20,
                        end: 0,
                        duration: 3000.ms,
                        curve: Curves.easeInOut,
                      );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}
