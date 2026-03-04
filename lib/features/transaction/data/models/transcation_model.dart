import 'package:hive_flutter/adapters.dart';
import 'package:mono/features/transaction/domain/entities/transaction_entity.dart';
part 'transcation_model.g.dart';

@HiveType(typeId: 3)
class TranscationModel {
  @HiveField(1)
  final String type;
  @HiveField(2)
  final double amount;
  @HiveField(3)
  final DateTime date;
  @HiveField(4)
  final String category;
  @HiveField(5)
  String? purpose;
  @HiveField(6)
  String id;

  TranscationModel(
      {required this.type,
      required this.amount,
      required this.date,
      required this.category,
      this.purpose,
      required this.id});

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

  TranscationModel fromEntity(TransactionEntity entity) {
    return TranscationModel(
      id: entity.id,
      type: entity.type,
      amount: entity.amount,
      date: entity.date,
      category: entity.category,
      purpose: entity.purpose,
    );
  }
}
