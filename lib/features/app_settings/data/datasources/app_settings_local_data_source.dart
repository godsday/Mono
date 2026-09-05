import 'package:shared_preferences/shared_preferences.dart';

abstract class AppSettingsLocalDataSource {
  Future<String?> getLanguageCode();
  Future<void> setLanguageCode(String code);
  Future<String?> getCurrencyCode();
  Future<void> setCurrencyCode(String code);
  Future<bool> getSmartTransactionCapture();
  Future<void> setSmartTransactionCapture(bool enabled);
}

class AppSettingsLocalDataSourceImpl implements AppSettingsLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const _languageKey = 'app_settings_language_code';
  static const _currencyKey = 'app_settings_currency_code';
  static const _smartSmsCaptureKey = 'app_settings_smart_sms_capture';

  AppSettingsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<String?> getLanguageCode() async {
    return sharedPreferences.getString(_languageKey);
  }

  @override
  Future<void> setLanguageCode(String code) async {
    await sharedPreferences.setString(_languageKey, code);
  }

  @override
  Future<String?> getCurrencyCode() async {
    return sharedPreferences.getString(_currencyKey);
  }

  @override
  Future<void> setCurrencyCode(String code) async {
    await sharedPreferences.setString(_currencyKey, code);
  }

  @override
  Future<bool> getSmartTransactionCapture() async {
    return sharedPreferences.getBool(_smartSmsCaptureKey) ?? false;
  }

  @override
  Future<void> setSmartTransactionCapture(bool enabled) async {
    await sharedPreferences.setBool(_smartSmsCaptureKey, enabled);
  }
}

