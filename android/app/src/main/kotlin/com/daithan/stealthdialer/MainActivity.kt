package com.daithan.stealthdialer

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CALL_CHANNEL = "com.onyx.dialer/call"
    private val DATA_CHANNEL = "com.onyx.dialer/data"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Phase 1.3: MethodChannel Bridge
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CALL_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "makeCall" -> {
                    // Implement makeCall
                    result.success(null)
                }
                "endCall" -> {
                    // Implement endCall
                    result.success(null)
                }
                "rejectCall" -> {
                    // Implement rejectCall
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DATA_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "syncBlockList" -> {
                    // Implement syncBlockList
                    result.success(null)
                }
                "syncGhostSettings" -> {
                    // Implement syncGhostSettings
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }
}
