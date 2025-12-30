package com.daithan.stealthdialer

import android.content.Context
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
                    val numbers = call.argument<List<String>>("numbers")
                    if (numbers != null) {
                        val prefs = getSharedPreferences("OnyxPrefs", Context.MODE_PRIVATE)
                        prefs.edit().putStringSet("blockList", numbers.toSet()).apply()
                        result.success(null)
                    } else {
                        result.error("INVALID_ARGUMENT", "Numbers list is null", null)
                    }
                }
                "syncGhostSettings" -> {
                    // For now, we'll just sync the ghost list if provided, or other settings
                    // Assuming ghostList is passed as part of settings for simplicity in this phase
                    val ghostList = call.argument<List<String>>("ghostList")
                    if (ghostList != null) {
                        val prefs = getSharedPreferences("OnyxPrefs", Context.MODE_PRIVATE)
                        prefs.edit().putStringSet("ghostList", ghostList.toSet()).apply()
                        result.success(null)
                    } else {
                         // Handle other settings or return success if just partial update
                        result.success(null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}
