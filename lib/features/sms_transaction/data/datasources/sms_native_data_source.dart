import 'dart:async';
import 'package:flutter/services.dart';

typedef SmsReceivedCallback = Future<void> Function({
  required String sender,
  required String body,
  required int timestampMillis,
});

abstract class SmsNativeDataSource {
  void initialize({required SmsReceivedCallback onSmsReceived});
  void dispose();
}

class SmsNativeDataSourceImpl implements SmsNativeDataSource {
  static const MethodChannel _channel = MethodChannel('com.ror.mono/sms_capture');
  SmsReceivedCallback? _onSmsReceived;

  @override
  void initialize({required SmsReceivedCallback onSmsReceived}) {
    _onSmsReceived = onSmsReceived;
    _channel.setMethodCallHandler(_handleMethodCall);
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    if (call.method == 'onSmsReceived') {
      final arguments = call.arguments as Map<dynamic, dynamic>?;
      if (arguments != null && _onSmsReceived != null) {
        final sender = (arguments['sender'] as String?) ?? 'UNKNOWN';
        final body = (arguments['body'] as String?) ?? '';
        final timestamp = (arguments['timestamp'] as num?)?.toInt() ??
            DateTime.now().millisecondsSinceEpoch;

        await _onSmsReceived!(
          sender: sender,
          body: body,
          timestampMillis: timestamp,
        );
      }
    }
  }

  @override
  void dispose() {
    _channel.setMethodCallHandler(null);
    _onSmsReceived = null;
  }
}
