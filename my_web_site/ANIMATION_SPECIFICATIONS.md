# Animation Specifications: Detailed Timing & Easing

## 🎬 **Complete Animation Reference Guide**

---

## **Timing Functions (Easing Curves)**

### **Standard Easing Functions**

```dart
// Ease Out (Most Common)
cubic-bezier(0.16, 1, 0.3, 1)
// Smooth deceleration, natural feel

// Ease In
cubic-bezier(0.7, 0, 0.84, 0)
// Slow start, fast end

// Ease In Out
cubic-bezier(0.76, 0, 0.24, 1)
// Smooth both ways

// Custom Smooth
cubic-bezier(0.25, 0.46, 0.45, 0.94)
// Very smooth, premium feel

// Bounce (Rare)
cubic-bezier(0.68, -0.55, 0.265, 1.55)
// Playful bounce effect
```

### **Flutter Equivalent**

```dart
Curves.easeOutCubic      // Standard ease out
Curves.easeInOutCubic    // Smooth both ways
Curves.easeOut           // Natural deceleration
Curves.easeIn            // Slow start
Curves.fastOutSlowIn     // Fast start, slow end
```

---

## **Duration Scale**

### **Micro-Interactions (100-200ms)**
```
Button Press: 150ms
Hover State: 200ms
Focus State: 150ms
Tooltip: 200ms
```

### **Standard Animations (300-600ms)**
```
Fade In: 400ms
Slide Up: 500ms
Scale: 400ms
Color Transition: 300ms
```

### **Page Transitions (600-1000ms)**
```
Section Reveal: 800ms
Page Load: 1000ms
Modal Open: 600ms
Complex Animation: 1000ms
```

### **Long Animations (1000ms+)**
```
Scroll Animation: 1200ms
Stagger Sequence: 1500ms
Complex Reveal: 2000ms
```

---

## **Scroll Animation Triggers**

### **Trigger Points**

```dart
// Early Trigger (Before Visible)
triggerPoint = sectionStartOffset - viewportHeight * 0.5
// Animation starts when section is 50% before viewport

// Standard Trigger (At Visible)
triggerPoint = sectionStartOffset - viewportHeight * 0.2
// Animation starts when section is 20% before viewport

// Late Trigger (After Visible)
triggerPoint = sectionStartOffset
// Animation starts when section enters viewport
```

### **Stagger Delays**

```dart
// Fast Stagger (Tight)
delay = index * 50ms
// Items animate quickly one after another

// Standard Stagger (Medium)
delay = index * 100ms
// Natural flow, not too fast or slow

// Slow Stagger (Spaced)
delay = index * 200ms
// More dramatic, each item waits longer
```

---

## **Animation Combinations**

### **Fade + Slide (Most Common)**

```dart
.animate()
.fadeIn(delay: 0.ms, duration: 600.ms)
.slideY(begin: 0.3, end: 0, delay: 0.ms, duration: 600.ms)
```

**Specifications:**
- Opacity: 0 → 1
- Y Position: 30px → 0
- Duration: 600ms
- Easing: ease-out

### **Fade + Scale**

```dart
.animate()
.fadeIn(delay: 0.ms, duration: 600.ms)
.scale(begin: Offset(0.9, 0.9), end: Offset(1.0, 1.0), 
       delay: 0.ms, duration: 600.ms)
```

**Specifications:**
- Opacity: 0 → 1
- Scale: 0.9 → 1.0
- Duration: 600ms
- Easing: ease-out

### **Fade + Slide + Scale (Premium)**

```dart
.animate()
.fadeIn(delay: 0.ms, duration: 800.ms)
.slideY(begin: 0.2, end: 0, delay: 0.ms, duration: 800.ms)
.scale(begin: Offset(0.95, 0.95), end: Offset(1.0, 1.0),
       delay: 0.ms, duration: 800.ms)
```

**Specifications:**
- Opacity: 0 → 1
- Y Position: 20px → 0
- Scale: 0.95 → 1.0
- Duration: 800ms
- Easing: ease-out

---

## **Hover Animations**

### **Card Hover**

```dart
AnimatedContainer(
  duration: Duration(milliseconds: 300),
  transform: Matrix4.identity()..scale(isHovered ? 1.02 : 1.0),
  decoration: BoxDecoration(
    boxShadow: [
      BoxShadow(
        blurRadius: isHovered ? 30 : 15,
        spreadRadius: isHovered ? 2 : 0,
      ),
    ],
  ),
)
```

**Specifications:**
- Scale: 1.0 → 1.02
- Shadow Blur: 15px → 30px
- Duration: 300ms
- Easing: ease-out

