import 'dart:math';
import '../entity/insight_model.dart';

class GenerateInsightsUseCase {
  final Random _random = Random();

  InsightModel call({
    required double totalIncome,
    required double totalExpense,
    required double budget,
    required DateTime now,
    String? lastInsightId,
  }) {
    final List<InsightModel> insights = [];

    final remaining = budget - totalExpense;

    /// 1️⃣ Budget Status
    if (budget > 0) {
      if (remaining >= 0) {
        if (remaining <= budget * 0.2 && remaining > 0) {
          insights.add(
            InsightModel(
              id: "budget_warning",
              title: "Almost There",
              message: remaining.toStringAsFixed(0),
              type: InsightType.warning,
              priority: 4,
            ),
          );
        } else {
          insights.add(
            InsightModel(
              id: "budget_safe",
              title: "On Track",
              message: remaining.toStringAsFixed(0),
              type: InsightType.positive,
              priority: 3,
            ),
          );
        }
      } else {
        insights.add(
          InsightModel(
            id: "budget_exceeded",
            title: "Budget Alert",
            message: remaining.abs().toStringAsFixed(0),
            type: InsightType.warning,
            priority: 5,
          ),
        );
      }
    } else {
      insights.add(
        InsightModel(
          id: "no_budget",
          title: "Plan Ahead",
          message: "Set a monthly budget to help control your spending.",
          type: InsightType.neutral,
          priority: 2,
        ),
      );
    }

    /// 2️⃣ Daily Safe Spend
    if (budget > 0 && remaining > 0) {
      final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
      final daysLeft = (daysInMonth - now.day) + 1;

      if (daysLeft > 0) {
        final safeSpend = remaining / daysLeft;

        insights.add(
          InsightModel(
            id: "daily_safe",
            title: "Smart Tip",
            message: safeSpend.toStringAsFixed(0),
            type: InsightType.neutral,
            priority: 4,
          ),
        );
      }
    }

    /// 3️⃣ Savings Insight
    if (totalIncome > totalExpense) {
      final savings = totalIncome - totalExpense;

      insights.add(
        InsightModel(
          id: "savings",
          title: "Savings Update",
          message: savings.toStringAsFixed(0),
          type: InsightType.positive,
          priority: 3,
        ),
      );
    }

    /// Remove last shown insight
    if (lastInsightId != null) {
      insights.removeWhere((e) => e.id == lastInsightId);
    }

    /// Fallback
    if (insights.isEmpty) {
      return InsightModel(
        id: "default",
        title: "All Good",
        message: "Your financial activity looks stable.",
        type: InsightType.neutral,
        priority: 1,
      );
    }

    /// Sort by priority
    insights.sort((a, b) => b.priority.compareTo(a.priority));

    /// Pick random from top 3
    final top = insights.take(3).toList();

    return top[_random.nextInt(top.length)];
  }
}
