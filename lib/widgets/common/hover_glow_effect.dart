import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class HoverGlowEffect extends StatefulWidget {
  final Widget child;
  final Color glowColor;

  const HoverGlowEffect({
    super.key,
    required this.child,
    this.glowColor = AppColors.primary,
  });

  @override
  State<HoverGlowEffect> createState() => _HoverGlowEffectState();
}

class _HoverGlowEffectState extends State<HoverGlowEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _glowAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        _controller.forward();
      },
      onExit: (_) {
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: widget.glowColor.withValues(alpha: 0.3 * _glowAnimation.value),
                  blurRadius: 20 * _glowAnimation.value,
                  spreadRadius: 5 * _glowAnimation.value,
                ),
              ],
            ),
            child: widget.child,
          );
        },
      ),
    );
  }
}

