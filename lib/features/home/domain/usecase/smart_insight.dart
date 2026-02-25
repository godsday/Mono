import 'package:mono/features/home/domain/entity/insight_model.dart';

class GenerateInsightsUseCase {
  InsightModel call({
    required double totalIncome,
    required double totalExpense,
    required double budget,
    required Map<String, double> categoryExpense,
    required DateTime now,
  }) {
    /// Budget not set
    if (budget == 0) {
      return InsightModel(
        title: "Start Smart",
        message: "Set a monthly budget to track your spending better.",
        type: InsightType.neutral,
      );
    }

    final remaining = budget - totalExpense;

    /// Over budget
    if (remaining < 0) {
      return InsightModel(
        title: "Budget Alert",
        message:
            "You've exceeded your budget by ₹${remaining.abs().toStringAsFixed(0)}",
        type: InsightType.alert,
      );
    }

    /// Daily safe spend
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final daysPassed = now.day;
    final daysLeft = (daysInMonth - daysPassed) + 1;

    if (daysLeft > 0) {
      final safeSpend = remaining / daysLeft;

      if (safeSpend > 0) {
        return InsightModel(
          title: "Safe to Spend",
          message:
              "You can spend about ₹${safeSpend.toStringAsFixed(0)} today.",
          type: InsightType.positive,
        );
      }
    }

    /// Top category
    if (categoryExpense.isNotEmpty) {
      final top = categoryExpense.entries.reduce(
        (a, b) => a.value > b.value ? a : b,
      );

      return InsightModel(
        title: "Top Spending",
        message:
            "${top.key} is your biggest expense (₹${top.value.toStringAsFixed(0)})",
        type: InsightType.warning,
      );
    }

    return InsightModel(
      title: "All Good",
      message: "Your finances look balanced this month.",
      type: InsightType.positive,
    );
  }
}
