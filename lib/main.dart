import 'package:flutter/material.dart';

import 'app/app_theme.dart';
import 'controllers/app_controller.dart';
import 'data/auth_repository.dart';
import 'data/content_repository.dart';
import 'auth/login_view.dart';
import 'learning_path/home_view.dart';
import 'models/app_content.dart';

// Change this single value when the PocketBase environment changes.
const pocketBaseUrl = 'http://127.0.0.1:8291';

void main() {
  runApp(const SupportApp());
}

class SupportApp extends StatefulWidget {
  const SupportApp({super.key, this.authRepository});

  final AuthRepository? authRepository;

  @override
  State<SupportApp> createState() => _SupportAppState();
}

class _SupportAppState extends State<SupportApp> {
  late final AppController _controller = AppController(
    ContentRepository(),
    widget.authRepository ?? PocketBaseAuthRepository(pocketBaseUrl),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => FutureBuilder<AppContent>(
        future: _controller.content,
        builder: (context, snapshot) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'KI Support',
          theme: AppTheme.build(),
          home: !snapshot.hasData
              ? const Scaffold(body: Center(child: CircularProgressIndicator()))
              : _controller.signedIn
              ? HomeScreen(
                  locale: _controller.locale,
                  strings: snapshot.data!.strings(_controller.locale),
                  modules: _controller.visibleModules(snapshot.data!.modules),
                  progressFor: _controller.progressFor,
                  onCompleteComponent: _controller.completeComponent,
                  onLocaleChanged: _controller.setLocale,
                  onLogout: _controller.logout,
                )
              : LoginScreen(
                  locale: _controller.locale,
                  strings: snapshot.data!.strings(_controller.locale),
                  onLocaleChanged: _controller.setLocale,
                  onLogin: _controller.login,
                ),
        ),
      ),
    );
  }
}
