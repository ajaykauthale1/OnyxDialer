import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onyxdialer/ui/home_screen.dart';

void main() {
  testWidgets('HomeScreen Navigation Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    // Verify initial state (Keypad is default, index 1)
    expect(find.text('Keypad'), findsWidgets); // Title and Nav Label
    expect(find.text('1'), findsOneWidget); // Keypad key

    // Tap Recents tab
    await tester.tap(find.text('Recents'));
    await tester.pumpAndSettle();

    // Verify Recents screen
    expect(find.text('Call History will appear here'), findsOneWidget);
    expect(find.text('1'), findsNothing); // Keypad should be gone

    // Tap Contacts tab
    await tester.tap(find.text('Contacts'));
    await tester.pumpAndSettle();

    // Verify Contacts screen
    expect(find.text('Contacts list will appear here'), findsOneWidget);
  });
}
