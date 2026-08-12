import '../repositories/goal_repository.dart';

class DeleteGoalUseCase {
  final GoalRepository repository;

  DeleteGoalUseCase(this.repository);

  Future<void> call(String id) async {
    await repository.deleteGoal(id);
  }
}
