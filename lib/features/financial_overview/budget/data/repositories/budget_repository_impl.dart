import 'package:hive_flutter/hive_flutter.dart';
import 'package:mono/core/constants/app_string/app_strings.dart';
import 'package:mono/features/add_screen/data/repositories/category_db.dart';
import '../../domain/entities/budget_entity.dart';
import '../../domain/repositories/budget_repository.dart';
import '../models/budget_model.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  // Hive box name must match what we opened in main.dart
  static const String _key = 'current_budget';

  @override
  Future<BudgetEntity?> getCurrentMonthBudget() async {
    final box = Hive.box<BudgetModel>(AppStrings.budgetBoxName);
    final model = box.get(_key);
    return model?.toEntity();
  }

  @override
  Future<void> saveBudget(
      double totalBudget, Map<String, double> categoryAllocations) async {
    // Fetch category names for the IDs (mocking the join)
    final allCategories = await CategoryDB.instance.getCategories();
    final categoriesList = <BudgetCategoryEntity>[];

    categoryAllocations.forEach((id, amount) {
      String name = "Unknown";
      try {
        final match = allCategories.firstWhere((e) => e.id == id);
        name = match.name;
      } catch (e) {
        name = id;
      }

      if (amount > 0) {
        categoriesList.add(BudgetCategoryEntity(
          id: id,
          name: name,
          amount: amount,
        ));
      }
    });

    final entity = BudgetEntity(
      month: DateTime.now().month.toString(),
      totalBudget: totalBudget,
      spentAmount:
          0, // Reset spent amount for new budget? Or keep? usually new budget means 0 spent or tracked elsewhere
      // Ideally spentAmount comes from transactions.
      remainingAmount: totalBudget,
      categories: categoriesList,
    );

    final model = BudgetModel.fromEntity(entity);
    final box = Hive.box<BudgetModel>(AppStrings.budgetBoxName);
    await box.put(_key, model);
  }

  @override
  Future<void> clearBudget() async {
    final box = Hive.box<BudgetModel>(AppStrings.budgetBoxName);
    await box.delete(_key);
  }
}
