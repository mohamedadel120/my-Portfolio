import 'dart:ui'; // For ImageFilter
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum CursorType {
  defaultCursor,
  pointer, // For buttons
  text, // For text inputs or selection
}

class CursorController extends ValueNotifier<CursorType> {
  CursorController() : super(CursorType.defaultCursor);

  void setCursor(CursorType type) => value = type;
}

// Global instance (service locator style for simplicity in this context)
final cursorController = CursorController();

class AdaptiveCursor extends StatefulWidget {
  final Widget child;

  const AdaptiveCursor({super.key, required this.child});

  @override
  State<AdaptiveCursor> createState() => _AdaptiveCursorState();
}

class _AdaptiveCursorState extends State<AdaptiveCursor> {
  Offset _mousePos = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (details) {
        setState(() {
          _mousePos = details.position;
        });
      },
      cursor: SystemMouseCursors.none, // Hide system cursor
      child: Stack(
        children: [
          widget.child,

          // Custom Cursor Overlay
          ValueListenableBuilder<CursorType>(
            valueListenable: cursorController,
            builder: (context, type, _) {
              final isPointer = type == CursorType.pointer;

              return AnimatedPositioned(
                duration: const Duration(milliseconds: 50), // Immediate follow
                left: _mousePos.dx - _getSize(type) / 2,
                top: _mousePos.dy - _getSize(type) / 2,
                child: IgnorePointer(
                  child: ExcludeSemantics(
                    child: _buildCursor(type, context, isPointer),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCursor(CursorType type, BuildContext context, bool isPointer) {
    Widget cursor = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutExpo,
      width: _getSize(type),
      height: _getSize(type),
      decoration: BoxDecoration(
        color: _getColor(type, context),
        shape: BoxShape.circle,
        border: _getBorder(type, context),
        boxShadow: _getBoxShadow(type, context),
      ),
    );

    // Apply Glassmorphism and Pulse only for pointer
    if (isPointer) {
      cursor = ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: cursor,
        ),
      )
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .scaleXY(end: 1.1, duration: 1000.ms, curve: Curves.easeInOut);
    }

    return cursor;
  }

  double _getSize(CursorType type) {
    switch (type) {
      case CursorType.pointer:
        return 50.0;
      case CursorType.text:
        return 30.0;
      case CursorType.defaultCursor:
        return 12.0;
    }
  }

  Color _getColor(CursorType type, BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    switch (type) {
      case CursorType.pointer:
        return primary.withOpacity(0.15); // Subtle fill
      case CursorType.text:
        return primary.withOpacity(0.1);
      case CursorType.defaultCursor:
        return primary;
    }
  }

  BoxBorder? _getBorder(CursorType type, BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    switch (type) {
      case CursorType.pointer:
        return Border.all(color: primary, width: 2);
      case CursorType.defaultCursor:
        return null;
      default:
        return null;
    }
  }

  List<BoxShadow>? _getBoxShadow(CursorType type, BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    switch (type) {
      case CursorType.pointer:
        return [
          BoxShadow(
            color: primary.withOpacity(0.4),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ];
      default:
        return null;
    }
  }
}
