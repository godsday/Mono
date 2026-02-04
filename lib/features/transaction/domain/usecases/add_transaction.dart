import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository.dart';

class AddTransaction {
  final TransactionRepository repository;

  AddTransaction(this.repository);

  Future<void> call(TransactionEntity transaction) async {
    print("adding transcation  AddTransaction: $transaction");
    return await repository.addTransaction(transaction);
  }
}
