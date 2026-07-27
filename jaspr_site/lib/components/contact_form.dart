import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../constants/theme.dart';

enum _SubmitState { idle, submitting, success, error }

/// Ported from `ContactForm` (lib/widgets/common/contact_form.dart). Submits
/// directly to Web3Forms from the browser — same access key and JSON body
/// shape as the Flutter version. `package:http` handles the browser-vs-VM
/// split internally (unlike `cloud_firestore`/`package:web`, it doesn't
/// need a manual `.vm.dart`/`.web.dart` split), so this needed no extra
/// plumbing beyond marking the component `@client`.
@client
class ContactForm extends StatefulComponent {
  final String recipientEmail;

  const ContactForm({super.key, required this.recipientEmail});

  @override
  State<ContactForm> createState() => _ContactFormState();

  @css
  static List<StyleRule> get styles => [
    css('.contact-form', [
      css('&').styles(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        gap: Gap.all(1.25.rem),
        padding: Padding.all(2.5.rem),
        backgroundColor: AppColors.surface,
        radius: BorderRadius.circular(1.25.rem),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1.5.px),
      ),
      css('h3').styles(color: AppColors.textPrimary, fontSize: 1.75.rem),
      css('.contact-form-hint').styles(
        color: AppColors.textSecondary,
        fontFamily: FontFamily.list([FontFamily('JetBrains Mono'), FontFamilies.monospace]),
        fontSize: 0.95.rem,
      ),
    ]),
    css('.form-field', [
      css('&').styles(display: Display.flex, flexDirection: FlexDirection.column, gap: Gap.all(0.5.rem)),
      css('label').styles(
        color: AppColors.textSecondary,
        fontFamily: FontFamily.list([FontFamily('JetBrains Mono'), FontFamilies.monospace]),
        fontSize: 0.85.rem,
      ),
      css('input, textarea').styles(
        color: AppColors.textPrimary,
        backgroundColor: AppColors.background,
        fontFamily: FontFamily.list([FontFamily('JetBrains Mono'), FontFamilies.monospace]),
        fontSize: 1.rem,
        padding: Padding.all(0.85.rem),
        radius: BorderRadius.circular(0.75.rem),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 1.px),
      ),
      css('input:focus, textarea:focus').styles(
        border: Border.all(color: AppColors.primary, width: 2.px),
        raw: {'outline': 'none'},
      ),
    ]),
    css('.submit-button', [
      css('&').styles(
        backgroundColor: AppColors.primary,
        color: AppColors.background,
        fontFamily: FontFamily.list([FontFamily('JetBrains Mono'), FontFamilies.monospace]),
        fontWeight: FontWeight.w700,
        fontSize: 1.rem,
        padding: Padding.symmetric(vertical: 1.rem),
        radius: BorderRadius.circular(0.75.rem),
        border: Border.none,
        cursor: Cursor.pointer,
      ),
    ]),
    css('.form-status', [
      css('&').styles(fontFamily: FontFamily.list([FontFamily('JetBrains Mono'), FontFamilies.monospace]), fontSize: 0.9.rem),
      css('&.success').styles(color: Color('#4CAF50')),
      css('&.error').styles(color: Color('#F44336')),
    ]),
  ];
}

class _ContactFormState extends State<ContactForm> {
  static const _web3FormsAccessKey = 'f73c2290-70cc-489f-afae-c766950c8604';

  String _name = '';
  String _email = '';
  String _message = '';
  _SubmitState _state = _SubmitState.idle;
  String? _errorMessage;

  Future<void> _handleSubmit() async {
    if (_name.isEmpty || _email.isEmpty || _message.isEmpty) {
      setState(() {
        _state = _SubmitState.error;
        _errorMessage = 'Please fill in every field.';
      });
      return;
    }
    if (!_email.contains('@') || !_email.contains('.')) {
      setState(() {
        _state = _SubmitState.error;
        _errorMessage = 'Please enter a valid email.';
      });
      return;
    }

    setState(() => _state = _SubmitState.submitting);

    try {
      final response = await http
          .post(
            Uri.parse('https://api.web3forms.com/submit'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'access_key': _web3FormsAccessKey,
              'subject': 'Portfolio Contact: $_name',
              'from_name': _name,
              'from_email': _email,
              'message': _message,
              'to': component.recipientEmail,
            }),
          )
          .timeout(const Duration(seconds: 10));

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200 && body['success'] == true) {
        setState(() {
          _state = _SubmitState.success;
          _name = '';
          _email = '';
          _message = '';
        });
      } else {
        setState(() {
          _state = _SubmitState.error;
          _errorMessage = body['message'] as String? ?? 'Failed to send message.';
        });
      }
    } catch (e) {
      setState(() {
        _state = _SubmitState.error;
        _errorMessage = 'Unable to send — please email me directly at ${component.recipientEmail}.';
      });
    }
  }

  @override
  Component build(BuildContext context) {
    return div(classes: 'contact-form', [
      h3([.text('Send Me a Message')]),
      p(classes: 'contact-form-hint', [
        .text("I'd love to hear from you. Send me a message and I'll respond as soon as possible."),
      ]),
      div(classes: 'form-field', [
        label([.text('Your Name')]),
        input<String>(
          type: InputType.text,
          value: _name,
          onInput: (value) => setState(() => _name = value),
        ),
      ]),
      div(classes: 'form-field', [
        label([.text('Your Email')]),
        input<String>(
          type: InputType.email,
          value: _email,
          onInput: (value) => setState(() => _email = value),
        ),
      ]),
      div(classes: 'form-field', [
        label([.text('Your Message')]),
        textarea(
          [.text(_message)],
          rows: 5,
          onInput: (value) => setState(() => _message = value),
        ),
      ]),
      button(
        classes: 'submit-button',
        attributes: {'type': 'button'},
        events: {'click': (_) => _handleSubmit()},
        [.text(_state == _SubmitState.submitting ? 'Sending…' : 'Send Message')],
      ),
      if (_state == _SubmitState.success)
        p(classes: 'form-status success', [.text("Message sent successfully! I'll get back to you soon.")]),
      if (_state == _SubmitState.error) p(classes: 'form-status error', [.text(_errorMessage ?? 'Something went wrong.')]),
    ]);
  }
}
