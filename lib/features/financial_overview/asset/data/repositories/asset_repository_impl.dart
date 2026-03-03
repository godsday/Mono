import 'package:hive_flutter/hive_flutter.dart';
import 'package:mono/core/constants/app_string/app_strings.dart';
import '../../domain/entities/asset_entity.dart';
import '../../domain/repositories/asset_repository.dart';
import '../models/asset_model.dart';

class AssetRepositoryImpl implements AssetRepository {
  Box<AssetModel> get _box => Hive.box<AssetModel>(AppStrings.assetsBoxName);

  @override
  Future<List<AssetEntity>> getAssets() async {
    return _box.values.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> addAsset(AssetEntity asset) async {
    final model = AssetModel.fromEntity(asset);
    await _box.put(asset.id, model);
  }

  @override
  Future<void> deleteAsset(String id) async {
    await _box.delete(id);
  }

  @override
  Future<void> clearAssets() async {
    await _box.clear();
  }
}
