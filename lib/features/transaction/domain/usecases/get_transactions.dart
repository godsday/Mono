import 'package:mono/features/transaction/data/models/transcation_model.dart';

import '../repositories/transaction_repository.dart';

class GetTransactions {
  final TransactionRepository repository;

  GetTransactions(this.repository);

  Future<List<TranscationModel>> call() async {
    print('get transactions is called');
    return await repository.getTransactions();
  }
}
