import '../entities/goal_entity.dart';

abstract class GoalRepository {
  Future<List<GoalEntity>> getGoals();
  Future<void> addGoal(GoalEntity goal);
  Future<void> updateGoal(GoalEntity goal);
  Future<void> deleteGoal(String id);
  Future<void> updateGoalProgress(String id, double amount,
      {bool isAddition = true}); // Default adds, false subtracts or sets
  Future<void> addContribution(String goalId, double amount, DateTime date);
  Future<void> clearGoals();
}

