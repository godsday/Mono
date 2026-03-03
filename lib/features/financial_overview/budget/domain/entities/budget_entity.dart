class BudgetEntity {
  final double totalBudget;
  final double spentAmount;
  final double remainingAmount;
  final List<CategoryEntity> categories;
  final String month;

  BudgetEntity({
    required this.totalBudget,
    required this.spentAmount,
    required this.remainingAmount,
    required this.categories,
    required this.month,
  });
}

class CategoryEntity {
  final String id;
  final String name;
  final double amount;
  final double spentAmount;

  CategoryEntity({
    required this.id,
    required this.name,
    required this.amount,
    this.spentAmount = 0.0,
  });
}
