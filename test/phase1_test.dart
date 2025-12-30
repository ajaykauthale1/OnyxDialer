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
    await tester.pumpWidget(const OnyxDialerApp());

    // Verify that the app title is correct.
    expect(find.text('Onyx Dialer - Phase 1 Initialized'), findsOneWidget);
  });
}
