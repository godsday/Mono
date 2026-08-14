import 'package:hive_flutter/hive_flutter.dart';
import 'package:mono/core/constants/app_string/app_strings.dart';
import '../../domain/entities/goal_entity.dart';
import '../../domain/repositories/goal_repository.dart';
import '../models/goal_model.dart';

class GoalRepositoryImpl implements GoalRepository {
  Box<GoalModel> get _box => Hive.box<GoalModel>(AppStrings.goalsBoxName);

  @override
  Future<List<GoalEntity>> getGoals() async {
    return _box.values.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> addGoal(GoalEntity goal) async {
    final model = GoalModel.fromEntity(goal);
    await _box.put(goal.id, model);
  }

  @override
  Future<void> updateGoal(GoalEntity goal) async {
    final model = GoalModel.fromEntity(goal);
    await _box.put(goal.id, model);
  }

  @override
  Future<void> deleteGoal(String id) async {
    await _box.delete(id);
  }

  @override
  Future<void> updateGoalProgress(String id, double amount,
      {bool isAddition = true}) async {
    final model = _box.get(id);

    if (model != null) {
      double newSavedAmount;
      if (isAddition) {
        newSavedAmount = model.savedAmount + amount;
      } else {
        newSavedAmount = model.savedAmount - amount;
      }

      if (newSavedAmount < 0) newSavedAmount = 0;
      if (newSavedAmount > model.targetAmount) {
        newSavedAmount = model.targetAmount;
      }

      final updatedModel = GoalModel(
        id: model.id,
        title: model.title,
        targetAmount: model.targetAmount,
        savedAmount: newSavedAmount,
        deadline: model.deadline,
        contributions: model.contributions,
      );

      await _box.put(id, updatedModel);
    }
  }

  @override
  Future<void> addContribution(
      String goalId, double amount, DateTime date) async {
    final model = _box.get(goalId);
    if (model != null) {
      final newSavedAmount = (model.savedAmount + amount).clamp(0.0, model.targetAmount);
      final currentContributions = model.contributions != null
          ? List<GoalContributionModel>.from(model.contributions!)
          : <GoalContributionModel>[];

      final newContribution = GoalContributionModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        amount: amount,
        date: date,
      );

      // Insert newest contribution at top
      currentContributions.insert(0, newContribution);

      final updatedModel = GoalModel(
        id: model.id,
        title: model.title,
        targetAmount: model.targetAmount,
        savedAmount: newSavedAmount,
        deadline: model.deadline,
        contributions: currentContributions,
      );

      await _box.put(goalId, updatedModel);
    }
  }

  @override
  Future<void> clearGoals() async {
    await _box.clear();
  }
}

