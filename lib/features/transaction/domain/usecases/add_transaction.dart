import 'package:mono/features/transaction/data/models/transcation_model.dart';

import '../repositories/transaction_repository.dart';

class AddTransaction {
  final TransactionRepository repository;

  AddTransaction(this.repository);

  Future<void> call(TranscationModel transaction) async {
    return await repository.addTransaction(transaction);
  }
}
