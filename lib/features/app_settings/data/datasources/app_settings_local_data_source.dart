import 'package:shared_preferences/shared_preferences.dart';

abstract class AppSettingsLocalDataSource {
  Future<String?> getLanguageCode();
  Future<void> setLanguageCode(String code);
  Future<String?> getCurrencyCode();
  Future<void> setCurrencyCode(String code);
}

class AppSettingsLocalDataSourceImpl implements AppSettingsLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const _languageKey = 'app_settings_language_code';
  static const _currencyKey = 'app_settings_currency_code';

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
}
