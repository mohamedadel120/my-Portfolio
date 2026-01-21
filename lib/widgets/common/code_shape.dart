import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/app_colors.dart';

class CodeShape extends StatelessWidget {
  final double scrollOffset;
  final CodeShapeType type;
  final double size;
  final Duration delay;

  const CodeShape({
    super.key,
    required this.scrollOffset,
    this.type = CodeShapeType.bracket,
    this.size = 40,
    this.delay = const Duration(milliseconds: 0),
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: CodeShapePainter(
        type: type,
        size: size,
        scrollOffset: scrollOffset,
      ),
    )
        .animate()
        .fadeIn(delay: delay, duration: 1000.ms)
        .scale(delay: delay, begin: const Offset(0, 0), duration: 800.ms)
        .then()
        .shimmer(
          duration: 3000.ms,
          color: AppColors.primary.withValues(alpha: 0.3),
        );
  }
}

enum CodeShapeType {
  bracket,
  curlyBrace,
  angleBracket,
  parenthesis,
  squareBracket,
  codeBlock,
  arrow,
  diamond,
  hexagon,
}

class CodeShapePainter extends CustomPainter {
  final CodeShapeType type;
  final double size;
  final double scrollOffset;

  CodeShapePainter({
    required this.type,
    required this.size,
    required this.scrollOffset,
  });

  @override
  void paint(Canvas canvas, Size canvasSize) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final center = Offset(canvasSize.width / 2, canvasSize.height / 2);
    final rotation = (scrollOffset * 0.001) % (2 * math.pi);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    switch (type) {
      case CodeShapeType.bracket:
        _drawBracket(canvas, paint);
        break;
      case CodeShapeType.curlyBrace:
        _drawCurlyBrace(canvas, paint);
        break;
      case CodeShapeType.angleBracket:
        _drawAngleBracket(canvas, paint);
        break;
      case CodeShapeType.parenthesis:
        _drawParenthesis(canvas, paint);
        break;
      case CodeShapeType.squareBracket:
        _drawSquareBracket(canvas, paint);
        break;
      case CodeShapeType.codeBlock:
        _drawCodeBlock(canvas, paint);
        break;
      case CodeShapeType.arrow:
        _drawArrow(canvas, paint);
        break;
      case CodeShapeType.diamond:
        _drawDiamond(canvas, paint);
        break;
      case CodeShapeType.hexagon:
        _drawHexagon(canvas, paint);
        break;
    }

    canvas.restore();
  }

  void _drawBracket(Canvas canvas, Paint paint) {
    final path = Path();
    path.moveTo(-size / 2, -size / 2);
    path.lineTo(-size / 2, size / 2);
    path.moveTo(-size / 2, -size / 2);
    path.lineTo(-size / 4, -size / 2);
    path.moveTo(-size / 2, size / 2);
    path.lineTo(-size / 4, size / 2);
    canvas.drawPath(path, paint);
  }

  void _drawCurlyBrace(Canvas canvas, Paint paint) {
    final path = Path();
    final halfSize = size / 2;
    path.moveTo(-halfSize / 2, -halfSize);
    path.cubicTo(
      -halfSize / 2,
      -halfSize / 2,
      -halfSize,
      -halfSize / 2,
      -halfSize,
      0,
    );
    path.cubicTo(
      -halfSize,
      halfSize / 2,
      -halfSize / 2,
      halfSize / 2,
      -halfSize / 2,
      halfSize,
    );
    canvas.drawPath(path, paint);
  }

  void _drawAngleBracket(Canvas canvas, Paint paint) {
    final path = Path();
    path.moveTo(-size / 2, 0);
    path.lineTo(0, -size / 2);
    path.moveTo(-size / 2, 0);
    path.lineTo(0, size / 2);
    canvas.drawPath(path, paint);
  }

  void _drawParenthesis(Canvas canvas, Paint paint) {
    final path = Path();
    final halfSize = size / 2;
    path.moveTo(-halfSize / 2, -halfSize);
    path.quadraticBezierTo(
      -halfSize,
      -halfSize / 2,
      -halfSize / 2,
      0,
    );
    path.quadraticBezierTo(
      -halfSize,
      halfSize / 2,
      -halfSize / 2,
      halfSize,
    );
    canvas.drawPath(path, paint);
  }

  void _drawSquareBracket(Canvas canvas, Paint paint) {
    final path = Path();
    path.moveTo(-size / 2, -size / 2);
    path.lineTo(-size / 2, size / 2);
    path.moveTo(-size / 2, -size / 2);
    path.lineTo(-size / 3, -size / 2);
    path.moveTo(-size / 2, size / 2);
    path.lineTo(-size / 3, size / 2);
    canvas.drawPath(path, paint);
  }

  void _drawCodeBlock(Canvas canvas, Paint paint) {
    final rect = Rect.fromLTWH(-size / 2, -size / 2, size, size);
    canvas.drawRect(rect, paint);
    // Draw lines inside
    final linePaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(-size / 3, -size / 3),
      Offset(size / 3, -size / 3),
      linePaint,
    );
    canvas.drawLine(
      Offset(-size / 3, 0),
      Offset(size / 3, 0),
      linePaint,
    );
    canvas.drawLine(
      Offset(-size / 3, size / 3),
      Offset(size / 3, size / 3),
      linePaint,
    );
  }

  void _drawArrow(Canvas canvas, Paint paint) {
    final path = Path();
    path.moveTo(-size / 2, 0);
    path.lineTo(size / 2, 0);
    path.moveTo(size / 3, -size / 4);
    path.lineTo(size / 2, 0);
    path.lineTo(size / 3, size / 4);
    canvas.drawPath(path, paint);
  }

  void _drawDiamond(Canvas canvas, Paint paint) {
    final path = Path();
    path.moveTo(0, -size / 2);
    path.lineTo(size / 2, 0);
    path.lineTo(0, size / 2);
    path.lineTo(-size / 2, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawHexagon(Canvas canvas, Paint paint) {
    final path = Path();
    final radius = size / 2;
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60 - 30) * math.pi / 180;
      final x = radius * math.cos(angle);
      final y = radius * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

