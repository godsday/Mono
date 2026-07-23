import '../repositories/app_settings_repository.dart';

class UpdateCurrencyUseCase {
  final AppSettingsRepository repository;

  UpdateCurrencyUseCase(this.repository);

  Future<void> call(String currencyCode) async {
    await repository.updateCurrencyCode(currencyCode);
  }
}
