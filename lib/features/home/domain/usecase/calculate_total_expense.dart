import 'package:mono/features/home/domain/repositories/home_repository.dart';
import 'package:mono/features/transaction/domain/entities/transaction_entity.dart';

class TotalExpenseUseCase {
  final HomeRepository homeRepository;
  TotalExpenseUseCase(this.homeRepository);
  double caclucateTotalExpense(List<TransactionEntity> transactions) {
    return homeRepository.calculateTotalExpense(transactions);
  }
}
