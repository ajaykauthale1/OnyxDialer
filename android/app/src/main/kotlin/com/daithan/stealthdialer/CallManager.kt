package com.daithan.stealthdialer

import android.telecom.Call
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData

object CallManager {
    private val _currentCall = MutableLiveData<Call?>()
    val currentCall: LiveData<Call?> = _currentCall

    fun updateCall(call: Call?) {
        _currentCall.postValue(call)
    }

    fun answer() {
        _currentCall.value?.answer(0)
    }

    fun hangup() {
        val call = _currentCall.value
        if (call != null) {
            if (call.state == Call.STATE_RINGING) {
                call.reject(false, null)
            } else {
                call.disconnect()
            }
        }
    }
}
