import 'package:mono/features/home/domain/repositories/home_repository.dart';
import 'package:mono/features/transaction/domain/entities/transaction_entity.dart';

class TotalBalanceUseCase {
  final HomeRepository homeRepository;
  TotalBalanceUseCase(this.homeRepository);
  double caclucateTotalBalance(List<TransactionEntity> transactions) {
    return homeRepository.calculateTotalBalance(transactions);
  }
}
