import '../repositories/app_settings_repository.dart';

class UpdateLanguageUseCase {
  final AppSettingsRepository repository;

  UpdateLanguageUseCase(this.repository);

  Future<void> call(String languageCode) async {
    await repository.updateLanguageCode(languageCode);
  }
}
