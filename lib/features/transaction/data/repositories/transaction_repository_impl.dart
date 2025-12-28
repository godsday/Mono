import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_local_data_source.dart';
import '../../../../../models/transcation_model/transcation_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;

  TransactionRepositoryImpl({required this.localDataSource});

  @override
  Future<void> addTransaction(TransactionEntity transaction) async {
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
  Future<List<TransactionEntity>> getTransactions() async {
    final models = await localDataSource.getTransactions();
    return models
        .map((model) => TransactionEntity(
              id: model.id,
              type: model.type,
              amount: model.amount,
              date: model.date,
              category: model.category,
              purpose: model.purpose,
            ))
        .toList();
  }

  @override
  Future<void> updateTransaction(TransactionEntity transaction) async {
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
