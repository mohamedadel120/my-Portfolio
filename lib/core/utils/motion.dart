import 'package:flutter/widgets.dart';

/// Loops a decorative animation unless the user asked the OS for reduced
/// motion. In that case the controller is left alone and the animation plays
/// through once (flutter_animate's autoplay), instead of repeating forever.
void loopAnimation(
  BuildContext context,
  AnimationController controller, {
  bool reverse = false,
}) {
  if (MediaQuery.disableAnimationsOf(context)) return;
  controller.repeat(reverse: reverse);
}