### **Button Hover**

```dart
AnimatedContainer(
  duration: Duration(milliseconds: 200),
  transform: Matrix4.identity()..scale(isHovered ? 1.05 : 1.0),
  decoration: BoxDecoration(
    color: isHovered ? brighten(color) : color,
  ),
)
```

**Specifications:**
- Scale: 1.0 → 1.05
- Brightness: +10%
- Duration: 200ms
- Easing: ease-out

---

## **Parallax Specifications**

### **Layer Speeds**

```dart
Background Layer: 0.2
// Moves 20% of scroll distance
// Creates depth, stays mostly static

Midground Layer: 0.5
// Moves 50% of scroll distance
// Natural parallax effect

Foreground Layer: 0.8
// Moves 80% of scroll distance
// Stays closer to viewport

Reverse Layer: -0.3
// Moves opposite direction
// Creates interesting effect
```

### **Implementation**

```dart
class ParallaxLayer extends StatelessWidget {
  final double scrollOffset;
  final double speed;
  final Widget child;
  
  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, scrollOffset * speed),
      child: child,
    );
  }
}
```

---

## **Scroll Progress Animations**

### **Progress Bar**

```dart
class ScrollProgress extends StatelessWidget {
  final double scrollOffset;
  final double maxScroll;
  
  @override
  Widget build(BuildContext context) {
    final progress = (scrollOffset / maxScroll).clamp(0.0, 1.0);
    
    return Container(
      height: 3,
      child: FractionallySizedBox(
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [primary, secondary]),
          ),
        ),
      ),
    );
  }
}
```

---

## **Split Text Animation**

### **Word-by-Word**

```dart
class SplitTextAnimation extends StatelessWidget {
  final String text;
  final Duration staggerDelay;
  
  @override
  Widget build(BuildContext context) {
    final words = text.split(' ');
    
    return Wrap(
      children: words.asMap().entries.map((entry) {
        final index = entry.key;
        final word = entry.value;
        
        return Text('$word ')
          .animate()
          .fadeIn(
            delay: (index * staggerDelay.inMilliseconds).ms,
            duration: 400.ms,
          )
          .slideY(
            begin: 0.3,
            end: 0,
            delay: (index * staggerDelay.inMilliseconds).ms,
            duration: 400.ms,
          );
      }).toList(),
    );
  }
}
```

**Specifications:**
- Stagger: 100-150ms per word
- Fade: 0 → 1 over 400ms
- Slide: 30px → 0 over 400ms
- Easing: ease-out

---

## **Loading Animations**

### **Skeleton Loader**

```dart
class SkeletonLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey[800]!,
            Colors.grey[700]!,
            Colors.grey[800]!,
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
    )
      .animate(onPlay: (controller) => controller.repeat())
      .shimmer(duration: 1500.ms);
  }
}
```

---

## **Modal Animations**

### **Modal Open/Close**

```dart
// Open Animation
.animate()
.fadeIn(duration: 300.ms)
.scale(begin: Offset(0.8, 0.8), end: Offset(1.0, 1.0), duration: 300.ms)

// Close Animation
.animate()
.fadeOut(duration: 200.ms)
.scale(begin: Offset(1.0, 1.0), end: Offset(0.8, 0.8), duration: 200.ms)
```

**Specifications:**
- Open: 300ms, scale 0.8 → 1.0
- Close: 200ms, scale 1.0 → 0.8
- Backdrop: Fade in/out simultaneously

---

## **Performance Optimization**

### **GPU Acceleration**

```dart
// ✅ Good (GPU Accelerated)
Transform.translate()
Transform.scale()
Transform.rotate()
Opacity()

// ❌ Bad (Causes Reflow)
Width/Height changes
Top/Left changes
Margin/Padding changes
```

### **WillChange Hints**

```dart
// Hint browser about upcoming animations
AnimatedBuilder(
  builder: (context, child) {
    return RepaintBoundary(
      child: Transform.scale(
        scale: animation.value,
        child: child,
      ),
    );
  },
)
```

---

## **Accessibility Considerations**

### **Reduced Motion**

```dart
class RespectsMotionPreference extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefersReducedMotion = MediaQuery.of(context)
        .platformBrightness == Brightness.light; // Simplified check
    
    if (prefersReducedMotion) {
      // Show static version
      return StaticWidget();
    }
    
    // Show animated version
    return AnimatedWidget();
  }
}
```

---

This comprehensive animation specification guide provides exact timing, easing, and implementation details for all animation types used in the reference websites. Use this as a precise reference when implementing animations in your portfolio.

