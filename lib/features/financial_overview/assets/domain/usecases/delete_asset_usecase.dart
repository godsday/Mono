import '../repositories/asset_repository.dart';

class DeleteAssetUseCase {
  final AssetRepository repository;

  DeleteAssetUseCase(this.repository);

  Future<void> call(String id) async {
    await repository.deleteAsset(id);
  }
}
