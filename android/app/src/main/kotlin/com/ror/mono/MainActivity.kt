package com.ror.mono

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.ror.mono.sms.SmsChannelHandler

class MainActivity: FlutterActivity() {
    private val SMS_CHANNEL = "com.ror.mono/sms_capture"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SMS_CHANNEL)
        SmsChannelHandler.registerChannel(channel)

        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "isNativeReceiverAvailable" -> result.success(true)
                else -> result.notImplemented()
            }
        }
    }

    override fun onDestroy() {
        SmsChannelHandler.unregisterChannel()
        super.onDestroy()
    }
}

