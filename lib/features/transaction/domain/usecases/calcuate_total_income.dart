import 'package:mono/features/transaction/data/models/transcation_model.dart';

class TotalIncomeUseCase {
  double call(List<TranscationModel> transactions) {
    double totalIncome = transactions
        .where((element) => element.type == "Income")
        .fold(0, (sum, item) => sum + item.amount);
    print("totalIncome _HomeRepositoryImp: $totalIncome");
    return totalIncome;
  }
}
