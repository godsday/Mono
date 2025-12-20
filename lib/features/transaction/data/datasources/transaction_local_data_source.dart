import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction_model.dart';
import '../../../../core/error/exceptions.dart'; // Will create this later or now

abstract class TransactionLocalDataSource {
  Future<List<TransactionModel>> getTransactions();
  Future<void> addTransaction(TransactionModel transaction);
  Future<void> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
  Future<void> clearTransactions();
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  static const String boxName =
      'transcation-db'; // Keeping legacy name for data persistence

  Future<Box<TransactionModel>> _openBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<TransactionModel>(boxName);
    }
    return await Hive.openBox<TransactionModel>(boxName);
  }

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
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
  Future<List<TransactionModel>> getTransactions() async {
    final box = await _openBox();
    return box.values.toList();
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    final box = await _openBox();
    await box.put(transaction.id, transaction);
  }
}
