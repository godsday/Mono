import 'package:mono/features/add_screen/data/models/category_model.dart';

class CategoryEntity {
  final String id;
  final String name;
  final CategoryType type;
  final bool isdeleted;

  CategoryEntity({
    required this.id,
    required this.name,
    required this.type,
    this.isdeleted = false,
  });

  factory CategoryEntity.fromMap(Map<String, dynamic> map) {
    return CategoryEntity(
      id: map['id'],
      name: map['name'],
      type: CategoryType.values.firstWhere((e) => e.name == map['type']),
      isdeleted: map['isdeleted'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'name': name,
      'isdeleted': isdeleted,
    };
  }
}
