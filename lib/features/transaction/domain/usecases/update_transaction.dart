import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository.dart';

class UpdateTransaction {
  final TransactionRepository repository;

  UpdateTransaction(this.repository);

  Future<void> call(TransactionEntity transaction) async {
    return await repository.updateTransaction(transaction);
  }
}
