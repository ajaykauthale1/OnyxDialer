import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onyxdialer/services/native_bridge.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late NativeBridge nativeBridge;
  final List<MethodCall> dataLog = <MethodCall>[];
  const MethodChannel dataChannel = MethodChannel('com.onyx.dialer/data');

  setUp(() {
    nativeBridge = NativeBridge();
    dataLog.clear();

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(dataChannel, (MethodCall methodCall) async {
      dataLog.add(methodCall);
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(dataChannel, null);
  });

  test('Integration: Sync Block List sends correct data to Native', () async {
    final blockList = ['+15550101', '+15550102'];
    
    await nativeBridge.syncBlockList(blockList);

    expect(dataLog, hasLength(1));
    expect(dataLog.first.method, 'syncBlockList');
    expect(dataLog.first.arguments, {'numbers': blockList});
  });

  test('Integration: Sync Ghost Settings sends correct data to Native', () async {
    final ghostSettings = {
      'ghostList': ['+15559999'],
      'autoClear': true
    };

    await nativeBridge.syncGhostSettings(ghostSettings);

    expect(dataLog, hasLength(1));
    expect(dataLog.first.method, 'syncGhostSettings');
    expect(dataLog.first.arguments, ghostSettings);
  });
}
