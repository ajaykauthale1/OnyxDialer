import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onyxdialer/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel callChannel = MethodChannel('com.onyx.dialer/call');
  const MethodChannel dataChannel = MethodChannel('com.onyx.dialer/data');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(callChannel, (MethodCall methodCall) async {
      return null;
    });

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(dataChannel, (MethodCall methodCall) async {
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(callChannel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(dataChannel, null);
  });

  testWidgets('Phase 1: App Initialization Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // We need to wrap OnyxDialerApp in ProviderScope because it uses Riverpod providers internally (via HomeScreen)
    await tester.pumpWidget(const ProviderScope(child: OnyxDialerApp()));

    // Verify that the app initializes and shows the Keypad (default home screen)
    expect(find.text('Keypad'), findsWidgets);
  });
}
