import 'package:jaspr/jaspr.dart';

import 'scroll_reveal.vm.dart' if (dart.library.js_interop) 'scroll_reveal.web.dart';

/// Renders nothing — mounted once at the root purely to run
/// [observeReveals] client-side after hydration.
@client
class ScrollReveal extends StatefulComponent {
  const ScrollReveal({super.key});

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal> {
  @override
  void initState() {
    super.initState();
    observeReveals();
  }

  @override
  Component build(BuildContext context) => const Component.empty();
}
