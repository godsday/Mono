import '../entities/budget_entity.dart';

abstract class BudgetRepository {
  Future<BudgetEntity?> getCurrentMonthBudget();
  Future<void> saveBudget(
      double totalBudget, Map<String, double> categoryAllocations);
}
