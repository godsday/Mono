import 'package:mono/features/transaction/data/models/transcation_model.dart';

class TotalExpenseUseCase {
  double call(List<TranscationModel> transactions) {
    double totalExpense = transactions
        .where((element) => element.type == "Expense")
        .fold(0, (sum, item) => sum + item.amount);
    return totalExpense;
  }
}
