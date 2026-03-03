import '../entities/budget_discipline_data.dart';
import '../entities/financial_health_data.dart';
import '../entities/goal_analytics_data.dart';
import '../entities/net_worth_data.dart';
import '../entities/volatility_data.dart';

class CalculateFinancialHealthUseCase {
  FinancialHealthData call({
    required double savingsRate,
    required BudgetDisciplineData budgetDiscipline,
    required GoalAnalyticsData goalAnalytics,
    required NetWorthData netWorthData,
    required VolatilityData volatilityData,
  }) {
    double score = 0;

    // 1. Savings Rate (30%)
    // Let's assume >30% savings rate gives full points
    double savingsScore = (savingsRate / 30) * 30;
    if (savingsScore > 30) savingsScore = 30;
    if (savingsScore < 0) savingsScore = 0;
    score += savingsScore;

    // 2. Budget Discipline (20%)
    double budgetScore =
        (budgetDiscipline.budgetDisciplinePercentage / 100) * 20;
    score += budgetScore;

    // 3. Goal Progress (20%)
    double goalScore = (goalAnalytics.averageCompletionPercentage / 100) * 20;
    score += goalScore;

    // 4. Asset Growth (Net Worth Growth) (20%)
    // Let's assume >10% growth over 6 months gives full points
    double growthScore = (netWorthData.growthPercentage / 10) * 20;
    if (growthScore > 20) growthScore = 20;
    if (growthScore < 0) growthScore = 0;
    score += growthScore;

    // 5. Expense Stability (Volatility) (10%)
    double volatilityScore = 0;
    switch (volatilityData.classification) {
      case VolatilityClassification.low:
        volatilityScore = 10;
        break;
      case VolatilityClassification.medium:
        volatilityScore = 5;
        break;
      case VolatilityClassification.high:
        volatilityScore = 0;
        break;
    }
    score += volatilityScore;

    // Clamp score
    if (score > 100) score = 100;
    if (score < 0) score = 0;

    // Classification
    HealthClassification classification;
    if (score < 40) {
      classification = HealthClassification.needsAttention;
    } else if (score < 70) {
      classification = HealthClassification.improving;
    } else if (score < 90) {
      classification = HealthClassification.strong;
    } else {
      classification = HealthClassification.excellent;
    }

    return FinancialHealthData(score: score, classification: classification);
  }
}
