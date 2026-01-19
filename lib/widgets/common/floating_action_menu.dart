import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_data.dart';

class FloatingActionMenu extends StatefulWidget {
  const FloatingActionMenu({super.key});

  @override
  State<FloatingActionMenu> createState() => _FloatingActionMenuState();
}

class _FloatingActionMenuState extends State<FloatingActionMenu>
    with TickerProviderStateMixin {
  bool _isExpanded = false;
  bool _isHovered = false;
  late AnimationController _controller;
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.125,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Social media buttons
        if (_isExpanded) ...[
          _buildSocialButton(
            icon: Icons.email,
            label: 'Email',
            color: AppColors.primary,
            onTap: () async {
              final Uri emailUri = Uri(scheme: 'mailto', path: AppData.email);
              if (await canLaunchUrl(emailUri)) {
                await launchUrl(emailUri);
              }
            },
            offset: 80,
            delay: 0,
          ),
          _buildSocialButton(
            icon: Icons.code,
            label: 'GitHub',
            color: AppColors.secondary,
            onTap: () async {
              final Uri githubUri = Uri.parse(
                'https://github.com/mohamedadel120',
              );
              if (await canLaunchUrl(githubUri)) {
                await launchUrl(githubUri);
              }
            },
            offset: 160,
            delay: 50,
          ),
          _buildSocialButton(
            icon: Icons.link,
            label: 'LinkedIn',
            color: AppColors.primary,
            onTap: () async {
              final Uri linkedInUri = Uri.parse(
                'https://www.linkedin.com/in/mohamed-adel-9454a1183/',
              );
              if (await canLaunchUrl(linkedInUri)) {
                await launchUrl(linkedInUri);
              }
            },
            offset: 240,
            delay: 100,
          ),
        ],
        // Main FAB
        MouseRegion(
          onEnter: (_) {
            setState(() {
              _isHovered = true;
              _hoverController.repeat();
            });
          },
          onExit: (_) {
            setState(() {
              _isHovered = false;
              _hoverController.stop();
              _hoverController.reset();
            });
          },
          child: AnimatedBuilder(
            animation: _isHovered ? _hoverController : _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _isHovered
                    ? _hoverController.value * 2 * 3.14159
                    : _rotationAnimation.value * 2 * 3.14159,
                child: FloatingActionButton(
                  onPressed: _toggleMenu,
                  backgroundColor: AppColors.primary,
                  child: Icon(
                    _isExpanded ? Icons.close : Icons.add,
                    color: AppColors.background,
                  ),
                ),
              );
           
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    required double offset,
    required int delay,
  }) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 300 + delay),
      curve: Curves.easeOut,
      bottom: _isExpanded ? offset : 0,
      right: 16,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: FloatingActionButton(
            heroTag: label,
            mini: true,
            onPressed: () {
              onTap();
              _toggleMenu();
            },
            backgroundColor: color,
            child: Icon(icon, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
