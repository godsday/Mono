import 'package:mono/features/transaction/data/models/transcation_model.dart';

abstract class TransactionRepository {
  Future<List<TranscationModel>> getTransactions();
  Future<void> addTransaction(TranscationModel transaction);
  Future<void> updateTransaction(TranscationModel transaction);
  Future<void> deleteTransaction(String id);
  Future<void> clearTransactions();
}
