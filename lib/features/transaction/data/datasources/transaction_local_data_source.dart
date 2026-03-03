import 'package:hive_flutter/hive_flutter.dart';
import 'package:mono/features/transaction/data/models/transcation_model.dart';

abstract class TransactionLocalDataSource {
  Future<void> addTransaction(TranscationModel obj);
  Future<List<TranscationModel>> getTransactions();
  Future<void> deleteTransaction(String id);
  Future<void> updateTransaction(TranscationModel obj);
  Future<void> clearTransactions();
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  static const String boxName = 'transcation-db';

  TransactionLocalDataSourceImpl._internal();
  static TransactionLocalDataSourceImpl instance =
      TransactionLocalDataSourceImpl._internal();
  factory TransactionLocalDataSourceImpl() {
    return instance;
  }

  Future<Box<TranscationModel>> _openBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<TranscationModel>(boxName);
    }
    return await Hive.openBox<TranscationModel>(boxName);
  }

  @override
  Future<void> updateTransaction(TranscationModel obj) async {
    final box = await _openBox();
    await box.put(obj.id, obj);
  }

  @override
  Future<void> addTransaction(TranscationModel obj) async {
    final db = await _openBox();
    await db.put(obj.id, obj);
  }

  @override
  Future<List<TranscationModel>> getTransactions() async {
    final box = await _openBox();
    return box.values.toList();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  @override
  Future<void> clearTransactions() async {
    final box = await _openBox();
    await box.clear();
  }
}
