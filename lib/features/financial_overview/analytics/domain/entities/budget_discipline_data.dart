class BudgetDisciplineData {
  final Map<String, Map<String, double>>
      last6MonthsData; // "MMM yyyy" -> {"budget": 100, "actual": 80}
  final int monthsUnderBudget;
  final double budgetDisciplinePercentage;

  BudgetDisciplineData({
    required this.last6MonthsData,
    required this.monthsUnderBudget,
    required this.budgetDisciplinePercentage,
  });
}
