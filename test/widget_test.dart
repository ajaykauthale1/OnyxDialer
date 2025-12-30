import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onyxdialer/ui/keypad/keypad_screen.dart';

void main() {
  testWidgets('Keypad UI Test', (WidgetTester tester) async {
    // Set a large enough screen size to ensure all keys are visible
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
    Finder findKey(String key) => find.text(key).last; // The keys are usually drawn last or we can be more specific

    // Verify keys exist
    expect(find.text('1'), findsOneWidget); // Initially only the key exists (display is empty)
    expect(find.text('5'), findsOneWidget);
    expect(find.text('9'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);

    // Tap keys
    await tester.tap(find.text('1'));
    await tester.tap(find.text('2'));
    await tester.pump();

    // Verify input display
    // Now we have '1' on key, '2' on key, and '12' on display.
    expect(find.text('12'), findsOneWidget);

    // Verify backspace
    await tester.tap(find.byIcon(Icons.backspace));
    await tester.pump();
    
    // Now display shows '1'. Key '1' is also visible.
    // So find.text('1') should find 2 widgets.
    expect(find.text('1'), findsNWidgets(2));
    
    // Reset view size
    addTearDown(tester.view.resetPhysicalSize);
  });
}
