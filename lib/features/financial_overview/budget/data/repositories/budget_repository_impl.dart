import 'package:mono/database/categories_DB/category_db.dart';
import '../../domain/entities/budget_entity.dart';
import '../../domain/repositories/budget_repository.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  // Mock storage to simulate persistence during app session
  // In a real app, this would use SharedPreferences or Hive
  static BudgetEntity? _mockBudget;

  @override
  Future<BudgetEntity?> getCurrentMonthBudget() async {
    // Simulate network/db delay
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockBudget;
  }

  @override
  Future<void> saveBudget(
      double totalBudget, Map<String, double> categoryAllocations) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // In a real implementation, we would calculate spentAmount from transactions
    // and verify category IDs against the DB.
    // For this mock, we'll construct the entity directly.

    // Fetch category names for the IDs (mocking the join)
    final allCategories = await CategoryDB.instance.getCategories();
    final categoriesList = <CategoryEntity>[];

    categoryAllocations.forEach((id, amount) {
      // Find name or use ID as fallback
      // We only need to check if ID exists for rigorous validation,
      // but for now we trust the ID or use it as name if not found.

      String name = "Unknown";
      try {
        final match = allCategories.firstWhere((e) => e.id == id);
        name = match.name;
      } catch (e) {
        name = id;
      }

      if (amount > 0) {
        categoriesList.add(CategoryEntity(
          id: id,
          name: name,
          amount: amount,
        ));
      }
    });

    _mockBudget = BudgetEntity(
      totalBudget: totalBudget,
      spentAmount: 0, // Mock: 0 spent initially
      remainingAmount: totalBudget, // Mock: all remaining initially
      categories: categoriesList,
    );
  }
}
