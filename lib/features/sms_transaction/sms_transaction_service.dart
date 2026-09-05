import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:mono/features/app_settings/data/datasources/app_settings_local_data_source.dart';
import 'package:mono/features/sms_transaction/data/datasources/sms_native_data_source.dart';
import 'package:mono/features/sms_transaction/domain/usecases/process_sms_usecase.dart';

typedef OnTransactionCapturedListener = void Function(ProcessSmsResult result);

class SmsTransactionService {
  final SmsNativeDataSource nativeDataSource;
  final ProcessSmsUseCase processSmsUseCase;
  final AppSettingsLocalDataSource appSettingsLocalDataSource;

  final List<OnTransactionCapturedListener> _listeners = [];
  bool _isInitialized = false;

  SmsTransactionService({
    required this.nativeDataSource,
    required this.processSmsUseCase,
    required this.appSettingsLocalDataSource,
  });

  void addListener(OnTransactionCapturedListener listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  void removeListener(OnTransactionCapturedListener listener) {
    _listeners.remove(listener);
  }

  Future<void> initialize() async {
    if (_isInitialized) return;
    if (kIsWeb || !Platform.isAndroid) return;

    _isInitialized = true;
    nativeDataSource.initialize(
      onSmsReceived: _handleIncomingSms,
    );
  }

  Future<void> _handleIncomingSms({
    required String sender,
    required String body,
    required int timestampMillis,
  }) async {
    // Check if capture is enabled in settings
    final isEnabled = await appSettingsLocalDataSource.getSmartTransactionCapture();
    if (!isEnabled) {
      return;
    }

    try {
      final result = await processSmsUseCase(
        sender: sender,
        body: body,
        timestampMillis: timestampMillis,
        showNotification: true,
      );

      if (result.isSuccess) {
        for (final listener in _listeners) {
          listener(result);
        }
      }
    } catch (e) {
      debugPrint('Error processing incoming SMS: $e');
    }
  }

  void dispose() {
    nativeDataSource.dispose();
    _listeners.clear();
    _isInitialized = false;
  }
}
