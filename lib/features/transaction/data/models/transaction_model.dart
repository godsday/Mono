import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/transaction_entity.dart';

part 'transaction_model.g.dart';

@HiveType(
    typeId:
        3) // Keeping same typeId to maintain compatibility if possible, or migrate
class TransactionModel extends HiveObject {
  @HiveField(1)
  final String type;
  @HiveField(2)
  final double amount;
  @HiveField(3)
  final DateTime date;
  @HiveField(4)
  final String category;
  @HiveField(5)
  final String? purpose;
  @HiveField(6)
  final String id;

  TransactionModel({
    required this.type,
    required this.amount,
    required this.date,
    required this.category,
    this.purpose,
    required this.id,
  });

  // Mapper: From Entity to Model
  factory TransactionModel.fromEntity(TransactionEntity entity) {
    return TransactionModel(
      id: entity.id,
      type: entity.type,
      amount: entity.amount,
      date: entity.date,
      category: entity.category,
      purpose: entity.purpose,
    );
  }

  // Mapper: From Model to Entity
  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      type: type,
      amount: amount,
      date: date,
      category: category,
      purpose: purpose,
    );
  }
}
