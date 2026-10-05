import 'package:jaspr/jaspr.dart';

import 'visit_tracker.vm.dart' if (dart.library.js_interop) 'visit_tracker.web.dart';

/// Renders nothing — mounted once at the root purely to run
/// [trackVisit] client-side after hydration, so the visit is logged from the
/// visitor's browser and never during the static pre-render.
@client
class VisitTracker extends StatefulComponent {
  const VisitTracker({super.key});

  @override
  State<VisitTracker> createState() => _VisitTrackerState();
}

class _VisitTrackerState extends State<VisitTracker> {
  @override
  void initState() {
    super.initState();
    trackVisit();
  }

  @override
  Component build(BuildContext context) => const Component.empty();
}
