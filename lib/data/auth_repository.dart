import 'package:pocketbase/pocketbase.dart';

abstract interface class AuthRepository {
  bool get isAuthenticated;
  Map<String, dynamic>? get userRecord;

  Future<List<Map<String, dynamic>>> loadModuleStates();

  Future<Map<String, dynamic>> saveModuleState({
    required String moduleId,
    required String state,
    required double percent,
    required Map<String, dynamic> components,
    String? recordId,
  });

  Future<void> authenticate({required String email, required String password});

  void logout();
}

class PocketBaseAuthRepository implements AuthRepository {
  PocketBaseAuthRepository(String baseUrl) : _client = PocketBase(baseUrl);

  final PocketBase _client;

  @override
  bool get isAuthenticated => _client.authStore.isValid;

  @override
  Map<String, dynamic>? get userRecord => _client.authStore.record?.toJson();

  @override
  Future<void> authenticate({
    required String email,
    required String password,
  }) async {
    await _client.collection('users').authWithPassword(email, password);
  }

  @override
  Future<List<Map<String, dynamic>>> loadModuleStates() async {
    final userId = _client.authStore.record?.id;
    if (userId == null) return [];
    final records = await _client
        .collection('modules')
        .getFullList(filter: 'user_id = "$userId"');
    return records.map((record) => record.toJson()).toList();
  }

  @override
  Future<Map<String, dynamic>> saveModuleState({
    required String moduleId,
    required String state,
    required double percent,
    required Map<String, dynamic> components,
    String? recordId,
  }) async {
    final userId = _client.authStore.record?.id;
    if (userId == null) throw StateError('No authenticated user.');
    final body = {
      'user_id': userId,
      'content': {
        'moduleId': moduleId,
        'state': state,
        'percent': percent,
        'components': components,
      },
    };
    final record = recordId == null
        ? await _client.collection('modules').create(body: body)
        : await _client.collection('modules').update(recordId, body: body);
    return record.toJson();
  }

  @override
  void logout() => _client.authStore.clear();
}
