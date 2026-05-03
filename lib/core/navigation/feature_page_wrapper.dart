import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../widgets/common/scroll_indicator.dart';

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
    _scrollNotifier = ValueNotifier<double>(widget.virtualOffset);

    _controller.addListener(_onScroll);
  }

  void _onScroll() {
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
              color: Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _controller,
            physics: const ClampingScrollPhysics(),
            child: widget.builder(context, _scrollNotifier),
          ),

          // Scroll Indicator (aligned to the right)
          Positioned(
            bottom: 40,
            right: 20,
            child: ValueListenableBuilder<double>(
              valueListenable: _scrollNotifier,
              builder: (context, totalOffset, _) {
                // We want the indicator to hide only when near the bottom
                final localOffset = totalOffset - widget.virtualOffset;

                double opacity = 1.0;
                if (_controller.hasClients &&
                    _controller.position.hasContentDimensions) {
                  final max = _controller.position.maxScrollExtent;
                  if (max > 0) {
                    // Start fading out in the last 100 pixels
                    opacity = ((max - localOffset) / 100.0).clamp(0.0, 1.0);
                  } else {
                    // Page is not scrollable (content fits in one screen)
                    opacity = 0.0;
                  }
                }

                return Center(
                  child: ScrollIndicator(opacity: opacity),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
