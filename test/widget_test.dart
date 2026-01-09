// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rebas_revenge/main.dart';

void main() {
  testWidgets('Menu screen loads with title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RebasRevengeApp());

    // Verify that the menu screen title is present.
    expect(find.text("🐕 Reba's Revenge 🐕"), findsOneWidget);
    
    // Verify that the start button is present.
    expect(find.text('START GAME'), findsOneWidget);
    
    // Verify that instructions are present.
    expect(find.text('HOW TO PLAY'), findsOneWidget);
  });

  testWidgets('Can navigate to game screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RebasRevengeApp());

    // Find and tap the start button.
    await tester.tap(find.text('START GAME'));
    await tester.pumpAndSettle();

    // Verify we've navigated away from menu by checking title is gone.
    expect(find.text("🐕 Reba's Revenge 🐕"), findsNothing);
  });
}
