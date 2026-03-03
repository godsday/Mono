import '../../../../transaction/data/models/transcation_model.dart';

class CalculateSavingsRateUseCase {
  double call(List<TranscationModel> transactions) {
    DateTime now = DateTime.now();

    double income = 0;
    double expense = 0;

    for (var t in transactions) {
      if (t.date.year == now.year && t.date.month == now.month) {
        if (t.type.toLowerCase() == 'income') {
          income += t.amount;
        } else if (t.type.toLowerCase() == 'expense') {
          expense += t.amount;
        }
      }
    }

    if (income == 0) return 0; // If no income, savings rate is 0% conceptually

    double savingsRate = ((income - expense) / income) * 100;
    if (savingsRate < 0) return 0; // Cap at 0% for negative savings rate
    if (savingsRate > 100) return 100;

    return savingsRate;
  }
}
