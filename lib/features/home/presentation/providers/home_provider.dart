import 'package:flutter/material.dart';
import 'package:mono/features/home/domain/usecase/calcuate_total_income.dart';
import 'package:mono/features/home/domain/usecase/calculate_this_month.dart';
import 'package:mono/features/home/domain/usecase/calculate_total_balance.dart';
import 'package:mono/features/home/domain/usecase/calculate_total_expense.dart';
import 'package:mono/features/home/domain/usecase/get_top_categories.dart';
import 'package:mono/features/transaction/domain/entities/transaction_entity.dart';
import 'package:mono/models/top_category_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeProvider with ChangeNotifier {
  final TotalBalanceUseCase totalBalanceUseCase;
  final TotalIncomeUseCase totalIncomeUseCase;
  final TotalExpenseUseCase totalExpenseUseCase;
  final CalculateThisMonth calculateThisMonth;
  final GetTopCategories getTopCategoriesUseCase;

  HomeProvider({
    required this.getTopCategoriesUseCase,
    required this.totalBalanceUseCase,
    required this.totalIncomeUseCase,
    required this.totalExpenseUseCase,
    required this.calculateThisMonth,
  });
  String _userName = '';
  bool _isThisMonth = false;

  bool get isThisMonth => _isThisMonth;
  String get userName => _userName;
  List<TransactionEntity> _transactions = [];

  ValueNotifier<List<TransactionEntity>> spendingCycleListNotifier =
      ValueNotifier([]);
  ValueNotifier<List<TransactionEntity>> transcationNotifier =
      ValueNotifier([]);

  List<TransactionEntity> get transactions => _transactions;

  double totalBalance() {
    return totalBalanceUseCase.caclucateTotalBalance(_transactions);
  }

  double totalIncome() {
    return totalIncomeUseCase.caclucateTotalIncome(_transactions);
  }

  double totalExpense() {
    return totalExpenseUseCase.caclucateTotalExpense(_transactions);
  }

  void filterLast31Days() {
    spendingCycleListNotifier.value.clear();
    final filtered = calculateThisMonth.filterLast31Days(_transactions);
    spendingCycleListNotifier.value = filtered;
    spendingCycleListNotifier.notifyListeners();
  }

  void updateTransactions(List<TransactionEntity> transactions) {
    _transactions = transactions;

    notifyListeners();
  }

  String getSpendingCycleLabel() {
    return calculateThisMonth.getSpendingCycleLabel();
  }

  void toggleThisMonth(bool value) {
    _isThisMonth = value;
    notifyListeners();
  }

  List<TopCategory> get topIncomeCategories =>
      getTopCategoriesUseCase.getTopCategories('Income', _transactions);
  List<TopCategory> get topExpenseCategories =>
      getTopCategoriesUseCase.getTopCategories('Expense', _transactions);

  Future<void> loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('namekey') ?? 'User';
    notifyListeners();
  }

  String get greeting {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  List<TopCategory> getTopCategories(String type) {
    return getTopCategoriesUseCase.getTopCategories(type, transactions);
  }

  double getThisMonthBalance() {
    return calculateThisMonth.getThisMonthBalance(transactions);
  }

  double getThisMonthIncome() {
    return calculateThisMonth.getThisMonthIncome(transactions);
  }

  double getThisMonthExpense() {
    return calculateThisMonth.getThisMonthExpense(transactions);
  }

  thisMonthSwitch(bool value) async {
    _isThisMonth = !isThisMonth;
    print('isThisMonth $isThisMonth');
    if (isThisMonth) {
      filterLast31Days();
      getSpendingCycleLabel();
    }
    notifyListeners();
  }

  // void calculateTopCategories(List<TranscationModel> transactions) {
  //   // Clear previous data
  //   topIncomeCategories.clear();
  //   topExpenseCategories.clear();

  //   // Maps to store category totals
  //   Map<String, double> incomeCategoryTotals = {};
  //   Map<String, double> expenseCategoryTotals = {};

  //   // Calculate totals for each category
  //   for (var transaction in transactions) {
  //     if (transaction.type == 'Income') {
  //       if (incomeCategoryTotals.containsKey(transaction.category)) {
  //         incomeCategoryTotals[transaction.category] =
  //             incomeCategoryTotals[transaction.category]! + transaction.amount;
  //       } else {
  //         incomeCategoryTotals[transaction.category] = transaction.amount;
  //       }
  //     } else if (transaction.type == 'Expense') {
  //       if (expenseCategoryTotals.containsKey(transaction.category)) {
  //         expenseCategoryTotals[transaction.category] =
  //             expenseCategoryTotals[transaction.category]! + transaction.amount;
  //       } else {
  //         expenseCategoryTotals[transaction.category] = transaction.amount;
  //       }
  //     }
  //   }

  //   // Convert maps to lists and sort by amount (descending)
  //   List<MapEntry<String, double>> sortedIncomeCategories =
  //       incomeCategoryTotals.entries.toList()
  //         ..sort((a, b) => b.value.compareTo(a.value));

  //   List<MapEntry<String, double>> sortedExpenseCategories =
  //       expenseCategoryTotals.entries.toList()
  //         ..sort((a, b) => b.value.compareTo(a.value));

  //   // Calculate total amounts for percentage calculation
  //   double totalIncome =
  //       sortedIncomeCategories.fold(0, (sum, entry) => sum + entry.value);
  //   double totalExpense =
  //       sortedExpenseCategories.fold(0, (sum, entry) => sum + entry.value);

  //   // Take top 3 categories for each type
  //   int incomeCount =
  //       sortedIncomeCategories.length > 3 ? 3 : sortedIncomeCategories.length;
  //   int expenseCount =
  //       sortedExpenseCategories.length > 3 ? 3 : sortedExpenseCategories.length;

  //   // Create TopCategory objects for income
  //   for (int i = 0; i < incomeCount; i++) {
  //     var entry = sortedIncomeCategories[i];
  //     double percentage =
  //         totalIncome > 0 ? (entry.value / totalIncome) * 100 : 0;
  //     topIncomeCategories.add(TopCategory(
  //       name: entry.key,
  //       amount: entry.value,
  //       percentage: percentage,
  //     ));
  //   }

  //   // Create TopCategory objects for expense
  //   for (int i = 0; i < expenseCount; i++) {
  //     var entry = sortedExpenseCategories[i];
  //     double percentage =
  //         totalExpense > 0 ? (entry.value / totalExpense) * 100 : 0;
  //     topExpenseCategories.add(TopCategory(
  //       name: entry.key,
  //       amount: entry.value,
  //       percentage: percentage,
  //     ));
  //   }

  //   notifyListeners();
  // }
}
