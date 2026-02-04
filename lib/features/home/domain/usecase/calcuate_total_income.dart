import 'package:mono/features/home/domain/repositories/home_repository.dart';
import 'package:mono/features/transaction/domain/entities/transaction_entity.dart';

class TotalIncomeUseCase {
  final HomeRepository homeRepository;
  TotalIncomeUseCase(this.homeRepository);
  double caclucateTotalIncome(List<TransactionEntity> transactions) {
    return homeRepository.calculateTotalIncome(transactions);
  }
}
