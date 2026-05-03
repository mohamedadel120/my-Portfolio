import 'dart:ui'; // For ImageFilter
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/device_utils.dart';
import 'package:google_fonts/google_fonts.dart';

enum CursorType {
  defaultCursor,
  pointer, // For buttons
  text, // For text inputs or selection
  click, // For clickable items with "CLICK" text
}

class CursorController extends ValueNotifier<CursorType> {
  CursorController() : super(CursorType.defaultCursor);

  void setCursor(CursorType type) => value = type;
}

// Global instance
final cursorController = CursorController();

/// A wrapper widget to easily apply cursor states
class Clickable extends StatelessWidget {
  final Widget child;
  final CursorType cursorType;

  const Clickable({
    super.key,
    required this.child,
    this.cursorType = CursorType.click,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => cursorController.setCursor(cursorType),
      onExit: (_) => cursorController.setCursor(CursorType.defaultCursor),
      child: child,
    );
  }
}

class AdaptiveCursor extends StatefulWidget {
  final Widget child;

  const AdaptiveCursor({super.key, required this.child});

  @override
  State<AdaptiveCursor> createState() => _AdaptiveCursorState();
}

class _AdaptiveCursorState extends State<AdaptiveCursor> {
  final ValueNotifier<Offset> _mousePosNotifier = ValueNotifier(Offset.zero);

  @override
  void dispose() {
    _mousePosNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Mobile Check: Disable custom cursor on mobile/tablet
    // We use MediaQuery here only for the check, so it rebuilds on resize which is fine
    final width = MediaQuery.of(context).size.width;
    if (DeviceUtils.isMobile(width) || DeviceUtils.isTablet(width)) {
      return widget.child;
    }

    return MouseRegion(
      onHover: (details) {
        // 2. Performance: Update notifier instead of setState
        _mousePosNotifier.value = details.position;
      },
      cursor: SystemMouseCursors.none, // Hide system cursor
      child: Stack(
        children: [
          widget.child,

          // Custom Cursor Overlay
          // Optimization: Only rebuild cursor stack when position changes
          ValueListenableBuilder<Offset>(
            valueListenable: _mousePosNotifier,
            builder: (context, mousePos, _) {
              return ValueListenableBuilder<CursorType>(
                valueListenable: cursorController,
                builder: (context, type, _) {
                  final isClick = type == CursorType.click;

                  return AnimatedPositioned(
                    // 3. Performance: Faster duration for snappier feel
                    duration: isClick
                        ? const Duration(milliseconds: 200)
                        : Duration.zero,
                    curve: Curves.easeOutExpo,
                    left: mousePos.dx - _getSize(type) / 2,
                    top: mousePos.dy - _getSize(type) / 2,
                    child: IgnorePointer(
                      child: ExcludeSemantics(
                        child: _buildCursor(type, context),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCursor(CursorType type, BuildContext context) {
    // 4. "CLICK" Text Implementation
    if (type == CursorType.click) {
      final primary = Theme.of(context).colorScheme.primary;
      return ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            width: 80,
            height: 80,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // Subtle glass background: mostly transparent with a hint of primary light
              color: primary.withValues(alpha: 0.05),
              boxShadow: [
                // Soft outer glow
                BoxShadow(
                  color: primary.withValues(alpha: 0.2),
                  blurRadius: 30,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Material(
              type: MaterialType.transparency,
              child: Text(
                "CLICK",
                style: GoogleFonts.orbitron(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: primary,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ),
      )
          .animate()
          .scale(duration: 200.ms, curve: Curves.easeOutBack)
          .fadeIn(duration: 100.ms);
    }

    final isPointer = type == CursorType.pointer;
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
      case CursorType.click:
        return 80.0; // Larger for text
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
      case CursorType.click:
        return Colors
            .transparent; // Handled in _buildCursor with container decoration
      case CursorType.pointer:
        return primary.withValues(alpha: 0.15); // Subtle fill
      case CursorType.text:
        return primary.withValues(alpha: 0.1);
      case CursorType.defaultCursor:
        return primary;
    }
  }

  BoxBorder? _getBorder(CursorType type, BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    switch (type) {
      case CursorType.click:
        return null; // Handled in _buildCursor
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
      case CursorType.click:
        return null; // Handled in _buildCursor
      case CursorType.pointer:
        return [
          BoxShadow(
            color: primary.withValues(alpha: 0.4),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ];
      default:
        return null;
    }
  }
}
