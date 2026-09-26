import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/app_content.dart';

class ContentRepository {
  Future<AppContent> load() async {
    final results = await Future.wait([
      rootBundle.loadString('content/locales/sv.json'),
      rootBundle.loadString('content/locales/en.json'),
      rootBundle.loadString('content/modules.json'),
    ]);
    return AppContent(
      locales: {'sv': _asStrings(results[0]), 'en': _asStrings(results[1])},
      modules: (jsonDecode(results[2]) as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(ModuleDefinition.fromJson)
          .toList(),
    );
  }

  Future<String> loadModuleMarkdown(String moduleId, String locale) =>
      rootBundle.loadString('content/modules/$moduleId/$locale.md');

  Map<String, String> _asStrings(String source) =>
      (jsonDecode(source) as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, value as String),
      );
}
