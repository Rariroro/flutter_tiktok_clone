import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiktok_clone/firebase_options.dart';
import 'package:flutter_tiktok_clone/main.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ); //firebase초기화
    await FirebaseAuth.instance.signOut();
  });

  testWidgets("Create Account Flow", (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: TikTokApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(const Duration(seconds: 10));

    expect(find.text('Sign up for TikTok'), findsOneWidget);
    expect(find.text('Log in?'), findsOneWidget);
    await tester.tap(find.text('Log in?'));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(const Duration(seconds: 10));

    final signUp = find.text("Sign up");
    await tester.tap(signUp);
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(const Duration(seconds: 10));

    final emailBtn = find.text('Use email or password');
    expect(emailBtn, findsOneWidget);
    await tester.tap(emailBtn);
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(const Duration(seconds: 10));

    final usernameInput = find.byType(TextField).first;
    await tester.enterText(usernameInput, "test");
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(const Duration(seconds: 10));

    await tester.tap(find.text("Next"));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(const Duration(seconds: 10));

    final emailInput = find.byType(TextField).first;
    await tester.enterText(emailInput, "test@testing.com");
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(const Duration(seconds: 10));

    await tester.tap(find.text("Next"));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(const Duration(seconds: 10));

    final passwordInput = find.byType(TextField).first;
    await tester.enterText(passwordInput, "essy1205^^");
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(const Duration(seconds: 10));

    await tester.tap(find.text("Next"));
    await tester.pumpAndSettle();
    await tester.pumpAndSettle(const Duration(seconds: 10));

    await tester.tap(find.text("Next"));
    await tester.pumpAndSettle(const Duration(seconds: 10));
  });
}
