// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:guild_companion/main.dart';

void main() {
  /// Verifica che la Home mostri titolo e CTA principali.
  testWidgets('Home page loads with primary actions', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Verify that the home page title and main action are visible.
    expect(find.text('Seleziona personaggio'), findsOneWidget);
    expect(find.text('Nuovo personaggio'), findsOneWidget);
  });
}
