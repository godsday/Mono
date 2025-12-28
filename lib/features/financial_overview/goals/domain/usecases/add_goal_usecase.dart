import '../entities/goal_entity.dart';
import '../repositories/goal_repository.dart';

class AddGoalUseCase {
  final GoalRepository repository;

  AddGoalUseCase(this.repository);

  Future<void> call(GoalEntity goal) async {
    await repository.addGoal(goal);
  }
}
