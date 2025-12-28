import 'package:flutter/material.dart';
import '../../domain/entities/goal_entity.dart';
import '../../domain/usecases/add_goal_usecase.dart';
import '../../domain/usecases/get_goals_usecase.dart';
import '../../domain/usecases/update_goal_progress_usecase.dart';

class GoalsProvider extends ChangeNotifier {
  final GetGoalsUseCase getGoalsUseCase;
  final AddGoalUseCase addGoalUseCase;
  final UpdateGoalProgressUseCase updateGoalProgressUseCase;

  List<GoalEntity> _goals = [];
  bool _isLoading = false;

  GoalsProvider({
    required this.getGoalsUseCase,
    required this.addGoalUseCase,
    required this.updateGoalProgressUseCase,
  });

  List<GoalEntity> get goals => _goals;
  bool get isLoading => _isLoading;

  double get overallProgress {
    if (_goals.isEmpty) return 0.0;

    double totalTarget = 0;
    double totalSaved = 0;

    for (var goal in _goals) {
      totalTarget += goal.targetAmount;
      totalSaved += goal.savedAmount;
    }

    if (totalTarget == 0) return 0.0;
    return (totalSaved / totalTarget).clamp(0.0, 1.0);
  }

  Future<void> loadGoals() async {
    _isLoading = true;
    notifyListeners();

    try {
      _goals = await getGoalsUseCase();
    } catch (e) {
      debugPrint("Error loading goals: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addGoal(GoalEntity goal) async {
    _isLoading = true;
    notifyListeners();

    try {
      await addGoalUseCase(goal);
      await loadGoals();
    } catch (e) {
      debugPrint("Error adding goal: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateSavedAmount(String goalId, double amount) async {
    // Assuming this adds to the savings
    _isLoading = true;
    notifyListeners();

    try {
      await updateGoalProgressUseCase(goalId, amount, isAddition: true);
      await loadGoals();
    } catch (e) {
      debugPrint("Error updating goal: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
