import 'package:hive/hive.dart';
import '../../domain/entities/asset_entity.dart';

part 'asset_model.g.dart';

@HiveType(typeId: 6)
class AssetModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String type;

  @HiveField(3)
  final double currentValue;

  AssetModel({
    required this.id,
    required this.name,
    required this.type,
    required this.currentValue,
  });

  AssetEntity toEntity() {
    return AssetEntity(
      id: id,
      name: name,
      type: type,
      currentValue: currentValue,
    );
  }

  static AssetModel fromEntity(AssetEntity entity) {
    return AssetModel(
      id: entity.id,
      name: entity.name,
      type: entity.type,
      currentValue: entity.currentValue,
    );
  }
}
