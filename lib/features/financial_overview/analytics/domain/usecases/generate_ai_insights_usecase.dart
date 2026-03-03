import '../entities/ai_insight_data.dart';
import '../entities/budget_discipline_data.dart';
import '../entities/net_worth_data.dart';
import '../entities/volatility_data.dart';

class GenerateAiInsightsUseCase {
  List<AiInsightData> call({
    required double savingsRate,
    required NetWorthData netWorth,
    required VolatilityData volatility,
    required BudgetDisciplineData budgetDiscipline,
    required double totalExpensesMonthlyAvg,
    required double liquidAssets, // from asset allocation
  }) {
    List<AiInsightData> insights = [];

    // Savings Rate Insight
    if (savingsRate > 30) {
      insights.add(AiInsightData(
          message: "Excellent! Your savings rate is over 30%.",
          type: InsightType.positive,
          priority: 3));
    } else if (savingsRate < 10) {
      insights.add(AiInsightData(
          message:
              "Your savings rate is low. Try reducing discretionary expenses.",
          type: InsightType.alert,
          priority: 5));
    }

    // Net Worth Growth Insight
    if (netWorth.growthPercentage > 5) {
      insights.add(AiInsightData(
          message:
              "Net worth grew by ${netWorth.growthPercentage.toStringAsFixed(1)}% recently. Great job!",
          type: InsightType.positive,
          priority: 4));
    } else if (netWorth.growthPercentage < 0) {
      insights.add(AiInsightData(
          message:
              "Your net worth has decreased recently. Monitor your expenses.",
          type: InsightType.warning,
          priority: 4));
    }

    // Emergency Fund Insight (Liquid Assets / Monthly Expenses)
    if (totalExpensesMonthlyAvg > 0) {
      double monthsCovered = liquidAssets / totalExpensesMonthlyAvg;
      if (monthsCovered >= 3 && monthsCovered < 6) {
        insights.add(AiInsightData(
            message:
                "Emergency fund covers ${monthsCovered.toStringAsFixed(1)} months.",
            type: InsightType.positive,
            priority: 2));
      } else if (monthsCovered >= 6) {
        insights.add(AiInsightData(
            message:
                "Excellent emergency fund! It covers ${monthsCovered.toStringAsFixed(1)} months of expenses.",
            type: InsightType.positive,
            priority: 2));
      } else if (monthsCovered > 0) {
        insights.add(AiInsightData(
            message:
                "Emergency fund is low (${monthsCovered.toStringAsFixed(1)} months). Aim for 3-6 months.",
            type: InsightType.warning,
            priority: 3));
      }
    }

    // Volatility Insight
    if (volatility.classification == VolatilityClassification.high) {
      insights.add(AiInsightData(
          message:
              "High spending volatility detected. Try to stabilize monthly expenses.",
          type: InsightType.alert,
          priority: 5));
    }

    // Budget Discipline Insight
    if (budgetDiscipline.budgetDisciplinePercentage == 100) {
      insights.add(AiInsightData(
          message:
              "Perfect budget discipline! You stayed under budget for the last 6 months.",
          type: InsightType.positive,
          priority: 2));
    } else if (budgetDiscipline.budgetDisciplinePercentage < 50) {
      insights.add(AiInsightData(
          message:
              "You frequently exceed your budget. Review your categorical limits.",
          type: InsightType.warning,
          priority: 3));
    }

    // Sort by priority descending
    insights.sort((a, b) => b.priority.compareTo(a.priority));

    if (insights.isEmpty) {
      insights.add(AiInsightData(
          message:
              "Keep tracking your finances to receive personalized insights.",
          type: InsightType.neutral,
          priority: 1));
    }

    return insights;
  }
}
