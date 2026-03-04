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

  factory BudgetEntity.fromMap(Map<String, dynamic> map) {
    return BudgetEntity(
      totalBudget: map['totalBudget'],
      spentAmount: map['spentAmount'],
      remainingAmount: map['remainingAmount'],
      categories: (map['categories'] as List)
          .map((e) => CategoryEntity.fromMap(e))
          .toList(),
      month: map['month'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalBudget': totalBudget,
      'spentAmount': spentAmount,
      'remainingAmount': remainingAmount,
      'categories': categories.map((e) => e.toMap()).toList(),
      'month': month,
    };
  }
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

  factory CategoryEntity.fromMap(Map<String, dynamic> map) {
    return CategoryEntity(
      id: map['id'],
      name: map['name'],
      amount: map['amount'],
      spentAmount: map['spentAmount'] ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'spentAmount': spentAmount,
    };
  }
}
