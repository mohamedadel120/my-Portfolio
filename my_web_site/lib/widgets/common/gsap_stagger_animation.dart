import 'dart:html' as html;
import 'dart:js' as js;
import 'package:flutter/material.dart';

/// GSAP Stagger Animation for multiple elements
/// Based on: https://tympanus.net/codrops/2025/09/03/7-must-know-gsap-animation-tips-for-creative-developers/
class GSAPStaggerAnimation extends StatefulWidget {
  final String groupId;
  final double scrollOffset;
  final double sectionStartOffset;
  final double viewportHeight;
  final List<Widget> children;
  final Map<String, dynamic>? animationConfig;
  final String staggerFrom; // "start", "center", "end", "edges", "random"
  final double staggerDelay;
  final bool enabled;

  const GSAPStaggerAnimation({
    super.key,
    required this.groupId,
    required this.scrollOffset,
    required this.sectionStartOffset,
    required this.viewportHeight,
    required this.children,
    this.animationConfig,
    this.staggerFrom = 'start',
    this.staggerDelay = 0.1,
    this.enabled = true,
  });

  @override
  State<GSAPStaggerAnimation> createState() => _GSAPStaggerAnimationState();
}

class _GSAPStaggerAnimationState extends State<GSAPStaggerAnimation> {
  bool _isInitialized = false;
  static int _groupCounter = 0;

