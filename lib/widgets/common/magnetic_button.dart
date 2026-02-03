import 'package:flutter/material.dart';
import 'adaptive_cursor.dart'; // Import to notify cursor state

class MagneticButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double force; // How strong the magnet is (0.0 to 1.0)
  final CursorType cursorType;

  const MagneticButton({
    super.key,
    required this.child,
    this.onTap,
    this.force = 0.5,
    this.cursorType = CursorType.pointer,
  });

  @override
  State<MagneticButton> createState() => _MagneticButtonState();
}

class _MagneticButtonState extends State<MagneticButton> {
  Offset _offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => cursorController.setCursor(widget.cursorType),
        onExit: (_) {
          cursorController.setCursor(CursorType.defaultCursor);
          setState(() => _offset = Offset.zero);
        },
        onHover: (details) {
          final renderBox = context.findRenderObject() as RenderBox;
          final center = renderBox.size.center(Offset.zero);
          final localPos = details.localPosition;

          // Calculate distance from center
          final dx = localPos.dx - center.dx;
          final dy = localPos.dy - center.dy;

          setState(() {
            _offset = Offset(dx * widget.force, dy * widget.force);
          });
        },
        child: TweenAnimationBuilder<Offset>(
          tween: Tween<Offset>(begin: Offset.zero, end: _offset),
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          builder: (context, offset, child) {
            return Transform.translate(
              offset: offset,
              child: widget.child,
            );
          },
        ),
      ),
    );
  }
}
