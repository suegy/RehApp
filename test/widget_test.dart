import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_suooprt_platform/data/auth_repository.dart';
import 'package:flutter_suooprt_platform/main.dart';

// Widget tests isolate UI behavior; the running app uses PocketBaseAuthRepository.
class FakeAuthRepository implements AuthRepository {
  @override
  bool get isAuthenticated => false;

  @override
  Map<String, dynamic>? get userRecord => null;

  @override
  Future<List<Map<String, dynamic>>> loadModuleStates() async => [];

  @override
  Future<Map<String, dynamic>> saveModuleState({
    required String moduleId,
    required String state,
    required double percent,
    required Map<String, dynamic> components,
    String? recordId,
  }) async => {
    'id': recordId ?? 'test',
    'moduleId': moduleId,
    'state': state,
    'percent': percent,
    'components': components,
  };

  @override
  Future<void> authenticate({
    required String email,
    required String password,
  }) async {}

  @override
  void logout() {}
}

void main() {
  testWidgets('login screen can switch language and open the home path', (
    tester,
  ) async {
    await tester.pumpWidget(SupportApp(authRepository: FakeAuthRepository()));
    await tester.pumpAndSettle();

    expect(find.text('Välkommen in'), findsOneWidget);
    await tester.tap(find.text('en'));
    await tester.pump();
    expect(find.text('Welcome in'), findsOneWidget);

    await tester.enterText(find.byType(EditableText).first, 'test@test.se');
    await tester.enterText(find.byType(EditableText).last, 'tester45');
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Core module'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    expect(find.text('About the programme'), findsOneWidget);
    await tester.drag(
      find.byType(SingleChildScrollView).first,
      const Offset(0, -200),
    );
    await tester.pumpAndSettle();
    expect(find.text('About the programme'), findsNothing);
  });
}
