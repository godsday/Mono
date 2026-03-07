import 'package:flutter/material.dart';
import '../../domain/entities/app_settings_entity.dart';
import '../../domain/usecases/get_app_settings_usecase.dart';
import '../../domain/usecases/update_language_usecase.dart';
import '../../domain/usecases/update_currency_usecase.dart';

class AppSettingsProvider extends ChangeNotifier {
  final GetAppSettingsUseCase getAppSettingsUseCase;
  final UpdateLanguageUseCase updateLanguageUseCase;
  final UpdateCurrencyUseCase updateCurrencyUseCase;

  AppSettingsEntity? _appSettings;
  bool _isLoading = true;

  AppSettingsProvider({
    required this.getAppSettingsUseCase,
    required this.updateLanguageUseCase,
    required this.updateCurrencyUseCase,
  }) {
    _loadSettings();
  }

  AppSettingsEntity? get appSettings => _appSettings;
  bool get isLoading => _isLoading;

  String get currencyCode => _appSettings?.currencyCode ?? 'USD';
  String get languageCode => _appSettings?.languageCode ?? 'en';

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
}
