import '../entities/goal_entity.dart';

abstract class GoalRepository {
  Future<List<GoalEntity>> getGoals();
  Future<void> addGoal(GoalEntity goal);
  Future<void> updateGoalProgress(String id, double amount,
      {bool isAddition = true}); // Default adds, false subtracts or sets
  Future<void> clearGoals();
}
