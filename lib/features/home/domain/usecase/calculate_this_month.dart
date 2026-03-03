import 'package:intl/intl.dart';
import 'package:mono/features/transaction/data/models/transcation_model.dart';

class CalculateThisMonth {
  List<TranscationModel> filterLast31Days(List<TranscationModel> transactions) {
    DateTime today = DateTime.now();
    DateTime cycleStart =
        today.subtract(const Duration(days: 30)); // 31 days including today

    List<TranscationModel> filtered = transactions.where((tx) {
      return tx.date.isAfter(cycleStart.subtract(const Duration(days: 1))) &&
          tx.date.isBefore(today.add(const Duration(days: 1)));
    }).toList();
    return filtered;
  }

  String getSpendingCycleLabel() {
    final today = DateTime.now();
    final start = today.subtract(const Duration(days: 30));
    final formatter = DateFormat('MMM dd'); // Example: Jun 12
    return 'Spending Cycle: ${formatter.format(start)} – ${formatter.format(today)}';
  }

  double getThisMonthIncome(List<TranscationModel> transactions) {
    List<TranscationModel> thisMonthTransactions = transactions.where((t) {
      return t.date.month == DateTime.now().month &&
          t.date.year == DateTime.now().year;
    }).toList();

    double thisMonthTotalIncome = thisMonthTransactions
        .where((t) => t.type == 'Income')
        .fold(0, (sum, t) => sum + t.amount);
    return thisMonthTotalIncome;
  }

  double getThisMonthExpense(List<TranscationModel> transactions) {
    List<TranscationModel> thisMonthTransactions = transactions.where((t) {
      return t.date.month == DateTime.now().month &&
          t.date.year == DateTime.now().year;
    }).toList();
    double thisMonthTotalExpense = thisMonthTransactions
        .where((t) => t.type == 'Expense')
        .fold(0, (sum, t) => sum + t.amount);
    return thisMonthTotalExpense;
  }

  double getThisMonthBalance(List<TranscationModel> transactions) {
    List<TranscationModel> thisMonthTransactions = transactions.where((t) {
      return t.date.month == DateTime.now().month &&
          t.date.year == DateTime.now().year;
    }).toList();
    double thisMonthTotalBalance = thisMonthTransactions
        .where((t) => t.type == 'Expense')
        .fold(0, (sum, t) => sum + t.amount);
    return thisMonthTotalBalance;
  }
}
