package com.daithan.stealthdialer

import android.content.Context
import android.database.ContentObserver
import android.net.Uri
import android.os.Handler
import android.os.Looper
import android.provider.CallLog
import android.telecom.Call
import android.telecom.InCallService
import android.util.Log
import kotlinx.coroutines.*

class StealthCallService : InCallService() {

    companion object {
        private const val TAG = "StealthCallService"
    }

    private val serviceScope = CoroutineScope(Dispatchers.IO + SupervisorJob())

    override fun onCallAdded(call: Call) {
        super.onCallAdded(call)
        Log.d(TAG, "onCallAdded: $call")

        val number = call.details.handle?.schemeSpecificPart
        if (number == null) {
            Log.w(TAG, "Call handle is null, proceeding with standard routing")
            // TODO: Launch standard UI
            return
        }

        // 1. Block Check
        if (isBlocked(number)) {
            Log.i(TAG, "Blocking call from $number")
            call.reject(false, null)
            return
        }

        // 2. Ghost Check
        if (isGhost(number)) {
            Log.i(TAG, "Ghost call detected from $number")
            // TODO: Launch StealthCallActivity
            return
        }

        // 3. Standard Routing
        Log.i(TAG, "Standard call from $number")
        // TODO: Launch PublicCallActivity or FloatingService
    }

    override fun onCallRemoved(call: Call) {
        super.onCallRemoved(call)
        Log.d(TAG, "onCallRemoved: $call")
        
        // Phase 2.2: Auto-Clear Daemon
        val number = call.details.handle?.schemeSpecificPart
        if (number != null && isGhost(number)) {
             Log.i(TAG, "Ghost call ended, triggering cleanup for $number")
             triggerAutoClear(number)
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        serviceScope.cancel()
    }

    private fun triggerAutoClear(number: String) {
        serviceScope.launch {
            try {
                // Wait a bit for the system to write to the call log
                withTimeout(10000) { // 10 second timeout
                    val observer = object : ContentObserver(Handler(Looper.getMainLooper())) {
                        override fun onChange(selfChange: Boolean, uri: Uri?) {
                            super.onChange(selfChange, uri)
                            Log.d(TAG, "Call log changed: $uri")
                            // Attempt to delete
                            if (deleteCallLogEntry(number)) {
                                contentResolver.unregisterContentObserver(this)
                                Log.i(TAG, "Successfully scrubbed $number from call log")
                                this@launch.cancel() // Stop the coroutine
                            }
                        }
                    }
                    
                    contentResolver.registerContentObserver(CallLog.Calls.CONTENT_URI, true, observer)
                    
                    // Keep the coroutine alive until timeout or success
                    awaitCancellation()
                }
            } catch (e: TimeoutCancellationException) {
                Log.w(TAG, "Timed out waiting for call log entry for $number")
            } catch (e: Exception) {
                Log.e(TAG, "Error in Auto-Clear Daemon", e)
            }
        }
    }

    private fun deleteCallLogEntry(number: String): Boolean {
        try {
            val selection = "${CallLog.Calls.NUMBER} = ?"
            val selectionArgs = arrayOf(number)
            val rowsDeleted = contentResolver.delete(CallLog.Calls.CONTENT_URI, selection, selectionArgs)
            return rowsDeleted > 0
        } catch (e: SecurityException) {
            Log.e(TAG, "Permission denied deleting call log", e)
            return false
        }
    }

    private fun isBlocked(number: String): Boolean {
        val prefs = getSharedPreferences("OnyxPrefs", Context.MODE_PRIVATE)
        val blockList = prefs.getStringSet("blockList", emptySet()) ?: emptySet()
        return blockList.contains(number)
    }

    private fun isGhost(number: String): Boolean {
        val prefs = getSharedPreferences("OnyxPrefs", Context.MODE_PRIVATE)
        val ghostList = prefs.getStringSet("ghostList", emptySet()) ?: emptySet()
        return ghostList.contains(number)
    }
}
