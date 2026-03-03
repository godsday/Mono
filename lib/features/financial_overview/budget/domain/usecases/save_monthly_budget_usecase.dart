import '../repositories/budget_repository.dart';

class SaveMonthlyBudgetUseCase {
  final BudgetRepository repository;

  SaveMonthlyBudgetUseCase(this.repository);

  Future<void> call(
      double totalBudget, Map<String, double> categoryAllocations) async {
    return await repository.saveBudget(totalBudget, categoryAllocations);
  }
}
