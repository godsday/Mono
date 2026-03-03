import 'package:mono/features/transaction/data/models/transcation_model.dart';

import '../repositories/transaction_repository.dart';

class UpdateTransaction {
  final TransactionRepository repository;

  UpdateTransaction(this.repository);

  Future<void> call(TranscationModel transaction) async {
    return await repository.updateTransaction(transaction);
  }
}
