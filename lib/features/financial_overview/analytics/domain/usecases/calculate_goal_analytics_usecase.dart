import '../../../goals/domain/entities/goal_entity.dart';
import '../entities/goal_analytics_data.dart';

class CalculateGoalAnalyticsUseCase {
  GoalAnalyticsData call(List<GoalEntity> goals, double avgMonthlySavings) {
    if (goals.isEmpty) {
      return GoalAnalyticsData(
        totalGoals: 0,
        averageCompletionPercentage: 0,
        totalRequiredAmount: 0,
        totalSavedAmount: 0,
        projectedCompletionDate: null,
      );
    }

    double totalRequiredAmount = 0;
    double totalSavedAmount = 0;
    double completionSum = 0;

    for (var goal in goals) {
      totalRequiredAmount += goal.targetAmount;
      totalSavedAmount += goal.savedAmount;
      double completion = 0;
      if (goal.targetAmount > 0) {
        completion = (goal.savedAmount / goal.targetAmount) * 100;
        if (completion > 100) completion = 100;
      }
      completionSum += completion;
    }

    double avgCompletionPercentage = completionSum / goals.length;

    DateTime? projectedDate;
    double remaining = totalRequiredAmount - totalSavedAmount;
    if (remaining > 0 && avgMonthlySavings > 0) {
      int monthsToComplete = (remaining / avgMonthlySavings).ceil();
      projectedDate = DateTime.now().add(Duration(days: monthsToComplete * 30));
    } else if (remaining <= 0) {
      projectedDate = DateTime.now();
    }

    return GoalAnalyticsData(
      totalGoals: goals.length,
      averageCompletionPercentage: avgCompletionPercentage,
      totalRequiredAmount: totalRequiredAmount,
      totalSavedAmount: totalSavedAmount,
      projectedCompletionDate: projectedDate,
    );
  }
}
