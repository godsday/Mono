import '../entities/budget_entity.dart';
import '../repositories/budget_repository.dart';

class GetCurrentMonthBudgetUseCase {
  final BudgetRepository repository;

  GetCurrentMonthBudgetUseCase(this.repository);

  Future<BudgetEntity?> call() async {
    return await repository.getCurrentMonthBudget();
  }
}
