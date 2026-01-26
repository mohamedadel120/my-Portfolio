import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_data.dart';

class ContactForm extends StatefulWidget {
  final bool isVisible;
  final Duration delay;

  const ContactForm({super.key, required this.isVisible, Duration? delay})
    : delay = delay ?? const Duration(milliseconds: 0);

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _showSnackBar(
    BuildContext context,
    String message,
    Color color, {
    int duration = 4,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth = screenWidth > 600 ? 400.0 : screenWidth - 80.0;

    // Use ScaffoldMessenger with fixed behavior and no margin/width conflict
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              message,
              style: GoogleFonts.poppins(color: Colors.white),
              softWrap: true,
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Remove overlay after duration
    Future.delayed(Duration(seconds: duration), () {
      overlayEntry.remove();
    });
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      try {
        // Web3Forms Configuration - Direct email sending (no new tab!)
        // Get your free access key from: https://web3forms.com/
        // Just enter your email and you'll get an access key instantly
        const web3formsAccessKey =
            'f73c2290-70cc-489f-afae-c766950c8604'; // Replace with your key from web3forms.com

        // Check if Web3Forms is configured
        if (web3formsAccessKey == 'YOUR_WEB3FORMS_ACCESS_KEY') {
          if (mounted) {
            setState(() => _isSubmitting = false);
            _showSnackBar(
              context,
              '⚠️ Please configure Web3Forms\n\n1. Go to: https://web3forms.com/\n2. Enter your email\n3. Copy your access key\n4. Update line 91 in contact_form.dart',
              Colors.orange,
              duration: 8,
            );
          }
          return;
        }

        debugPrint('Sending email via Web3Forms...');

        // Send email directly via Web3Forms API (no new tab - sends directly!)
        // The email will appear to come from the user's email address
        final response = await http
            .post(
              Uri.parse('https://api.web3forms.com/submit'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({
                'access_key': web3formsAccessKey,
                'subject': 'Portfolio Contact: ${_nameController.text}',
                'from_name': _nameController.text,
                'from_email':
                    _emailController.text, // User's email (appears as sender)
                'message': _messageController.text,
                'to': AppData.email, // Your email address (recipient)
              }),
            )
            .timeout(
              const Duration(seconds: 10),
              onTimeout: () {
                throw Exception(
                  'Request timeout. Please check your internet connection.',
                );
              },
            );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);

          if (responseData['success'] == true) {
            debugPrint('Email sent successfully via Web3Forms');

            if (mounted) {
              setState(() => _isSubmitting = false);
              _showSnackBar(
                context,
                'Message sent successfully! I\'ll get back to you soon.',
                Colors.green,
              );
              _nameController.clear();
              _emailController.clear();
              _messageController.clear();
            }
          } else {
            throw Exception(responseData['message'] ?? 'Failed to send email');
          }
        } else {
          throw Exception('Server error: ${response.statusCode}');
        }
      } catch (e) {
        debugPrint('Error sending email: $e');

        if (mounted) {
          setState(() => _isSubmitting = false);
          final errorMsg = e.toString().replaceAll('Exception: ', '');
          _showSnackBar(
            context,
            'Unable to send message: $errorMsg\n\nPlease contact me directly at ${AppData.email}',
            Colors.red,
            duration: 6,
          );
        }
        debugPrint('Error sending email: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return Container(
          padding: EdgeInsets.all(isMobile ? 20 : (isTablet ? 30 : 40)),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.surface,
                AppColors.surface.withValues(alpha: 0.95),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.15),
                blurRadius: 35,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.05),
                blurRadius: 60,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                      'Send Me a Message',
                      style: GoogleFonts.poppins(
                        fontSize: isMobile ? 24 : (isTablet ? 28 : 32),
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    )
                    .animate(autoPlay: widget.isVisible)
                    .fadeIn(delay: widget.delay, duration: 400.ms)
                    .slideX(
                      begin: -0.2,
                      end: 0,
                      delay: widget.delay,
                      duration: 400.ms,
                    ),
                const SizedBox(height: 8),
                Text(
                      'I\'d love to hear from you. Send me a message and I\'ll respond as soon as possible.',
                      style: GoogleFonts.poppins(
                        fontSize: isMobile ? 14 : 16,
                        color: AppColors.textSecondary,
                      ),
                    )
                    .animate(autoPlay: widget.isVisible)
                    .fadeIn(delay: widget.delay + 200.ms, duration: 400.ms),
                const SizedBox(height: 30),
                _buildTextField(
                  controller: _nameController,
                  label: 'Your Name',
                  icon: Icons.person_outline,
                  delay: widget.delay + 400.ms,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _emailController,
                  label: 'Your Email',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  delay: widget.delay + 500.ms,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _messageController,
                  label: 'Your Message',
                  icon: Icons.message_outlined,
                  maxLines: 5,
                  delay: widget.delay + 600.ms,
                ),
                const SizedBox(height: 30),
                SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.background,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 12,
                          shadowColor: AppColors.primary.withValues(alpha: 0.4),
                        ),
                        child: _isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.background,
                                  ),
                                ),
                              )
                            : Text(
                                'Send Message',
                                style: GoogleFonts.poppins(
                                  fontSize: isMobile ? 16 : 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    )
                    .animate(autoPlay: widget.isVisible)
                    .fadeIn(delay: widget.delay + 800.ms, duration: 400.ms)
                    .scale(
                      delay: widget.delay + 800.ms,
                      begin: const Offset(0.9, 0.9),
                      duration: 400.ms,
                    ),
              ],
            ),
          ),
        )
        .animate(autoPlay: widget.isVisible)
        .fadeIn(delay: widget.delay, duration: 500.ms)
        .slideY(begin: 0.3, end: 0, delay: widget.delay, duration: 500.ms);
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    required Duration delay,
  }) {
    return TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: GoogleFonts.poppins(color: AppColors.textPrimary),
            decoration: InputDecoration(
            labelText: label,
            labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary),
            prefixIcon: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            filled: true,
            fillColor: AppColors.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your $label';
            }
            if (keyboardType == TextInputType.emailAddress) {
              if (!value.contains('@') || !value.contains('.')) {
                return 'Please enter a valid email';
              }
            }
            return null;
          },
        )
        .animate(autoPlay: widget.isVisible)
        .fadeIn(delay: delay, duration: 400.ms)
        .slideX(begin: -0.2, end: 0, delay: delay, duration: 400.ms);
  }
}
