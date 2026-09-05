import '../repositories/app_settings_repository.dart';

class UpdateSmartTransactionCaptureUseCase {
  final AppSettingsRepository repository;

  UpdateSmartTransactionCaptureUseCase(this.repository);

  Future<void> call(bool enabled) async {
    return await repository.updateSmartTransactionCapture(enabled);
  }
}
