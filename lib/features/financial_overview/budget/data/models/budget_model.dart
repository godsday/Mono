import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entities/budget_entity.dart';

part 'budget_model.g.dart';

@HiveType(typeId: 4)
class BudgetModel extends HiveObject {
  @HiveField(0)
  final double totalBudget;

  @HiveField(1)
  final double spentAmount;

  @HiveField(2)
  final double remainingAmount;

  @HiveField(3)
  final List<BudgetCategoryModel> categories;

  BudgetModel({
    required this.totalBudget,
    required this.spentAmount,
    required this.remainingAmount,
    required this.categories,
  });

  // Mapper to Entity
  BudgetEntity toEntity() {
    return BudgetEntity(
      totalBudget: totalBudget,
      spentAmount: spentAmount,
      remainingAmount: remainingAmount,
      categories: categories.map((e) => e.toEntity()).toList(),
    );
  }

  // Mapper from Entity
  static BudgetModel fromEntity(BudgetEntity entity) {
    return BudgetModel(
      totalBudget: entity.totalBudget,
      spentAmount: entity.spentAmount,
      remainingAmount: entity.remainingAmount,
      categories: entity.categories
          .map((e) => BudgetCategoryModel.fromEntity(e))
          .toList(),
    );
  }
}

@HiveType(typeId: 5)
class BudgetCategoryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double amount;

  BudgetCategoryModel({
    required this.id,
    required this.name,
    required this.amount,
  });

  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      amount: amount,
    );
  }

  static BudgetCategoryModel fromEntity(CategoryEntity entity) {
    return BudgetCategoryModel(
      id: entity.id,
      name: entity.name,
      amount: entity.amount,
    );
  }
}
