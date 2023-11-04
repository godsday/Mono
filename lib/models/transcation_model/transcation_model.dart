import 'package:hive_flutter/adapters.dart';
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
    required this.id });
   
}
