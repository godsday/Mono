class GoalAnalyticsData {
  final int totalGoals;
  final double averageCompletionPercentage;
  final double totalRequiredAmount;
  final double totalSavedAmount;
  final DateTime? projectedCompletionDate;

  GoalAnalyticsData({
    required this.totalGoals,
    required this.averageCompletionPercentage,
    required this.totalRequiredAmount,
    required this.totalSavedAmount,
    this.projectedCompletionDate,
  });
}
