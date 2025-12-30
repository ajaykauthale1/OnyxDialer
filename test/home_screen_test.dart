import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onyxdialer/ui/home_screen.dart';
import 'package:onyxdialer/services/contact_service.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

void main() {
  testWidgets('HomeScreen Navigation Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          // Override contactListProvider to avoid platform channel calls
          contactListProvider.overrideWith((ref) => Future.value([])),
        ],
        child: const MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    // Verify initial state (Keypad is default, index 1)
    // Note: We removed the AppBar title "Keypad" in Phase 3 polish, so we check for the key '1'
    expect(find.text('1'), findsOneWidget); 

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
    // Since we returned empty list, it should show "No contacts found"
    expect(find.text('No contacts found'), findsOneWidget);
  });
}
