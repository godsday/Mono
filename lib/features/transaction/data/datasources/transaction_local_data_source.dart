import 'package:hive_flutter/hive_flutter.dart';
import '../../../../../models/transcation_model/transcation_model.dart';

abstract class TransactionLocalDataSource {
  Future<List<TranscationModel>> getTransactions();
  Future<void> addTransaction(TranscationModel transaction);
  Future<void> updateTransaction(TranscationModel transaction);
  Future<void> deleteTransaction(String id);
  Future<void> clearTransactions();
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  static const String boxName = 'transcation-db';

  Future<Box<TranscationModel>> _openBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<TranscationModel>(boxName);
    }
    return await Hive.openBox<TranscationModel>(boxName);
  }

  @override
  Future<void> addTransaction(TranscationModel transaction) async {
    final box = await _openBox();
    await box.put(transaction.id, transaction);
  }

  @override
  Future<void> clearTransactions() async {
    final box = await _openBox();
    await box.clear();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  @override
  Future<List<TranscationModel>> getTransactions() async {
    final box = await _openBox();
    return box.values.toList();
  }

  @override
  Future<void> updateTransaction(TranscationModel transaction) async {
    final box = await _openBox();
    await box.put(transaction.id, transaction);
  }
}
