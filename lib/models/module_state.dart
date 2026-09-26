class ModuleState {
  const ModuleState({
    required this.recordId,
    required this.moduleId,
    required this.state,
    required this.percent,
    required this.components,
  });

  final String? recordId;
  final String moduleId;
  final String state;
  final double percent;
  final Map<String, ComponentState> components;

  factory ModuleState.fromJson(Map<String, dynamic> json) {
    final content = json['content'] as Map<String, dynamic>? ?? json;
    final rawComponents =
        content['components'] as Map<String, dynamic>? ?? const {};
    return ModuleState(
      recordId: json['id'] as String?,
      moduleId: content['moduleId'] as String,
      state: content['state'] as String? ?? 'not_started',
      percent: ((content['percent'] as num?) ?? 0).clamp(0, 100).toDouble(),
      components: rawComponents.map(
        (id, value) => MapEntry(
          id,
          ComponentState.fromJson(value as Map<String, dynamic>),
        ),
      ),
    );
  }
}

class ComponentState {
  const ComponentState({required this.required, required this.state});

  final bool required;
  final String state;

  factory ComponentState.fromJson(Map<String, dynamic> json) => ComponentState(
    required: json['required'] as bool? ?? true,
    state: json['state'] as String? ?? 'not_started',
  );
}
