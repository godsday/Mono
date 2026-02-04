import 'package:mono/features/home/domain/repositories/home_repository.dart';
import 'package:mono/features/transaction/domain/entities/transaction_entity.dart';

class CalculateThisMonth {
  final HomeRepository homeRepository;

  CalculateThisMonth(this.homeRepository);

  filterLast31Days(List<TransactionEntity> transactions) {
    return homeRepository.filterLast31Days(transactions);
  }

  getSpendingCycleLabel() {
    return homeRepository.getSpendingCycleLabel();
  }

  getThisMonthIncome(List<TransactionEntity> transactions) {
    return homeRepository.getThisMonthIncome(transactions);
  }

  getThisMonthExpense(List<TransactionEntity> transactions) {
    return homeRepository.getThisMonthExpense(transactions);
  }

  getThisMonthBalance(List<TransactionEntity> transactions) {
    return homeRepository.getThisMonthBalance(transactions);
  }
}
