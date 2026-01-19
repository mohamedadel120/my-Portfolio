import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MagneticButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double toxicity; // How strong the magnet is (0.0 to 1.0)

  const MagneticButton({
    super.key,
    required this.child,
    required this.onTap,
    this.toxicity = 0.3,
  });

  @override
  State<MagneticButton> createState() => _MagneticButtonState();
}

class _MagneticButtonState extends State<MagneticButton>
    with SingleTickerProviderStateMixin {
  Offset _offset = Offset.zero;
  late AnimationController _controller;
  // ignore: unused_field
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleHover(PointerHoverEvent event) {
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    final size = box.size;
    final center = size.center(Offset.zero);
    final localPosition = box.globalToLocal(event.position);

    final delta = localPosition - center;

    // Calculate movement based on toxicity
    final moveX = delta.dx * widget.toxicity;
    final moveY = delta.dy * widget.toxicity;

    setState(() {
      _offset = Offset(moveX, moveY);
    });
  }

  void _handleExit(PointerExitEvent event) {
    setState(() {
      _offset = Offset.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: _handleHover,
      onExit: _handleExit,
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedSlide(
          offset: Offset(
            _offset.dx / 100,
            _offset.dy / 100,
          ), // Normalize for Slide
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          child: Transform.translate(offset: _offset, child: widget.child),
        ),
      ),
    );
  }
}
