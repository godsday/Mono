import 'package:hive_flutter/adapters.dart';

import '../../domain/entities/goal_entity.dart';

part 'goal_model.g.dart';

@HiveType(typeId: 8)
class GoalContributionModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final double amount;

  @HiveField(2)
  final DateTime date;

  GoalContributionModel({
    required this.id,
    required this.amount,
    required this.date,
  });

  GoalContributionEntity toEntity() {
    return GoalContributionEntity(
      id: id,
      amount: amount,
      date: date,
    );
  }

  static GoalContributionModel fromEntity(GoalContributionEntity entity) {
    return GoalContributionModel(
      id: entity.id,
      amount: entity.amount,
      date: entity.date,
    );
  }
}

@HiveType(typeId: 7)
class GoalModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double targetAmount;

  @HiveField(3)
  final double savedAmount;

  @HiveField(4)
  final DateTime deadline;

  @HiveField(5)
  final List<GoalContributionModel>? contributions;

  GoalModel({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.savedAmount,
    required this.deadline,
    this.contributions,
  });

  GoalEntity toEntity() {
    return GoalEntity(
      id: id,
      title: title,
      targetAmount: targetAmount,
      savedAmount: savedAmount,
      deadline: deadline,
      contributions:
          contributions?.map((c) => c.toEntity()).toList() ?? const [],
    );
  }

  static GoalModel fromEntity(GoalEntity entity) {
    return GoalModel(
      id: entity.id,
      title: entity.title,
      targetAmount: entity.targetAmount,
      savedAmount: entity.savedAmount,
      deadline: entity.deadline,
      contributions: entity.contributions
          .map((c) => GoalContributionModel.fromEntity(c))
          .toList(),
    );
  }
}

