import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onyxdialer/services/native_bridge.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late NativeBridge nativeBridge;
  final List<MethodCall> callLog = <MethodCall>[];
  final List<MethodCall> dataLog = <MethodCall>[];

  const MethodChannel callChannel = MethodChannel('com.onyx.dialer/call');
  const MethodChannel dataChannel = MethodChannel('com.onyx.dialer/data');

  setUp(() {
    nativeBridge = NativeBridge();
    callLog.clear();
    dataLog.clear();

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(callChannel, (MethodCall methodCall) async {
      callLog.add(methodCall);
      return null;
    });

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(dataChannel, (MethodCall methodCall) async {
      dataLog.add(methodCall);
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(callChannel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(dataChannel, null);
  });

  group('NativeBridge Tests', () {
    test('makeCall invokes correct method and arguments', () async {
      const number = '1234567890';
      await nativeBridge.makeCall(number);

      expect(callLog, hasLength(1));
      expect(callLog.first.method, 'makeCall');
      expect(callLog.first.arguments, {'number': number});
    });

    test('endCall invokes correct method', () async {
      await nativeBridge.endCall();

      expect(callLog, hasLength(1));
      expect(callLog.first.method, 'endCall');
      expect(callLog.first.arguments, isNull);
    });

    test('rejectCall invokes correct method', () async {
      await nativeBridge.rejectCall();

      expect(callLog, hasLength(1));
      expect(callLog.first.method, 'rejectCall');
      expect(callLog.first.arguments, isNull);
    });

    test('syncBlockList invokes correct method and arguments', () async {
      final numbers = ['111', '222', '333'];
      await nativeBridge.syncBlockList(numbers);

      expect(dataLog, hasLength(1));
      expect(dataLog.first.method, 'syncBlockList');
      expect(dataLog.first.arguments, {'numbers': numbers});
    });

    test('syncGhostSettings invokes correct method and arguments', () async {
      final settings = {'autoClear': true, 'pin': '1234'};
      await nativeBridge.syncGhostSettings(settings);

      expect(dataLog, hasLength(1));
      expect(dataLog.first.method, 'syncGhostSettings');
      expect(dataLog.first.arguments, settings);
    });
  });
}
