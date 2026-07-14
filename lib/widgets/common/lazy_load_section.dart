import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Defers building [builder] until the section scrolls near the viewport,
/// showing a lightweight empty placeholder until then.
///
/// Data fetches for section content already fire immediately at startup
/// (see main.dart), so by the time a section actually gets built, its data
/// has usually already arrived. This just avoids paying the (much more
/// expensive) cost of laying out and animating every section on the page
/// immediately, when most of them are off-screen at first paint.
class LazyLoadSection extends StatefulWidget {
  const LazyLoadSection({super.key, required this.builder, this.placeholderHeight});

  final WidgetBuilder builder;
  final double? placeholderHeight;

  @override
  State<LazyLoadSection> createState() => _LazyLoadSectionState();
}

class _LazyLoadSectionState extends State<LazyLoadSection> {
  final _visibilityKey = UniqueKey();
  bool _shouldBuild = false;

  @override
  Widget build(BuildContext context) {
    if (_shouldBuild) return widget.builder(context);

    return VisibilityDetector(
      key: _visibilityKey,
      onVisibilityChanged: (info) {
        if (!_shouldBuild && info.visibleFraction > 0 && mounted) {
          setState(() => _shouldBuild = true);
        }
      },
      child: SizedBox(
        height: widget.placeholderHeight ?? MediaQuery.of(context).size.height,
      ),
    );
  }
}
