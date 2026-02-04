import 'package:intl/intl.dart';
import 'package:mono/features/home/domain/repositories/home_repository.dart';
import 'package:mono/features/transaction/domain/entities/transaction_entity.dart';
import 'package:mono/models/top_category_model.dart';

class HomeRepositoryImp extends HomeRepository {
  @override
  double calculateTotalExpense(List<TransactionEntity> transactions) {
    double totalExpense = transactions
        .where((element) => element.type == "Expense")
        .fold(0, (sum, item) => sum + item.amount);
    print("totalExpense _HomeRepositoryImp: $totalExpense");
    return totalExpense;
  }

  @override
  double calculateTotalIncome(List<TransactionEntity> transactions) {
    double totalIncome = transactions
        .where((element) => element.type == "Income")
        .fold(0, (sum, item) => sum + item.amount);
    print("totalIncome _HomeRepositoryImp: $totalIncome");
    return totalIncome;
  }

  @override
  double calculateTotalBalance(List<TransactionEntity> transactions) {
    double totalBalance = calculateTotalIncome(transactions) -
        calculateTotalExpense(transactions);

    return totalBalance;
  }

  @override
  List<TransactionEntity> filterLast31Days(
      List<TransactionEntity> transactions) {
    DateTime today = DateTime.now();
    DateTime cycleStart =
        today.subtract(const Duration(days: 30)); // 31 days including today

    List<TransactionEntity> filtered = transactions.where((tx) {
      return tx.date.isAfter(cycleStart.subtract(const Duration(days: 1))) &&
          tx.date.isBefore(today.add(const Duration(days: 1)));
    }).toList();
    return filtered;
  }

  @override
  String getSpendingCycleLabel() {
    final today = DateTime.now();
    final start = today.subtract(const Duration(days: 30));
    final formatter = DateFormat('MMM dd'); // Example: Jun 12
    return 'Spending Cycle: ${formatter.format(start)} – ${formatter.format(today)}';
  }

  @override
  double getThisMonthIncome(List<TransactionEntity> transactions) {
    List<TransactionEntity> thisMonthTransactions = transactions.where((t) {
      return t.date.month == DateTime.now().month &&
          t.date.year == DateTime.now().year;
    }).toList();

    double thisMonthTotalIncome = thisMonthTransactions
        .where((t) => t.type == 'Income')
        .fold(0, (sum, t) => sum + t.amount);
    return thisMonthTotalIncome;
  }

  @override
  double getThisMonthExpense(List<TransactionEntity> transactions) {
    List<TransactionEntity> thisMonthTransactions = transactions.where((t) {
      return t.date.month == DateTime.now().month &&
          t.date.year == DateTime.now().year;
    }).toList();
    double thisMonthTotalExpense = thisMonthTransactions
        .where((t) => t.type == 'Expense')
        .fold(0, (sum, t) => sum + t.amount);
    return thisMonthTotalExpense;
  }

  @override
  double getThisMonthBalance(List<TransactionEntity> transactions) {
    List<TransactionEntity> thisMonthTransactions = transactions.where((t) {
      return t.date.month == DateTime.now().month &&
          t.date.year == DateTime.now().year;
    }).toList();
    double thisMonthTotalBalance = thisMonthTransactions
        .where((t) => t.type == 'Expense')
        .fold(0, (sum, t) => sum + t.amount);
    return thisMonthTotalBalance;
  }

  @override
  List<TopCategory> getTopCategories(
      List<TransactionEntity> transactions, String type) {
    var categoryTotals = <String, double>{};
    double totalTypeAmount = 0;

    // Filter transactions by type and calculate totals
    var transactionsOfType = transactions.where((t) => t.type == type).toList();
    for (var t in transactionsOfType) {
      categoryTotals[t.category] = (categoryTotals[t.category] ?? 0) + t.amount;
      totalTypeAmount += t.amount;
    }
    print(totalTypeAmount);
    // Convert to TopCategory list
    var topCategories = categoryTotals.entries.map((entry) {
      return TopCategory(
        name: entry.key,
        amount: entry.value,
        percentage: totalTypeAmount > 0 ? (entry.value / totalTypeAmount) : 0,
      );
    }).toList();

    // Sort by amount descending
    topCategories.sort((a, b) => b.amount.compareTo(a.amount));

    return topCategories.take(2).toList();
  }
}
