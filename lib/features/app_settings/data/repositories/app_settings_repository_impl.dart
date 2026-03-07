import '../../domain/entities/app_settings_entity.dart';
import '../../domain/repositories/app_settings_repository.dart';
import '../datasources/app_settings_local_data_source.dart';

class AppSettingsRepositoryImpl implements AppSettingsRepository {
  final AppSettingsLocalDataSource localDataSource;

  AppSettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<AppSettingsEntity> getAppSettings() async {
    final languageCode = await localDataSource.getLanguageCode() ?? 'en';
    final currencyCode = await localDataSource.getCurrencyCode() ?? 'USD';

    return AppSettingsEntity(
      languageCode: languageCode,
      currencyCode: currencyCode,
    );
  }

  @override
  Future<void> updateLanguageCode(String languageCode) async {
    await localDataSource.setLanguageCode(languageCode);
  }

  @override
  Future<void> updateCurrencyCode(String currencyCode) async {
    await localDataSource.setCurrencyCode(currencyCode);
  }
}
