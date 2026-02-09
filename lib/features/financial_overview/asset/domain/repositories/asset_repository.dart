import '../entities/asset_entity.dart';

abstract class AssetRepository {
  Future<List<AssetEntity>> getAssets();
  Future<void> addAsset(AssetEntity asset);
  Future<void> deleteAsset(String id);
  Future<void> clearAssets();
}
