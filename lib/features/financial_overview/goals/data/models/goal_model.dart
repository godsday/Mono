import 'package:hive/hive.dart';
import '../../domain/entities/goal_entity.dart';

part 'goal_model.g.dart';

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

  GoalModel({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.savedAmount,
    required this.deadline,
  });

  GoalEntity toEntity() {
    return GoalEntity(
      id: id,
      title: title,
      targetAmount: targetAmount,
      savedAmount: savedAmount,
      deadline: deadline,
    );
  }

  static GoalModel fromEntity(GoalEntity entity) {
    return GoalModel(
      id: entity.id,
      title: entity.title,
      targetAmount: entity.targetAmount,
      savedAmount: entity.savedAmount,
      deadline: entity.deadline,
    );
  }
}
