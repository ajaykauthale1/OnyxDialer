package com.daithan.stealthdialer

import android.app.Activity
import android.os.Bundle
import android.telecom.Call
import android.widget.ImageButton
import android.widget.TextView
import com.example.onyxdialer.R

class PublicCallActivity : Activity() {

    private lateinit var callerNameView: TextView
    private lateinit var callerNumberView: TextView
    private lateinit var statusView: TextView
    private lateinit var btnAnswer: ImageButton
    private lateinit var btnDecline: ImageButton

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_public_call)

        callerNameView = findViewById(R.id.callerName)
        callerNumberView = findViewById(R.id.callerNumber)
        statusView = findViewById(R.id.callStatus)
        btnAnswer = findViewById(R.id.btnAnswer)
        btnDecline = findViewById(R.id.btnDecline)

        val number = intent.getStringExtra("number") ?: "Unknown"
        callerNumberView.text = number
        // TODO: Lookup name from contacts

        btnAnswer.setOnClickListener {
            CallManager.answer()
            finish() // Close activity, system in-call UI might take over or we stay here? 
            // Ideally we stay here or switch to an "In Call" state. 
            // For now, let's just answer.
        }

        btnDecline.setOnClickListener {
            CallManager.hangup()
            finish()
        }
        
        // Listen for call state changes to close activity if call ends remotely
        CallManager.currentCall.observe(this) { call ->
            if (call == null || call.state == Call.STATE_DISCONNECTED) {
                finish()
            }
        }
    }
}
