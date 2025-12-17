import 'package:hive_flutter/adapters.dart';
part 'category_model.g.dart';

@HiveType(typeId: 2)
enum CategoryType{
  @HiveField(0)
  income,
  @HiveField(1)
  expense
}

@HiveType(typeId: 1)
class CategoryModel{
  @HiveField(0)
  final String id;
  @HiveField(1)
  final CategoryType type;
  @HiveField(2)
  final String name;
  @HiveField(4)
  final bool isdeleted;

  CategoryModel({required this.id, required this.type, required this.name, this.isdeleted=false});
}