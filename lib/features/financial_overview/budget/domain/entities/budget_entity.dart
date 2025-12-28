class BudgetEntity {
  final double totalBudget;
  final double spentAmount;
  final double remainingAmount;
  final List<CategoryEntity> categories;

  BudgetEntity({
    required this.totalBudget,
    required this.spentAmount,
    required this.remainingAmount,
    required this.categories,
  });
}

class CategoryEntity {
  final String id;
  final String name;
  final double amount;

  CategoryEntity({
    required this.id,
    required this.name,
    required this.amount,
  });
}
