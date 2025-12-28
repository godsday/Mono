class GoalEntity {
  final String id;
  final String title;
  final double targetAmount;
  final double savedAmount;
  final DateTime deadline;

  GoalEntity({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.savedAmount,
    required this.deadline,
  });

  double get progress =>
      targetAmount > 0 ? (savedAmount / targetAmount).clamp(0.0, 1.0) : 0.0;
  bool get isCompleted => savedAmount >= targetAmount;
}
