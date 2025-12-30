package com.daithan.stealthdialer

import android.Manifest
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import androidx.core.app.ActivityCompat
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
                    val number = call.argument<String>("number")
                    if (number != null) {
                        makeCall(number)
                        result.success(null)
                    } else {
                        result.error("INVALID_ARGUMENT", "Number is null", null)
                    }
                }
                "endCall" -> {
                    CallManager.hangup()
                    result.success(null)
                }
                "rejectCall" -> {
                    CallManager.hangup()
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
                    val ghostList = call.argument<List<String>>("ghostList")
                    if (ghostList != null) {
                        val prefs = getSharedPreferences("OnyxPrefs", Context.MODE_PRIVATE)
                        prefs.edit().putStringSet("ghostList", ghostList.toSet()).apply()
                        result.success(null)
                    } else {
                        result.success(null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun makeCall(number: String) {
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.CALL_PHONE) == PackageManager.PERMISSION_GRANTED) {
            val intent = Intent(Intent.ACTION_CALL)
            intent.data = Uri.parse("tel:$number")
            startActivity(intent)
        } else {
            // Permission should be requested from Flutter side before calling this
        }
    }
}
