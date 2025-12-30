import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onyxdialer/ui/keypad/keypad_screen.dart';
import 'package:onyxdialer/providers/god_mode_provider.dart';

void main() {
  testWidgets('Entering *#0000# triggers God Mode', (WidgetTester tester) async {
    // Set screen size
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1.0;

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: KeypadScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Helper to find keys
    Finder findKey(String key) => find.text(key).last;

    // Enter *#0000#
    await tester.tap(findKey('*'));
    await tester.pump();
    await tester.tap(findKey('#'));
    await tester.pump();
    await tester.tap(findKey('0'));
    await tester.pump();
    await tester.tap(findKey('0'));
    await tester.pump();
    await tester.tap(findKey('0'));
    await tester.pump();
    await tester.tap(findKey('0'));
    await tester.pump();
    await tester.tap(findKey('#'));
    await tester.pump();

    // Verify SnackBar appears
    expect(find.text('God Mode Activated'), findsOneWidget);

    // Reset view size
    addTearDown(tester.view.resetPhysicalSize);
  });
}
