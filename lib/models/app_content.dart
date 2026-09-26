class AppContent {
  const AppContent({required this.locales, required this.modules});

  final Map<String, Map<String, String>> locales;
  final List<ModuleDefinition> modules;

  AppStrings strings(String locale) => AppStrings(locales[locale]!);
}

class AppStrings {
  const AppStrings(this._values);

  final Map<String, String> _values;

  String operator [](String key) => _values[key] ?? '[$key]';
}

class ModuleDefinition {
  const ModuleDefinition({
    required this.id,
    required this.order,
    required this.state,
    required this.titleKey,
    required this.detailKey,
    required this.prerequisites,
  });

  final String id;
  final int order;
  final String state;
  final String titleKey;
  final String detailKey;
  final List<ModulePrerequisite> prerequisites;

  factory ModuleDefinition.fromJson(Map<String, dynamic> json) =>
      ModuleDefinition(
        id: json['id'] as String,
        order: json['order'] as int,
        state: json['state'] as String,
        titleKey: json['titleKey'] as String,
        detailKey: json['detailKey'] as String,
        prerequisites: ((json['prerequisites'] as List<dynamic>?) ?? const [])
            .cast<Map<String, dynamic>>()
            .map(ModulePrerequisite.fromJson)
            .toList(),
      );
}

class ModulePrerequisite {
  const ModulePrerequisite({
    this.moduleId,
    this.minimumProgress,
    this.profileField,
    this.equals,
  });

  final String? moduleId;
  final int? minimumProgress;
  final String? profileField;
  final bool? equals;

  factory ModulePrerequisite.fromJson(Map<String, dynamic> json) =>
      ModulePrerequisite(
        moduleId: json['moduleId'] as String?,
        minimumProgress: json['minimumProgress'] as int?,
        profileField: json['profileField'] as String?,
        equals: json['equals'] as bool?,
      );
}
