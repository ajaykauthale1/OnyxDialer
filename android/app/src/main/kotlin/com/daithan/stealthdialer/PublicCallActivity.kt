package com.daithan.stealthdialer

import android.Manifest
import android.content.pm.PackageManager
import android.os.Bundle
import android.telecom.Call
import android.telephony.SmsManager
import android.widget.Button
import android.widget.ImageButton
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import com.daithan.stealthdialer.R

class PublicCallActivity : AppCompatActivity() {

    private lateinit var callerNameView: TextView
    private lateinit var callerNumberView: TextView
    private lateinit var statusView: TextView
    private lateinit var btnAnswer: ImageButton
    private lateinit var btnDecline: ImageButton
    private lateinit var btnMessage: Button
    private var currentNumber: String = ""

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_public_call)

        callerNameView = findViewById(R.id.callerName)
        callerNumberView = findViewById(R.id.callerNumber)
        statusView = findViewById(R.id.callStatus)
        btnAnswer = findViewById(R.id.btnAnswer)
        btnDecline = findViewById(R.id.btnDecline)
        btnMessage = findViewById(R.id.btnMessage)

        currentNumber = intent.getStringExtra("number") ?: "Unknown"
        callerNumberView.text = currentNumber
        // TODO: Lookup name from contacts

        btnAnswer.setOnClickListener {
            CallManager.answer()
            statusView.text = "Active Call"
        }

        btnDecline.setOnClickListener {
            CallManager.hangup()
            finish()
        }

        btnMessage.setOnClickListener {
            sendQuickResponse()
        }
        
        // Listen for call state changes
        CallManager.currentCall.observe(this) { call ->
            if (call == null || call.state == Call.STATE_DISCONNECTED) {
                finish()
            } else {
                updateUI(call)
            }
        }
    }

    private fun sendQuickResponse() {
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.SEND_SMS) == PackageManager.PERMISSION_GRANTED) {
            try {
                val smsManager = SmsManager.getDefault()
                smsManager.sendTextMessage(currentNumber, null, "Can't talk now. Call you back later.", null, null)
                Toast.makeText(this, "Message sent", Toast.LENGTH_SHORT).show()
                CallManager.hangup()
                finish()
            } catch (e: Exception) {
                Toast.makeText(this, "Failed to send message", Toast.LENGTH_SHORT).show()
                e.printStackTrace()
            }
        } else {
            Toast.makeText(this, "SMS Permission missing", Toast.LENGTH_SHORT).show()
        }
    }

    private fun updateUI(call: Call) {
        when (call.state) {
            Call.STATE_RINGING -> statusView.text = "Incoming Call"
            Call.STATE_DIALING -> statusView.text = "Dialing..."
            Call.STATE_ACTIVE -> statusView.text = "Connected"
            Call.STATE_HOLDING -> statusView.text = "On Hold"
        }
    }
}
