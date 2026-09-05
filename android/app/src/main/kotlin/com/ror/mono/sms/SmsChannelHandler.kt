package com.ror.mono.sms

import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.MethodChannel

object SmsChannelHandler {
    private var channel: MethodChannel? = null
    private val mainHandler = Handler(Looper.getMainLooper())

    fun registerChannel(channel: MethodChannel) {
        this.channel = channel
    }

    fun unregisterChannel() {
        this.channel = null
    }

    fun onSmsReceived(sender: String, body: String, timestamp: Long) {
        mainHandler.post {
            val payload = mapOf(
                "sender" to sender,
                "body" to body,
                "timestamp" to timestamp
            )
            channel?.invokeMethod("onSmsReceived", payload)
        }
    }
}
