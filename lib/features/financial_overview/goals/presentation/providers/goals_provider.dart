import 'package:flutter/material.dart';
import '../../domain/entities/goal_entity.dart';
import '../../domain/usecases/add_goal_usecase.dart';
import '../../domain/usecases/get_goals_usecase.dart';
import '../../domain/usecases/update_goal_progress_usecase.dart';
import '../../domain/usecases/update_goal_usecase.dart';
import '../../domain/usecases/delete_goal_usecase.dart';
import '../../domain/usecases/add_goal_contribution_usecase.dart';
import 'package:mono/providers/notification_provider.dart';
import '../widgets/goal_filter.dart';

class GoalsProvider extends ChangeNotifier {
  final GetGoalsUseCase getGoalsUseCase;
  final AddGoalUseCase addGoalUseCase;
  final UpdateGoalProgressUseCase updateGoalProgressUseCase;
  final UpdateGoalUseCase? updateGoalUseCase;
  final DeleteGoalUseCase? deleteGoalUseCase;
  final AddGoalContributionUseCase? addGoalContributionUseCase;

  List<GoalEntity> _goals = [];
  bool _isLoading = false;
  NotificationProvider? _notificationProvider;
  GoalFilter _selectedFilter = GoalFilter.inProgress;

  GoalsProvider({
    required this.getGoalsUseCase,
    required this.addGoalUseCase,
    required this.updateGoalProgressUseCase,
    this.updateGoalUseCase,
    this.deleteGoalUseCase,
    this.addGoalContributionUseCase,
  });

  List<GoalEntity> get goals => _goals;
  bool get isLoading => _isLoading;

  GoalFilter get selectedFilter => _selectedFilter;

  /// Goals currently matching the active filter.
  List<GoalEntity> get filteredGoals {
    switch (_selectedFilter) {
      case GoalFilter.inProgress:
        return _goals.where((g) => !g.isCompleted).toList();
      case GoalFilter.completed:
        return _goals.where((g) => g.isCompleted).toList();
    }
  }

  /// In-progress goals count (useful for badges / empty states).
  int get inProgressCount => _goals.where((g) => !g.isCompleted).length;

  /// Completed goals count.
  int get completedCount => _goals.where((g) => g.isCompleted).length;

  /// Called by the segmented control to switch the active filter.
  void setGoalFilter(GoalFilter filter) {
    if (_selectedFilter == filter) return;
    _selectedFilter = filter;
    notifyListeners();
  }

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
      _checkGoalMilestones();
    } catch (e) {
      debugPrint("Error loading goals: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateNotificationProvider(NotificationProvider notificationProvider) {
    _notificationProvider = notificationProvider;
  }

  void _checkGoalMilestones() {
    if (_notificationProvider == null) return;
    for (var goal in _goals) {
      final progress = (goal.savedAmount / goal.targetAmount).clamp(0.0, 1.0);
      _notificationProvider!.triggerGoalMilestone(goal.title, progress);
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

  Future<void> updateGoal(GoalEntity goal) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (updateGoalUseCase != null) {
        await updateGoalUseCase!(goal);
      } else {
        await addGoalUseCase(goal);
      }
      await loadGoals();
    } catch (e) {
      debugPrint("Error updating goal: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteGoal(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (deleteGoalUseCase != null) {
        await deleteGoalUseCase!(id);
      }
      await loadGoals();
    } catch (e) {
      debugPrint("Error deleting goal: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addContribution(String goalId, double amount,
      [DateTime? date]) async {
    _isLoading = true;
    notifyListeners();

    final contributionDate = date ?? DateTime.now();

    try {
      if (addGoalContributionUseCase != null) {
        await addGoalContributionUseCase!(goalId, amount, contributionDate);
      } else {
        await updateGoalProgressUseCase(goalId, amount, isAddition: true);
      }
      await loadGoals();
    } catch (e) {
      debugPrint("Error adding goal contribution: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateSavedAmount(String goalId, double amount) async {
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
