import '../repositories/goal_repository.dart';

class AddGoalContributionUseCase {
  final GoalRepository repository;

  AddGoalContributionUseCase(this.repository);

  Future<void> call(String goalId, double amount, DateTime date) async {
    await repository.addContribution(goalId, amount, date);
  }
}
