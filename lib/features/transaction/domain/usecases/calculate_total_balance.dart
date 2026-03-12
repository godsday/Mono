import 'package:mono/features/transaction/domain/usecases/calcuate_total_income.dart';
import 'package:mono/features/transaction/domain/usecases/calculate_total_expense.dart';
import 'package:mono/features/transaction/data/models/transcation_model.dart';

class TotalBalanceUseCase {
  final TotalIncomeUseCase totalIncomeUseCase;
  final TotalExpenseUseCase totalExpenseUseCase;
  TotalBalanceUseCase(this.totalIncomeUseCase, this.totalExpenseUseCase);
  double call(List<TranscationModel> transactions) {
    double totalBalance = totalIncomeUseCase.call(transactions) -
        totalExpenseUseCase.call(transactions);
    print('totalBalance $totalBalance');

    return totalBalance;
  }
}
