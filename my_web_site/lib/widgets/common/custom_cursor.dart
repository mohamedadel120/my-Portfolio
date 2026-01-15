import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomCursor extends StatefulWidget {
  final Widget child;

  const CustomCursor({super.key, required this.child});

  @override
  State<CustomCursor> createState() => _CustomCursorState();
}

class _CustomCursorState extends State<CustomCursor> {
  Offset _position = Offset.zero;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    // Hide default cursor
    // MouseCursor.defer; // We might want to use SystemMouseCursors.none but wrapped in a MouseRegion
  }

  void _onHover(PointerHoverEvent event) {
    setState(() {
      _position = event.position;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Only show custom cursor on platforms with mouse (web desktop)
    // For simplicity, we assume web here since it's a portfolio.

    return MouseRegion(
      cursor: SystemMouseCursors.none, // Hide default cursor
      onHover: _onHover,
      child: Stack(
        children: [
          widget.child,
          AnimatedPositioned(
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
            left: _position.dx - 10, // Center offset
            top: _position.dy - 10,
            child: IgnorePointer(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: _isHovering ? 40 : 20,
                height: _isHovering ? 40 : 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.3),
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 50),
            curve: Curves.linear,
            left: _position.dx - 4,
            top: _position.dy - 4,
            child: IgnorePointer(
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
