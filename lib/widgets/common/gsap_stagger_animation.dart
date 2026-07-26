// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter
import 'html_stub.dart' if (dart.library.html) 'dart:html' as html;
import 'js_stub.dart' if (dart.library.js) 'dart:js' as js;
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
      // print('GSAP Stagger Animation error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: widget.children);
  }
}

/// Renders [child] directly, at full opacity with no transform.
///
/// This used to drive a GSAP ScrollTrigger reveal via `js.context.eval`, but
/// GSAP is never loaded anywhere in this app (no script tag, no dynamic
/// injection), so `typeof gsap === 'undefined'` was always true and every
/// one of the ~25 call sites across the contact/experience/expertise/projects
/// pages always fell back to this exact visible state anyway — just after
/// creating a DOM marker element and firing an `eval()` call to get there.
/// Kept as a passthrough (instead of touching every call site) so this can
/// be swapped for a real Flutter-native reveal animation later.
class GSAPEnhancedAnimation extends StatelessWidget {
  final String elementId;
  final double scrollOffset;
  final double sectionStartOffset;
  final double viewportHeight;
  final Widget child;
  final Map<String, dynamic>? animationConfig;
  final String? ease;
  final bool useRandom;
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
  Widget build(BuildContext context) => child;
}
