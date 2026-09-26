import 'package:flutter/material.dart';

import '../../app/app_theme.dart';
import '../../models/app_copy.dart';
import '../../models/app_content.dart';
import '../../shared/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.locale,
    required this.strings,
    required this.onLocaleChanged,
    required this.onLogin,
  });
  final String locale;
  final AppStrings strings;
  final ValueChanged<String> onLocaleChanged;
  final Future<bool> Function(String email, String password) onLogin;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _submitting = false;
  String? _error;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    final authenticated = await widget.onLogin(
      _email.text.trim(),
      _password.text,
    );
    // Do not keep a plaintext password in the widget tree after the request.
    _password.clear();
    if (!mounted) return;
    setState(() {
      _submitting = false;
      _error = authenticated ? null : widget.strings['login_failed'];
    });
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final copy = AppCopy(widget.locale, widget.strings);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const MaterialTexture(color: AppColors.violet),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 390),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const BrandMark(large: true, light: true),
                      const SizedBox(height: 12),
                      Text(
                        copy.tagline,
                        style: const TextStyle(
                          color: Color(0xFFFFF8D8),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 30),
                      SoftPanel(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                copy.loginWelcome,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                copy.email,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextFormField(
                                controller: _email,
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: const [AutofillHints.email],
                                validator: (value) =>
                                    value == null || !value.contains('@')
                                    ? copy.strings['invalid_email']
                                    : null,
                              ),
                              const SizedBox(height: 14),
                              Text(
                                copy.password,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextFormField(
                                controller: _password,
                                obscureText: true,
                                autofillHints: const [AutofillHints.password],
                                autocorrect: false,
                                enableSuggestions: false,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                    ? copy.strings['enter_password']
                                    : null,
                              ),
                              const SizedBox(height: 20),
                              if (_error != null) ...[
                                const SizedBox(height: 12),
                                Text(
                                  _error!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ],
                              FilledButton(
                                onPressed: _submitting ? null : _submit,
                                child: Text(_submitting ? '...' : copy.login),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      LocaleToggle(
                        locale: widget.locale,
                        onChanged: widget.onLocaleChanged,
                        light: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
