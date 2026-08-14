class GoalContributionEntity {
  final String id;
  final double amount;
  final DateTime date;

  GoalContributionEntity({
    required this.id,
    required this.amount,
    required this.date,
  });
}

class GoalEntity {
  final String id;
  final String title;
  final double targetAmount;
  final double savedAmount;
  final DateTime deadline;
  final List<GoalContributionEntity> contributions;

  GoalEntity({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.savedAmount,
    required this.deadline,
    this.contributions = const [],
  });

  double get remainingAmount =>
      (targetAmount - savedAmount).clamp(0.0, targetAmount);

  double get progress =>
      targetAmount > 0 ? (savedAmount / targetAmount).clamp(0.0, 1.0) : 0.0;

  bool get isCompleted => savedAmount >= targetAmount;

  GoalEntity copyWith({
    String? id,
    String? title,
    double? targetAmount,
    double? savedAmount,
    DateTime? deadline,
    List<GoalContributionEntity>? contributions,
  }) {
    return GoalEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      targetAmount: targetAmount ?? this.targetAmount,
      savedAmount: savedAmount ?? this.savedAmount,
      deadline: deadline ?? this.deadline,
      contributions: contributions ?? this.contributions,
    );
  }
}

