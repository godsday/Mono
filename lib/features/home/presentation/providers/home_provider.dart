import 'package:flutter/material.dart';
import 'package:mono/features/home/domain/usecase/calcuate_total_income.dart';
import 'package:mono/features/home/domain/usecase/calculate_this_month.dart';
import 'package:mono/features/home/domain/usecase/calculate_total_balance.dart';
import 'package:mono/features/home/domain/usecase/calculate_total_expense.dart';
import 'package:mono/features/home/domain/usecase/get_top_categories.dart';
import 'package:mono/features/transaction/data/models/transcation_model.dart';
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
  List<TranscationModel> _transactions = [];

  ValueNotifier<List<TranscationModel>> spendingCycleListNotifier =
      ValueNotifier([]);
  ValueNotifier<List<TranscationModel>> transcationNotifier = ValueNotifier([]);

  List<TranscationModel> get transactions => _transactions;

  double totalBalance() {
    return totalBalanceUseCase.call(_transactions);
  }

  double totalIncome() {
    return totalIncomeUseCase.call(_transactions);
  }

  double totalExpense() {
    return totalExpenseUseCase.call(_transactions);
  }

  void filterLast31Days() {
    spendingCycleListNotifier.value.clear();
    final filtered = calculateThisMonth.filterLast31Days(_transactions);
    spendingCycleListNotifier.value = filtered;
    spendingCycleListNotifier.notifyListeners();
  }

  void updateTransactions(List<TranscationModel> transactions) {
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
      getTopCategoriesUseCase.getTopCategories(_transactions, 'Income');
  List<TopCategory> get topExpenseCategories =>
      getTopCategoriesUseCase.getTopCategories(_transactions, 'Expense');

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
    return getTopCategoriesUseCase.getTopCategories(transactions, type);
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
}
