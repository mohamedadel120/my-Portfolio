import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

class TypingText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration speed;
  final Duration delay;
  final TextAlign? textAlign;

  const TypingText({
    super.key,
    required this.text,
    this.style,
    this.speed = const Duration(milliseconds: 100),
    this.delay = const Duration(milliseconds: 500),
    this.textAlign,
  });

  @override
  State<TypingText> createState() => _TypingTextState();
}

class _TypingTextState extends State<TypingText> {
  String _displayText = '';
  int _currentIndex = 0;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) {
        setState(() {
          _isTyping = true;
        });
        _typeText();
      }
    });
  }

  void _typeText() {
    if (_currentIndex < widget.text.length && _isTyping) {
      setState(() {
        _displayText = widget.text.substring(0, _currentIndex + 1);
        _currentIndex++;
      });
      Future.delayed(widget.speed, _typeText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Text(
        _displayText,
        textAlign: widget.textAlign,
        style:
            widget.style ??
            GoogleFonts.jetBrainsMono(
              fontSize: 24,
              color: AppColors.primary,
              fontWeight: FontWeight.w300,
            ),
      ),
    );
  }
}
