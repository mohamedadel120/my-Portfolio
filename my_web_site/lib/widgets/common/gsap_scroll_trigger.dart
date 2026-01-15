import 'dart:html' as html;
import 'dart:js' as js;
import 'package:flutter/material.dart';

/// GSAP ScrollTrigger wrapper for Flutter Web
/// Provides GSAP-style scroll animations for Flutter widgets
class GSAPScrollTrigger extends StatefulWidget {
  final String triggerId;
  final double scrollOffset;
  final double sectionStartOffset;
  final double viewportHeight;
  final Widget child;
  final Map<String, dynamic>? animationConfig;
  final bool enabled;

  const GSAPScrollTrigger({
    super.key,
    required this.triggerId,
    required this.scrollOffset,
    required this.sectionStartOffset,
    required this.viewportHeight,
    required this.child,
    this.animationConfig,
    this.enabled = true,
  });

  @override
  State<GSAPScrollTrigger> createState() => _GSAPScrollTriggerState();
}

class _GSAPScrollTriggerState extends State<GSAPScrollTrigger> {
  html.DivElement? _markerElement;
  bool _isInitialized = false;
  static int _triggerCounter = 0;

  @override
  void initState() {
    super.initState();
    if (widget.enabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializeGSAP();
      });
    }
  }

  void _initializeGSAP() {
    if (_isInitialized) return;

    try {
      final uniqueId = 'gsap-trigger-${widget.triggerId}-${_triggerCounter++}';
      
      // Create marker element
      _markerElement = html.DivElement()
        ..id = uniqueId
        ..style.position = 'absolute'
        ..style.width = '1px'
        ..style.height = '1px'
        ..style.top = '${widget.sectionStartOffset}px'
        ..style.left = '0'
        ..style.visibility = 'hidden'
        ..style.pointerEvents = 'none'
        ..setAttribute('data-trigger-id', widget.triggerId);

      html.document.body!.append(_markerElement!);

      // Initialize GSAP ScrollTrigger
      final config = widget.animationConfig ?? {
        'opacity': {'from': 0, 'to': 1},
        'y': {'from': 50, 'to': 0},
        'scale': {'from': 0.8, 'to': 1.0},
      };

      js.context.callMethod('eval', [
        '''
        (function() {
          if (typeof gsap !== 'undefined' && typeof ScrollTrigger !== 'undefined') {
            var element = document.getElementById('$uniqueId');
            if (element) {
              gsap.fromTo(element, 
                { opacity: ${config['opacity']?['from'] ?? 0}, y: ${config['y']?['from'] ?? 50}, scale: ${config['scale']?['from'] ?? 0.8} },
                {
                  opacity: ${config['opacity']?['to'] ?? 1},
                  y: ${config['y']?['to'] ?? 0},
                  scale: ${config['scale']?['to'] ?? 1.0},
                  duration: ${config['duration'] ?? 1.0},
                  ease: '${config['ease'] ?? 'power2.out'}',
                  scrollTrigger: {
                    trigger: element,
                    start: 'top 80%',
                    end: 'top 20%',
                    toggleActions: 'play none none reverse',
                  }
                }
              );
            }
          }
        })();
        '''
      ]);

      _isInitialized = true;
    } catch (e) {
      print('GSAP ScrollTrigger error: $e');
    }
  }

  @override
  void dispose() {
    _markerElement?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Widget that applies GSAP-style animations based on scroll progress
class GSAPAnimatedWidget extends StatelessWidget {
  final double progress;
  final Widget child;
  final double? opacity;
  final Offset? translate;
  final double? scale;
  final double? rotation;

  const GSAPAnimatedWidget({
    super.key,
    required this.progress,
    required this.child,
    this.opacity,
    this.translate,
    this.scale,
    this.rotation,
  });

  @override
  Widget build(BuildContext context) {
    final animatedOpacity = opacity != null
        ? opacity! * progress
        : progress.clamp(0.0, 1.0);

    final animatedTranslate = translate != null
        ? Offset(
            translate!.dx * (1 - progress),
            translate!.dy * (1 - progress),
          )
        : Offset.zero;

    final animatedScale = scale != null
        ? 1.0 + (scale! - 1.0) * (1 - progress)
        : 0.8 + 0.2 * progress;

    final animatedRotation = rotation != null
        ? rotation! * (1 - progress)
        : 0.0;

    return Transform(
      transform: Matrix4.identity()
        ..translate(animatedTranslate.dx, animatedTranslate.dy)
        ..scale(animatedScale)
        ..rotateZ(animatedRotation),
      child: Opacity(
        opacity: animatedOpacity,
        child: child,
      ),
    );
  }
}
