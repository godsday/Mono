import '../entities/goal_entity.dart';
import '../repositories/goal_repository.dart';

class UpdateGoalUseCase {
  final GoalRepository repository;

  UpdateGoalUseCase(this.repository);

  Future<void> call(GoalEntity goal) async {
    await repository.updateGoal(goal);
  }
}
