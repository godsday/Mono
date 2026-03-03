import 'package:hive_flutter/hive_flutter.dart';
import 'package:mono/core/constants/app_string/app_strings.dart';
import 'package:mono/features/transaction/data/models/transcation_model.dart';

abstract class TransactionLocalDataSource {
  Future<void> addTransaction(TranscationModel obj);
  Future<List<TranscationModel>> getTransactions();
  Future<void> deleteTransaction(String id);
  Future<void> updateTransaction(TranscationModel obj);
  Future<void> clearTransactions();
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  TransactionLocalDataSourceImpl._internal();
  static TransactionLocalDataSourceImpl instance =
      TransactionLocalDataSourceImpl._internal();
  factory TransactionLocalDataSourceImpl() {
    return instance;
  }

  final transactionBox =
      Hive.box<TranscationModel>(AppStrings.transactionBoxName);

  @override
  Future<void> updateTransaction(TranscationModel obj) async {
    await transactionBox.put(obj.id, obj);
  }

  @override
  Future<void> addTransaction(TranscationModel obj) async {
    await transactionBox.put(obj.id, obj);
  }

  @override
  Future<List<TranscationModel>> getTransactions() async {
    return transactionBox.values.toList();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await transactionBox.delete(id);
  }

  @override
  Future<void> clearTransactions() async {
    await transactionBox.clear();
  }
}
