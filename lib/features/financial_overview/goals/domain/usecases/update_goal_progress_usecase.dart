import '../repositories/goal_repository.dart';

class UpdateGoalProgressUseCase {
  final GoalRepository repository;

  UpdateGoalProgressUseCase(this.repository);

  Future<void> call(String id, double amount, {bool isAddition = true}) async {
    await repository.updateGoalProgress(id, amount, isAddition: isAddition);
  }
}
