import 'package:flutter/material.dart';
import '../../domain/entities/asset_entity.dart';
import '../../domain/usecases/add_asset_usecase.dart';
import '../../domain/usecases/delete_asset_usecase.dart';
import '../../domain/usecases/get_assets_usecase.dart';

class AssetsProvider extends ChangeNotifier {
  final GetAssetsUseCase getAssetsUseCase;
  final AddAssetUseCase addAssetUseCase;
  final DeleteAssetUseCase deleteAssetUseCase;

  List<AssetEntity> _assets = [];
  bool _isLoading = false;

  AssetsProvider({
    required this.getAssetsUseCase,
    required this.addAssetUseCase,
    required this.deleteAssetUseCase,
  });

  List<AssetEntity> get assets => _assets;
  bool get isLoading => _isLoading;

  double get totalAssetValue {
    return _assets.fold(0, (sum, asset) => sum + asset.currentValue);
  }

  Future<void> loadAssets() async {
    _isLoading = true;
    notifyListeners();

    try {
      _assets = await getAssetsUseCase();
    } catch (e) {
      debugPrint("Error loading assets: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addAsset(AssetEntity asset) async {
    _isLoading = true;
    notifyListeners();

    try {
      await addAssetUseCase(asset);
      await loadAssets(); // Refresh list
    } catch (e) {
      debugPrint("Error adding asset: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAsset(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await deleteAssetUseCase(id);
      await loadAssets(); // Refresh list
    } catch (e) {
      debugPrint("Error deleting asset: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
