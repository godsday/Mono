import '../entities/asset_entity.dart';
import '../repositories/asset_repository.dart';

class AddAssetUseCase {
  final AssetRepository repository;

  AddAssetUseCase(this.repository);

  Future<void> call(AssetEntity asset) async {
    await repository.addAsset(asset);
  }
}
