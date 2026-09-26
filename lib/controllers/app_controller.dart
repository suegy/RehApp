import 'package:flutter/foundation.dart';

import '../data/auth_repository.dart';
import '../data/content_repository.dart';
import '../models/app_content.dart';
import '../models/module_state.dart';

class AppController extends ChangeNotifier {
  AppController(ContentRepository repository, this._auth)
    : content = repository.load() {
    _signedIn = _auth.isAuthenticated;
    _userRecord = _profile(_auth.userRecord);
  }

  final Future<AppContent> content;
  final AuthRepository _auth;
  String _locale = 'sv';
  bool _signedIn = false;
  Map<String, dynamic>? _userRecord;
  Map<String, ModuleState> _moduleStates = const {};

  String get locale => _locale;
  bool get signedIn => _signedIn;
  Map<String, dynamic>? get userRecord => _userRecord;

  double progressFor(String moduleId) {
    return (_moduleStates[moduleId]?.percent ?? 0) / 100;
  }

  List<ModuleDefinition> visibleModules(List<ModuleDefinition> modules) =>
      modules.where((module) {
        for (final prerequisite in module.prerequisites) {
          if (prerequisite.profileField != null &&
              _userRecord?[prerequisite.profileField] != prerequisite.equals) {
            return false;
          }
        }
        return true;
      }).toList();

  Future<void> completeComponent(
    String moduleId,
    String componentId,
    Iterable<String> requiredComponentIds,
  ) async {
    final existing = _moduleStates[moduleId];
    final components = <String, dynamic>{
      for (final id in requiredComponentIds)
        id: {'required': true, 'state': 'not_started'},
      for (final entry
          in existing?.components.entries ??
              const <MapEntry<String, ComponentState>>[])
        entry.key: {
          'required': entry.value.required,
          'state': entry.value.state,
        },
      componentId: {'required': true, 'state': 'completed'},
    };
    final required = components.values
        .where((value) => value['required'] == true)
        .toList();
    final completed = required
        .where((value) => value['state'] == 'completed')
        .length;
    final percent = required.isEmpty ? 0 : completed * 100 / required.length;
    final saved = await _auth.saveModuleState(
      moduleId: moduleId,
      state: percent == 100 ? 'completed' : 'in_progress',
      percent: percent.toDouble(),
      components: components,
      recordId: existing?.recordId,
    );
    final moduleState = ModuleState.fromJson(saved);
    _moduleStates = {..._moduleStates, moduleId: moduleState};
    notifyListeners();
  }

  void setLocale(String locale) {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      await _auth.authenticate(email: email, password: password);
      _userRecord = _profile(_auth.userRecord);
      try {
        _moduleStates = {
          for (final state in await _auth.loadModuleStates())
            ModuleState.fromJson(state).moduleId: ModuleState.fromJson(state),
        };
      } catch (_) {
        _moduleStates = const {};
      }
      _signedIn = true;
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  void logout() {
    _auth.logout();
    _signedIn = false;
    notifyListeners();
  }

  Map<String, dynamic>? _profile(Map<String, dynamic>? record) {
    if (record == null) return null;
    return {
      ...record,
      'underAged': record['underAgend'],
      'hasDrugExperience': record['durgExperience'],
    };
  }
}
