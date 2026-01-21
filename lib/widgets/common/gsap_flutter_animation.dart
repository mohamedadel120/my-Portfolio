// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:js' as js;
import 'package:flutter/material.dart';

/// GSAP-powered Flutter widget animation
/// Uses GSAP ScrollTrigger to detect scroll and applies animations to Flutter widgets
class GSAPFlutterAnimation extends StatefulWidget {
  final String elementId;
  final double scrollOffset;
  final double sectionStartOffset;
  final double viewportHeight;
  final Widget child;
  final Map<String, dynamic>? animationConfig;
  final bool enabled;

  const GSAPFlutterAnimation({
    super.key,
    required this.elementId,
    required this.scrollOffset,
    required this.sectionStartOffset,
    required this.viewportHeight,
    required this.child,
    this.animationConfig,
    this.enabled = true,
  });

  @override
  State<GSAPFlutterAnimation> createState() => _GSAPFlutterAnimationState();
}

class _GSAPFlutterAnimationState extends State<GSAPFlutterAnimation> {
  html.DivElement? _markerElement;
  bool _isInitialized = false;
  double _opacity = 1.0; // Always start visible
  double _translateX = 0.0;
  double _translateY = 0.0;
  double _scale = 1.0; // Start at normal scale
  static int _counter = 0;

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
      final uniqueId = 'gsap-flutter-${widget.elementId}-${_counter++}';

      // Create marker element for ScrollTrigger
      _markerElement = html.DivElement()
        ..id = uniqueId
        ..style.position = 'absolute'
        ..style.width = '1px'
        ..style.height = '1px'
        ..style.top = '${widget.sectionStartOffset}px'
        ..style.left = '0'
        ..style.visibility = 'hidden'
        ..style.pointerEvents = 'none';

      html.document.body!.append(_markerElement!);

      // Get animation config
      final config =
          widget.animationConfig ??
          {
            'opacity': {'from': 0, 'to': 1},
            'x': {'from': 0, 'to': 0},
            'y': {'from': 50, 'to': 0},
            'scale': {'from': 0.85, 'to': 1.0},
          };

      // Initialize GSAP ScrollTrigger animation
      final fromOpacity = config['opacity']?['from'] ?? 0;
      final toOpacity = config['opacity']?['to'] ?? 1;
      final fromX = config['x']?['from'] ?? 0;
      final toX = config['x']?['to'] ?? 0;
      final fromY = config['y']?['from'] ?? 50;
      final toY = config['y']?['to'] ?? 0;
      final fromScale = config['scale']?['from'] ?? 0.85;
      final toScale = config['scale']?['to'] ?? 1.0;

      // Always start visible - content should be visible by default
      // GSAP will enhance with animations if available

      // Wait for GSAP to be ready, then initialize animation
      Future.delayed(const Duration(milliseconds: 200), () {
        js.context.callMethod('eval', [
          '''
          (function() {
            if (typeof gsap !== 'undefined' && typeof ScrollTrigger !== 'undefined') {
              var marker = document.getElementById('$uniqueId');
              if (marker) {
                var currentScroll = window.scrollY || 0;
                var triggerPoint = ${widget.sectionStartOffset} * 0.8;
                
                // If already past trigger, keep visible, otherwise animate in
                if (currentScroll >= triggerPoint) {
                  // Already visible, just ensure final state
                  var event = new CustomEvent('gsap-flutter-update', {
                    detail: {
                      elementId: '${widget.elementId}',
                      opacity: $toOpacity,
                      x: $toX,
                      y: $toY,
                      scale: $toScale
                    }
                  });
                  window.dispatchEvent(event);
                } else {
                  // Before trigger - set initial hidden state, then animate
                  var initEvent = new CustomEvent('gsap-flutter-update', {
                    detail: {
                      elementId: '${widget.elementId}',
                      opacity: $fromOpacity,
                      x: $fromX,
                      y: $fromY,
                      scale: $fromScale
                    }
                  });
                  window.dispatchEvent(initEvent);
                  
                  // Then animate with GSAP
                  gsap.fromTo(marker, 
                    {
                      opacity: $fromOpacity,
                      x: $fromX,
                      y: $fromY,
                      scale: $fromScale
                    },
                    {
                      opacity: $toOpacity,
                      x: $toX,
                      y: $toY,
                      scale: $toScale,
                      duration: 1,
                      ease: 'power3.out',
                      scrollTrigger: {
                        trigger: marker,
                        start: 'top 80%',
                        end: 'top 20%',
                        scrub: 1,
                        onUpdate: function(self) {
                          var progress = self.progress;
                          var opacity = $fromOpacity + ($toOpacity - $fromOpacity) * progress;
                          var x = $fromX + ($toX - $fromX) * progress;
                          var y = $fromY + ($toY - $fromY) * progress;
                          var scale = $fromScale + ($toScale - $fromScale) * progress;
                          
                          var event = new CustomEvent('gsap-flutter-update', {
                            detail: {
                              elementId: '${widget.elementId}',
                              opacity: opacity,
                              x: x,
                              y: y,
                              scale: scale
                            }
                          });
                          window.dispatchEvent(event);
                        }
                      }
                    }
                  );
                }
              }
            }
            // If GSAP not available, content stays visible (default state)
          })();
          ''',
        ]);
      });

      // Listen for GSAP updates
      html.window.addEventListener('gsap-flutter-update', _handleGSAPUpdate);

      _isInitialized = true;
    } catch (e) {
      // print('GSAP Flutter Animation error: $e');
    }
  }

  void _handleGSAPUpdate(dynamic event) {
    if (!mounted) return; // Prevent updates after disposal

    try {
      if (event != null && event.detail != null) {
        final dynamic detail = event.detail;
        final dynamic elementId = detail['elementId'];

        if (elementId?.toString() == widget.elementId && mounted) {
          setState(() {
            final dynamic opacityValue = detail['opacity'];
            if (opacityValue != null) {
              _opacity = (opacityValue as num).toDouble();
            }

            final dynamic xValue = detail['x'];
            if (xValue != null) _translateX = (xValue as num).toDouble();

            final dynamic yValue = detail['y'];
            if (yValue != null) _translateY = (yValue as num).toDouble();

            final dynamic scaleValue = detail['scale'];
            if (scaleValue != null) _scale = (scaleValue as num).toDouble();
          });
        }
      }
    } catch (e) {
      // Ignore errors from malformed events
    }
  }

  @override
  void dispose() {
    html.window.removeEventListener('gsap-flutter-update', _handleGSAPUpdate);
    _markerElement?.remove();
    // Remove proxy element
    try {
      final proxyId = 'proxy-gsap-flutter-${widget.elementId}-${_counter - 1}';
      html.document.getElementById(proxyId)?.remove();
    } catch (e) {
      // Ignore
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..translate(_translateX, _translateY)
        ..scale(_scale),
      child: Opacity(opacity: _opacity.clamp(0.0, 1.0), child: widget.child),
    );
  }
}
