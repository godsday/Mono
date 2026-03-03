import '../../domain/entities/asset_entity.dart';
import '../../domain/repositories/asset_repository.dart';

class AssetRepositoryImpl implements AssetRepository {
  // Mock in-memory storage
  final List<AssetEntity> _mockAssets = [];

  @override
  Future<List<AssetEntity>> getAssets() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_mockAssets);
  }

  @override
  Future<void> addAsset(AssetEntity asset) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockAssets.add(asset);
  }

  @override
  Future<void> deleteAsset(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockAssets.removeWhere((element) => element.id == id);
  }
}
