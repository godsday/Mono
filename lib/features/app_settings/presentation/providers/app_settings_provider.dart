import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/entities/app_settings_entity.dart';
import '../../domain/usecases/get_app_settings_usecase.dart';
import '../../domain/usecases/update_language_usecase.dart';
import '../../domain/usecases/update_currency_usecase.dart';
import '../../domain/usecases/update_smart_transaction_capture_usecase.dart';

class AppSettingsProvider extends ChangeNotifier {
  final GetAppSettingsUseCase getAppSettingsUseCase;
  final UpdateLanguageUseCase updateLanguageUseCase;
  final UpdateCurrencyUseCase updateCurrencyUseCase;
  final UpdateSmartTransactionCaptureUseCase? updateSmartTransactionCaptureUseCase;

  AppSettingsEntity? _appSettings;
  bool _isLoading = true;

  AppSettingsProvider({
    required this.getAppSettingsUseCase,
    required this.updateLanguageUseCase,
    required this.updateCurrencyUseCase,
    this.updateSmartTransactionCaptureUseCase,
  }) {
    _loadSettings();
  }

  AppSettingsEntity? get appSettings => _appSettings;
  bool get isLoading => _isLoading;

  String get currencyCode => _appSettings?.currencyCode ?? 'INR';
  String get languageCode => _appSettings?.languageCode ?? 'en';
  bool get isSmartTransactionCaptureEnabled =>
      _appSettings?.smartTransactionCapture ?? false;

  String get currencySymbol => getCurrencySymbol(currencyCode);

  static String getCurrencySymbol(String code) {
    switch (code) {
      case 'INR':
        return '₹';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'JPY':
        return '¥';
      case 'USD':
        return '\$';
      default:
        return '₹';
    }
  }

  Future<void> _loadSettings() async {
    _isLoading = true;
    notifyListeners();

    _appSettings = await getAppSettingsUseCase();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateLanguage(String newLanguageCode) async {
    if (_appSettings?.languageCode == newLanguageCode) return;

    await updateLanguageUseCase(newLanguageCode);
    _appSettings = _appSettings?.copyWith(languageCode: newLanguageCode);
    notifyListeners();
  }

  Future<void> updateCurrency(String newCurrencyCode) async {
    if (_appSettings?.currencyCode == newCurrencyCode) return;

    await updateCurrencyUseCase(newCurrencyCode);
    _appSettings = _appSettings?.copyWith(currencyCode: newCurrencyCode);
    notifyListeners();
  }

  Future<bool> updateSmartTransactionCapture(bool enabled) async {
    if (enabled && !kIsWeb && Platform.isAndroid) {
      final status = await Permission.sms.request();
      if (!status.isGranted) {
        return false;
      }
    }

    if (updateSmartTransactionCaptureUseCase != null) {
      await updateSmartTransactionCaptureUseCase!(enabled);
    }
    _appSettings = _appSettings?.copyWith(smartTransactionCapture: enabled);
    notifyListeners();
    return true;
  }
}

