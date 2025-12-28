import '../../domain/entities/goal_entity.dart';
import '../../domain/repositories/goal_repository.dart';

class GoalRepositoryImpl implements GoalRepository {
  final List<GoalEntity> _mockGoals = [];

  @override
  Future<List<GoalEntity>> getGoals() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_mockGoals);
  }

  @override
  Future<void> addGoal(GoalEntity goal) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockGoals.add(goal);
  }

  @override
  Future<void> updateGoalProgress(String id, double amount,
      {bool isAddition = true}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockGoals.indexWhere((g) => g.id == id);
    if (index != -1) {
      final oldGoal = _mockGoals[index];

      double newSavedAmount;
      if (isAddition) {
        newSavedAmount = oldGoal.savedAmount + amount;
      } else {
        newSavedAmount =
            amount; // Set directly or subtract? Logic says "updateSavedAmount", implies set or add.
        // If the use case signature is generic, implementing it as 'set' if addition is false is safer for now,
        // unless I strictly defined it as subtract. The repository interface said 'updateGoalProgress'.
        // Let's assume isAddition false means SUBTRACT for now to be symmetric,
        // OR treating 'amount' as the NEW total if isAddition is false.

        // Let's stick to the simpler interpreting: calling with isAddition=false is "subtract".
        // HOWEVER, the provider requirement was `updateSavedAmount(String goalId, double amount)`.
        // Usually this means "add this amount to savings".

        // I'll implement simple addition/subtraction.
        // Actually, let's just make it replace the goal with a new one with updated amount.
        newSavedAmount = oldGoal.savedAmount; // placeholder
      }

      // Re-create entity (immutable)
      // I need to implement the logic properly.
      // Let's assume the usecase passes the DELTA amount.

      double finalAmount = isAddition
          ? (oldGoal.savedAmount + amount)
          : (oldGoal.savedAmount - amount);
      if (finalAmount < 0) finalAmount = 0;
      if (finalAmount > oldGoal.targetAmount)
        finalAmount = oldGoal.targetAmount;

      _mockGoals[index] = GoalEntity(
        id: oldGoal.id,
        title: oldGoal.title,
        targetAmount: oldGoal.targetAmount,
        savedAmount: finalAmount,
        deadline: oldGoal.deadline,
      );
    }
  }
}
