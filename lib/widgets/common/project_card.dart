import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../features/projects/domain/entities/project_entity.dart';
import 'project_widgets/project_header.dart';
import 'project_widgets/project_gallery.dart';
import 'project_widgets/project_info.dart';
import 'project_widgets/project_action_button.dart';

class ProjectCard extends StatefulWidget {
  final Project project;
  final Duration delay;
  final bool isVisible;

  const ProjectCard({
    super.key,
    required this.project,
    required this.delay,
    required this.isVisible,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  Offset _pointerOffset = Offset.zero;
  late AnimationController _tiltController;
  late Animation<double> _tiltAnimation;

  @override
  void initState() {
    super.initState();
    _tiltController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _tiltAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _tiltController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _tiltController.dispose();
    super.dispose();
  }

  void _onHover(PointerHoverEvent event) {
    if (!_isHovered) {
      setState(() => _isHovered = true);
      _tiltController.forward();
    }

    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box != null) {
      final size = box.size;
      final center = size.center(Offset.zero);
      final localPosition = box.globalToLocal(event.position);
      final delta = localPosition - center;

      // Normalize delta (-1 to 1)
      final x = delta.dx / (size.width / 2);
      final y = delta.dy / (size.height / 2);

      setState(() {
        _pointerOffset = Offset(x, y);
      });
    }
  }

  void _onExit(PointerExitEvent event) {
    setState(() {
      _isHovered = false;
      _pointerOffset = Offset.zero;
    });
    _tiltController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: MouseRegion(
        onHover: _onHover,
        onExit: _onExit,
        child: AnimatedBuilder(
          animation: _tiltAnimation,
          builder: (context, child) {
            // Skew / Tilt transformation
            final tiltX =
                _pointerOffset.dy *
                -0.05 *
                _tiltAnimation.value; // RotateX based on Y axis
            final tiltY =
                _pointerOffset.dx *
                0.05 *
                _tiltAnimation.value; // RotateY based on X axis

            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // Perspective
                ..rotateX(tiltX)
                ..rotateY(tiltY)
                ..scale(_isHovered ? 1.02 : 1.0),
              alignment: Alignment.center,
              child: child,
            );
          },
          child: Builder(
            builder: (context) {
              final screenWidth = MediaQuery.of(context).size.width;
              final isMobile = screenWidth < 768;
              final isTablet = screenWidth >= 768 && screenWidth < 1024;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                padding: EdgeInsets.all(isMobile ? 20 : (isTablet ? 24 : 28)),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: widget.project.color.withValues(alpha: 
                      _isHovered ? 0.6 : 0.2,
                    ),
                    width: _isHovered ? 2 : 1.5,
                  ),
                  boxShadow: [
                    // Dynamic shadow acting as light source
                    BoxShadow(
                      color: widget.project.color.withValues(alpha: 
                        _isHovered ? 0.2 : 0.05,
                      ),
                      blurRadius: _isHovered ? 30 : 20,
                      spreadRadius: _isHovered ? 5 : 0,
                      offset: Offset(
                        -_pointerOffset.dx * 10,
                        -_pointerOffset.dy * 10,
                      ),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: _isHovered ? 0.3 : 0.1),
                      blurRadius: _isHovered ? 20 : 15,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ProjectHeader(
                      project: widget.project,
                      isVisible: widget.isVisible,
                      delay: widget.delay,
                    ),
                    const SizedBox(height: 12),
                    // Adding ignore pointer on gallery when not hovered to prevent accidental swipes?
                    // Or keep it interactive. Let's keep it interactive.
                    ProjectGallery(
                      project: widget.project,
                      isVisible: widget.isVisible,
                      delay: widget.delay,
                      isHovered: _isHovered,
                    ),
                    const SizedBox(height: 12),
                    ProjectInfo(project: widget.project),
                    ProjectActionButton(
                      project: widget.project,
                      isHovered: _isHovered,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
