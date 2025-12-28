import '../entities/goal_entity.dart';
import '../repositories/goal_repository.dart';

class GetGoalsUseCase {
  final GoalRepository repository;

  GetGoalsUseCase(this.repository);

  Future<List<GoalEntity>> call() async {
    return await repository.getGoals();
  }
}