  @override
  void initState() {
    super.initState();
    if (widget.enabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializeGSAPStagger();
      });
    }
  }

  void _initializeGSAPStagger() {
    if (_isInitialized) return;

    try {
      final groupId = 'gsap-stagger-${widget.groupId}-${_groupCounter++}';

      // Create marker element
      final marker = html.DivElement()
        ..id = groupId
        ..style.position = 'absolute'
        ..style.width = '1px'
        ..style.height = '1px'
        ..style.top = '${widget.sectionStartOffset}px'
        ..style.left = '0'
        ..style.visibility = 'hidden'
        ..style.pointerEvents = 'none';

      html.document.body!.append(marker);

      // Get animation config
      final config =
          widget.animationConfig ??
          {
            'opacity': {'from': 0, 'to': 1},
            'y': {'from': 50, 'to': 0},
            'scale': {'from': 0.85, 'to': 1.0},
          };

      final fromOpacity = config['opacity']?['from'] ?? 0;
      final toOpacity = config['opacity']?['to'] ?? 1;
      final fromY = config['y']?['from'] ?? 50;
      final toY = config['y']?['to'] ?? 0;
      final fromScale = config['scale']?['from'] ?? 0.85;
      final toScale = config['scale']?['to'] ?? 1.0;

      // Initialize GSAP stagger animation with article tips
      Future.delayed(const Duration(milliseconds: 200), () {
        js.context.callMethod('eval', [
          '''
          (function() {
            if (typeof gsap !== 'undefined' && typeof ScrollTrigger !== 'undefined') {
              var marker = document.getElementById('$groupId');
              if (marker) {
                // Find all child elements with data-stagger attribute
                var children = document.querySelectorAll('[data-stagger-group="$groupId"]');
                
                if (children.length > 0) {
                  // Tip 2: Using stagger object with 'from' property for direction control
                  // Tip 1: Better easing with power3.out
                  gsap.fromTo(children, 
                    {
                      opacity: $fromOpacity,
                      y: $fromY,
                      scale: $fromScale
                    },
                    {
                      opacity: $toOpacity,
                      y: $toY,
                      scale: $toScale,
                      duration: 1.2,
                      ease: 'power3.out',
                      stagger: {
                        each: ${widget.staggerDelay},
                        from: '${widget.staggerFrom}' // "start", "center", "end", "edges", "random"
                      },
                      scrollTrigger: {
                        trigger: marker,
                        start: 'top 75%',
                        end: 'top 25%',
                        scrub: 1,
                        onEnter: function() {
                          // Ensure elements are visible when entering viewport
                        }
                      }
                    }
                  );
                }
              }
            }
          })();
          ''',
        ]);
      });

      _isInitialized = true;
    } catch (e) {
      print('GSAP Stagger Animation error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: widget.children);
  }
}

/// Enhanced GSAP animation with stagger support and better easing
class GSAPEnhancedAnimation extends StatefulWidget {
  final String elementId;
  final double scrollOffset;
  final double sectionStartOffset;
  final double viewportHeight;
  final Widget child;
  final Map<String, dynamic>? animationConfig;
  final String?
  ease; // "power1.out", "power2.out", "power3.out", "elastic.out", etc.
  final bool useRandom; // Use random values for more dynamic animations
  final bool enabled;

  const GSAPEnhancedAnimation({
    super.key,
    required this.elementId,
    required this.scrollOffset,
    required this.sectionStartOffset,
    required this.viewportHeight,
    required this.child,
    this.animationConfig,
    this.ease,
    this.useRandom = false,
    this.enabled = true,
  });

  @override
  State<GSAPEnhancedAnimation> createState() => _GSAPEnhancedAnimationState();
}

class _GSAPEnhancedAnimationState extends State<GSAPEnhancedAnimation> {
  html.DivElement? _markerElement;
  bool _isInitialized = false;
  bool _gsapReady = false;
  double _opacity = 1.0; // Always start visible
  double _translateX = 0.0;
  double _translateY = 0.0;
  double _scale = 1.0;
  double _rotation = 0.0;
  static int _counter = 0;

  @override
  void initState() {
    super.initState();
    // Ensure content is visible by default
    _opacity = 1.0;
    _translateX = 0.0;
    _translateY = 0.0;
    _scale = 1.0;
    _rotation = 0.0;

    if (widget.enabled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializeGSAP();
        // Fallback: If GSAP doesn't initialize within 2 seconds, ensure visibility
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted && !_gsapReady && _opacity < 0.5) {
            setState(() {
              _opacity = 1.0;
              _translateX = 0.0;
              _translateY = 0.0;
              _scale = 1.0;
              _rotation = 0.0;
            });
          }
        });
      });
    }
  }

  void _initializeGSAP() {
    if (_isInitialized) return;

    try {
      final uniqueId = 'gsap-enhanced-${widget.elementId}-${_counter++}';

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

      final config =
          widget.animationConfig ??
          {
            'opacity': {'from': 0, 'to': 1},
            'x': {'from': 0, 'to': 0},
            'y': {'from': 50, 'to': 0},
            'scale': {'from': 0.85, 'to': 1.0},
            'rotation': {'from': 0, 'to': 0},
          };

      final fromOpacity = config['opacity']?['from'] ?? 0;
      final toOpacity = config['opacity']?['to'] ?? 1;
      final fromX = config['x']?['from'] ?? 0;
      final toX = config['x']?['to'] ?? 0;
      final fromY = config['y']?['from'] ?? 50;
      final toY = config['y']?['to'] ?? 0;
      final fromScale = config['scale']?['from'] ?? 0.85;
      final toScale = config['scale']?['to'] ?? 1.0;
      final fromRotation = config['rotation']?['from'] ?? 0;
      final toRotation = config['rotation']?['to'] ?? 0;

      final ease = widget.ease ?? 'power3.out';

      // Ensure content is visible by default - GSAP will enhance it
      // Only hide if GSAP is loaded and we're before the trigger
      Future.delayed(const Duration(milliseconds: 300), () {
        js.context.callMethod('eval', [
          '''
          (function() {
            // Check if GSAP is available
            if (typeof gsap === 'undefined' || typeof ScrollTrigger === 'undefined') {
              // GSAP not available - keep content visible (default state)
              // Dispatch event to mark GSAP as not ready
              var event = new CustomEvent('gsap-enhanced-update', {
                detail: {
                  elementId: '${widget.elementId}',
                  opacity: 1.0,
                  x: 0,
                  y: 0,
                  scale: 1.0,
                  rotation: 0,
                  gsapReady: false
                }
              });
              window.dispatchEvent(event);
              return;
            }
            
            var marker = document.getElementById('$uniqueId');
            if (!marker) return;
            
            var currentScroll = window.scrollY || 0;
            var triggerPoint = ${widget.sectionStartOffset} * 0.7;
            
            // Apply tips from GSAP article:
            // 1. Use gsap.utils.wrap() for alternating values (if needed)
            // 2. Use random() string syntax for dynamic animations
            // 3. Better easing with power3.out
            
            var finalX = $toX;
            var finalY = $toY;
            var finalScale = $toScale;
            var finalRotation = $toRotation;
            
            ${widget.useRandom ? '''
            // Tip 4: Use gsap.utils.random() for randomization
            finalX = gsap.utils.random($toX - 20, $toX + 20);
            finalY = gsap.utils.random($toY - 10, $toY + 10);
            finalScale = gsap.utils.random(0.95, 1.05);
            finalRotation = gsap.utils.random($toRotation - 2, $toRotation + 2);
            ''' : ''}
            
            // Mark GSAP as ready
            var readyEvent = new CustomEvent('gsap-enhanced-update', {
              detail: {
                elementId: '${widget.elementId}',
                gsapReady: true
              }
            });
            window.dispatchEvent(readyEvent);
            
            // If already past trigger, ensure visible state
            if (currentScroll >= triggerPoint) {
              var event = new CustomEvent('gsap-enhanced-update', {
                detail: {
                  elementId: '${widget.elementId}',
                  opacity: $toOpacity,
                  x: finalX,
                  y: finalY,
                  scale: finalScale,
                  rotation: finalRotation,
                  gsapReady: true
                }
              });
              window.dispatchEvent(event);
            } else {
              // Before trigger - set initial hidden state for animation
              var initEvent = new CustomEvent('gsap-enhanced-update', {
                detail: {
                  elementId: '${widget.elementId}',
                  opacity: $fromOpacity,
                  x: $fromX,
                  y: $fromY,
                  scale: $fromScale,
                  rotation: $fromRotation
                }
              });
              window.dispatchEvent(initEvent);
              
              // Create GSAP animation with ScrollTrigger
              var animation = gsap.fromTo(marker, 
                {
                  opacity: $fromOpacity,
                  x: $fromX,
                  y: $fromY,
                  scale: $fromScale,
                  rotation: $fromRotation
                },
                {
                  opacity: $toOpacity,
                  x: finalX,
                  y: finalY,
                  scale: finalScale,
                  rotation: finalRotation,
                  duration: 1.2,
                  ease: '$ease',
                  scrollTrigger: {
                    trigger: marker,
                    start: 'top 75%',
                    end: 'top 25%',
                    scrub: 1,
                    onUpdate: function(self) {
                      var progress = self.progress;
                      var opacity = $fromOpacity + ($toOpacity - $fromOpacity) * progress;
                      var x = $fromX + (finalX - $fromX) * progress;
                      var y = $fromY + (finalY - $fromY) * progress;
                      var scale = $fromScale + (finalScale - $fromScale) * progress;
                      var rotation = $fromRotation + (finalRotation - $fromRotation) * progress;
                      
                      var event = new CustomEvent('gsap-enhanced-update', {
                        detail: {
                          elementId: '${widget.elementId}',
                          opacity: opacity,
                          x: x,
                          y: y,
                          scale: scale,
                          rotation: rotation
                        }
                      });
                      window.dispatchEvent(event);
                    },
                    onEnter: function() {
                      // Ensure visible when entering viewport
                      var event = new CustomEvent('gsap-enhanced-update', {
                        detail: {
                          elementId: '${widget.elementId}',
                          opacity: $toOpacity,
                          x: finalX,
                          y: finalY,
                          scale: finalScale,
                          rotation: finalRotation
                        }
                      });
                      window.dispatchEvent(event);
                    }
                  }
                }
              );
            }
          })();
          ''',
        ]);
      });

      html.window.addEventListener('gsap-enhanced-update', _handleGSAPUpdate);
      _isInitialized = true;
    } catch (e) {
      print('GSAP Enhanced Animation error: $e');
      // On error, ensure content is visible
      if (mounted) {
        setState(() {
          _opacity = 1.0;
          _translateX = 0.0;
          _translateY = 0.0;
          _scale = 1.0;
          _rotation = 0.0;
        });
      }
    }
  }

  void _handleGSAPUpdate(dynamic event) {
    if (!mounted) return;

    try {
      if (event != null && event.detail != null) {
        final dynamic detail = event.detail;
        final dynamic elementId = detail['elementId'];

        if (elementId?.toString() == widget.elementId && mounted) {
          // Check if GSAP is ready
          final dynamic gsapReadyValue = detail['gsapReady'];
          if (gsapReadyValue != null) {
            _gsapReady = gsapReadyValue == true;
          }

          setState(() {
            // Only update if we have valid values, otherwise keep visible
            final dynamic opacityValue = detail['opacity'];
            if (opacityValue != null) {
              _opacity = (opacityValue as num).toDouble();
            } else if (!_gsapReady) {
              _opacity = 1.0;
            }

            final dynamic xValue = detail['x'];
            if (xValue != null) _translateX = (xValue as num).toDouble();

            final dynamic yValue = detail['y'];
            if (yValue != null) _translateY = (yValue as num).toDouble();

            final dynamic scaleValue = detail['scale'];
            if (scaleValue != null) {
              _scale = (scaleValue as num).toDouble();
            } else if (!_gsapReady) {
              _scale = 1.0;
            }

            final dynamic rotationValue = detail['rotation'];
            if (rotationValue != null)
              _rotation = (rotationValue as num).toDouble();
          });
        }
      }
    } catch (e) {
      // Ignore errors from malformed events
    }
  }

  @override
  void dispose() {
    html.window.removeEventListener('gsap-enhanced-update', _handleGSAPUpdate);
    _markerElement?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..translate(_translateX, _translateY)
        ..scale(_scale)
        ..rotateZ(_rotation),
      child: Opacity(opacity: _opacity.clamp(0.0, 1.0), child: widget.child),
    );
  }
}
