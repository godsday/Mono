import 'package:mono/features/transaction/data/models/transcation_model.dart';

import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_local_data_source.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImpl({required this.localDataSource});

  @override
  Future<void> addTransaction(TranscationModel transaction) async {
    final model = TranscationModel(
      id: transaction.id,
      type: transaction.type,
      amount: transaction.amount,
      date: transaction.date,
      category: transaction.category,
      purpose: transaction.purpose,
    );
    await localDataSource.addTransaction(model);
  }

  @override
  Future<void> clearTransactions() async {
    await localDataSource.clearTransactions();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await localDataSource.deleteTransaction(id);
  }

  @override
  Future<List<TranscationModel>> getTransactions() async {
    try {
      final models = await localDataSource.getTransactions();
      return models
          .map((model) => TranscationModel(
                id: model.id,
                type: model.type,
                amount: model.amount,
                date: model.date,
                category: model.category,
                purpose: model.purpose,
              ))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateTransaction(TranscationModel transaction) async {
    final model = TranscationModel(
      id: transaction.id,
      type: transaction.type,
      amount: transaction.amount,
      date: transaction.date,
      category: transaction.category,
      purpose: transaction.purpose,
    );
    await localDataSource.updateTransaction(model);
  }
}
