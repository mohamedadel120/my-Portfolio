import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
    
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth.isFinite ? constraints.maxWidth : screenSize.width;
          final height = constraints.maxHeight.isFinite ? constraints.maxHeight : screenSize.height;
          
          return SizedBox(
            width: width,
            height: height,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
        // Floating code shapes with parallax effect
        ...List.generate(15, (index) {
          final random = math.Random(index);
          final type = CodeShapeType.values[index % CodeShapeType.values.length];
          final x = random.nextDouble() * screenSize.width;
          final y = random.nextDouble() * screenSize.height;
          final size = 30 + random.nextDouble() * 50;
          final parallaxSpeed = 0.1 + random.nextDouble() * 0.2;
          
          return Positioned(
            left: x + (scrollOffset * parallaxSpeed * 0.1),
            top: y + (scrollOffset * parallaxSpeed),
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

