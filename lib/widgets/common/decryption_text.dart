import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DecryptionText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final bool startAnimating;
  final Duration duration;

  const DecryptionText({
    super.key,
    required this.text,
    this.style,
    this.startAnimating = false, // Trigger via a scroll listener or parent
    this.duration = const Duration(milliseconds: 1500),
  });

  @override
  State<DecryptionText> createState() => _DecryptionTextState();
}

class _DecryptionTextState extends State<DecryptionText> {
  String _displayedText = "";
  Timer? _timer;
  int _currentStep = 0;
  final Random _random = Random();

  // Cyberpunk/Tech characters for the "encrypted" state
  final String _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890@#\$%&<>';

  @override
  void initState() {
    super.initState();
    _displayedText = _obfuscateFull(widget.text);
    if (widget.startAnimating) {
      _startDecryption();
    }
  }

  @override
  void didUpdateWidget(DecryptionText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.startAnimating && !oldWidget.startAnimating) {
      _startDecryption();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startDecryption() {
    final steps = 20; // Number of "frames" or chars to resolve
    final stepDuration = widget.duration.inMilliseconds ~/ steps;

    _timer?.cancel();
    _currentStep = 0;

    _timer = Timer.periodic(Duration(milliseconds: stepDuration), (timer) {
      setState(() {
        _currentStep++;

        // Calculate how many characters should be revealed based on progress
        final progress = _currentStep / steps;
        final revealCount = (widget.text.length * progress).floor();

        if (revealCount >= widget.text.length) {
          _displayedText = widget.text;
          timer.cancel();
        } else {
          // Reveal part, encrypt rest
          final clearPart = widget.text.substring(0, revealCount);
          final encryptedPart = _obfuscate(widget.text.substring(revealCount));
          _displayedText = clearPart + encryptedPart;
        }
      });
    });
  }

  String _obfuscateFull(String input) {
    return List.generate(input.length, (index) {
      if (input[index] == ' ') return ' ';
      return _chars[_random.nextInt(_chars.length)];
    }).join('');
  }

  String _obfuscate(String input) {
    return List.generate(input.length, (index) {
      final char = input[index];
      if (char == ' ') return ' ';
      // Chance to show correct character briefly implies "trying" to decode
      if (_random.nextDouble() > 0.7) return char;
      return _chars[_random.nextInt(_chars.length)];
    }).join('');
  }

  @override
  Widget build(BuildContext context) {
    // Use a monospaced font or the intended font.
    // If using variable width font, the text might jitter position.
    // Ideally use monospaced for the transition, or just accept the jitter as "glitch" style.
    return Text(
      _displayedText,
      style: widget.style ??
          GoogleFonts.firaCode(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
