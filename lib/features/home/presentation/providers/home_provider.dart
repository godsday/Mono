import 'package:flutter/material.dart';
import 'package:mono/features/home/domain/usecase/calcuate_total_income.dart';
import 'package:mono/features/home/domain/usecase/calculate_this_month.dart';
import 'package:mono/features/home/domain/usecase/calculate_total_balance.dart';
import 'package:mono/features/home/domain/usecase/calculate_total_expense.dart';
import 'package:mono/features/home/domain/usecase/get_top_categories.dart';
import 'package:mono/features/transaction/data/models/transcation_model.dart';
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

  List<TranscationModel> _transactions = [];
  bool _isThisMonth = false;
  String _userName = '';

  // ---------------- GETTERS ----------------

  bool get isThisMonth => _isThisMonth;
  String get userName => _userName;
  List<TranscationModel> get transactions => _transactions;

  double get totalBalance => totalBalanceUseCase(_transactions);

  double get totalIncome => totalIncomeUseCase(_transactions);

  double get totalExpense => totalExpenseUseCase(_transactions);

  List<TopCategory> get topIncomeCategories =>
      getTopCategoriesUseCase.getTopCategories(
        _transactions,
        'Income',
      );

  List<TopCategory> get topExpenseCategories =>
      getTopCategoriesUseCase.getTopCategories(
        _transactions,
        'Expense',
      );

  List<TranscationModel> get spendingCycleTransactions {
    if (!_isThisMonth) return _transactions;
    return calculateThisMonth.filterLast31Days(_transactions);
  }

  String get spendingCycleLabel => calculateThisMonth.getSpendingCycleLabel();

  // ---------------- ACTIONS ----------------

  void updateTransactions(List<TranscationModel> transactions) {
    _transactions = transactions;
    notifyListeners();
  }

  void toggleThisMonth(bool value) {
    _isThisMonth = value;
    notifyListeners();
  }

  double get thisMonthBalance =>
      calculateThisMonth.getThisMonthBalance(_transactions);

  double get thisMonthIncome =>
      calculateThisMonth.getThisMonthIncome(_transactions);

  double get thisMonthExpense =>
      calculateThisMonth.getThisMonthExpense(_transactions);

  Future<void> loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('namekey') ?? 'User';
    notifyListeners();
  }

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}
