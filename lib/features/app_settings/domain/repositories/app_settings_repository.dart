import '../entities/app_settings_entity.dart';

abstract class AppSettingsRepository {
  Future<AppSettingsEntity> getAppSettings();
  Future<void> updateLanguageCode(String languageCode);
  Future<void> updateCurrencyCode(String currencyCode);
  Future<void> updateSmartTransactionCapture(bool enabled);
}

