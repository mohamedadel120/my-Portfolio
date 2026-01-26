import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class CursorFollower extends StatefulWidget {
  final Widget child;

  const CursorFollower({super.key, required this.child});

  @override
  State<CursorFollower> createState() => _CursorFollowerState();
}

class _CursorFollowerState extends State<CursorFollower> {
  Offset _mousePosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        setState(() {
          _mousePosition = event.localPosition;
        });
      },
      child: Stack(
        children: [
          widget.child,
          // Custom cursor effect
          Positioned(
            left: _mousePosition.dx - 15,
            top: _mousePosition.dy - 15,
            child: IgnorePointer(
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.5),
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

