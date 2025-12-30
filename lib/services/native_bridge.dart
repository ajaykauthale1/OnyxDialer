import 'package:flutter/services.dart';

class NativeBridge {
  static const _callChannel = MethodChannel('com.onyx.dialer/call');
  static const _dataChannel = MethodChannel('com.onyx.dialer/data');

  // Call Bridge
  Future<void> makeCall(String number) async {
    await _callChannel.invokeMethod('makeCall', {'number': number});
  }

  Future<void> endCall() async {
    await _callChannel.invokeMethod('endCall');
  }

  Future<void> rejectCall() async {
    await _callChannel.invokeMethod('rejectCall');
  }

  // Data Bridge
  Future<void> syncBlockList(List<String> numbers) async {
    await _dataChannel.invokeMethod('syncBlockList', {'numbers': numbers});
  }

  Future<void> syncGhostSettings(Map<String, dynamic> settings) async {
    await _dataChannel.invokeMethod('syncGhostSettings', settings);
  }
}
