package com.ror.mono.sms

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.provider.Telephony
import android.telephony.SmsMessage

class SmsBroadcastReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        if (context == null || intent == null) return
        if (intent.action != Telephony.Sms.Intents.SMS_RECEIVED_ACTION) return

        try {
            // Check if capture is enabled in Flutter SharedPreferences
            val prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
            val isEnabled = prefs.getBoolean("flutter.app_settings_smart_sms_capture", false)
            if (!isEnabled) return

            val messages: Array<SmsMessage>? = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                Telephony.Sms.Intents.getMessagesFromIntent(intent)
            } else {
                @Suppress("DEPRECATION")
                val pdus = intent.extras?.get("pdus") as? Array<*> ?: return
                pdus.mapNotNull { pdu ->
                    @Suppress("DEPRECATION")
                    SmsMessage.createFromPdu(pdu as ByteArray)
                }.toTypedArray()
            }

            if (messages.isNullOrEmpty()) return

            val sender = messages[0].originatingAddress ?: "UNKNOWN"
            val bodyBuilder = StringBuilder()
            for (msg in messages) {
                val bodyPart = msg.messageBody
                if (bodyPart != null) {
                    bodyBuilder.append(bodyPart)
                }
            }
            val fullBody = bodyBuilder.toString()
            val timestamp = messages[0].timestampMillis

            // Forward to active Flutter Channel
            SmsChannelHandler.onSmsReceived(sender, fullBody, timestamp)
        } catch (e: Exception) {
            // Silently handle exception to prevent crash
        }
    }
}
