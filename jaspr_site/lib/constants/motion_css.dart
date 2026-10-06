import 'package:jaspr/dom.dart';

/// `@media (prefers-reduced-motion: ...)` wrapper. Jaspr's typed MediaQuery
/// has no reduced-motion option, so this renders the at-rule itself.
class MotionRule implements StyleRule {
  final bool reduce;
  final List<StyleRule> styles;

  const MotionRule._(this.reduce, this.styles);

  /// Rules that only apply when the visitor has NOT asked for reduced motion.
  const MotionRule.allowed(List<StyleRule> styles) : this._(false, styles);

  /// Rules that apply when the visitor asked for reduced motion.
  const MotionRule.reduced(List<StyleRule> styles) : this._(true, styles);

  @override
  String toCss([String indent = '']) {
    final query = reduce ? 'reduce' : 'no-preference';
    final inner = styles.map((r) => r.toCss('$indent  ')).join('\n');
    return '$indent@media (prefers-reduced-motion: $query) {\n$inner\n$indent}';
  }
}
