import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A wrapper that provides a virtual scroll environment for sections that expect
/// to be part of a larger scroll view.
///
/// Many sections (Projects, Experience, etc.) count on [sectionStartOffset]
/// to trigger animations. If we place them on a standalone page starting at 0,
/// animations with high offsets won't trigger.
///
/// This wrapper maintains a local [ScrollController] but exposes a
/// [ValueNotifier<double>] that emits (localOffset + virtualOffset).
class FeaturePageWrapper extends StatefulWidget {
  final Widget Function(
          BuildContext context, ValueListenable<double> scrollOffsetListenable)
      builder;
  final double virtualOffset;
  final String title;

  const FeaturePageWrapper({
    super.key,
    required this.builder,
    required this.virtualOffset,
    required this.title,
  });

  @override
  State<FeaturePageWrapper> createState() => _FeaturePageWrapperState();
}

class _FeaturePageWrapperState extends State<FeaturePageWrapper> {
  late ScrollController _controller;
  late ValueNotifier<double> _scrollNotifier;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    // Initialize notification with the virtual offset so animations trigger immediately if needed
    // Actually, usually they trigger when current >= trigger.
    // If virtualOffset is 4000 (Projects), and real is 0.
    // Total = 4000.
    // Projects animation triggers at 4000 * 0.8 = 3200.
    // 4000 >= 3200 -> Visible. Perfect.
    _scrollNotifier = ValueNotifier<double>(widget.virtualOffset);

    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    // We add the virtual offset to the real scroll offset
    // This tricks the child widgets into thinking they are far down the page
    _scrollNotifier.value = _controller.offset + widget.virtualOffset;
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    _scrollNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        controller: _controller,
        physics: const ClampingScrollPhysics(), // Match the main site physics
        child: widget.builder(context, _scrollNotifier),
      ),
    );
  }
}
