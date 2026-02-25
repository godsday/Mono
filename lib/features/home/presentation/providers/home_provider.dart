import 'package:flutter/material.dart';
import 'package:mono/features/financial_overview/budget/domain/entities/budget_entity.dart';
import 'package:mono/features/financial_overview/budget/domain/usecases/get_current_month_budget_usecase.dart';
import 'package:mono/features/home/domain/entity/insight_model.dart';
import 'package:mono/features/home/domain/usecase/smart_insight_usecase.dart';
import 'package:mono/features/transaction/domain/usecases/calcuate_total_income.dart';
import 'package:mono/features/transaction/domain/usecases/calculate_this_month.dart';
import 'package:mono/features/transaction/domain/usecases/calculate_total_balance.dart';
import 'package:mono/features/transaction/domain/usecases/calculate_total_expense.dart';
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
  final GenerateInsightsUseCase generateInsightsUseCase;
  final GetCurrentMonthBudgetUseCase getCurrentMonthBudgetUseCase;

  HomeProvider({
    required this.getCurrentMonthBudgetUseCase,
    required this.getTopCategoriesUseCase,
    required this.generateInsightsUseCase,
    required this.totalBalanceUseCase,
    required this.totalIncomeUseCase,
    required this.totalExpenseUseCase,
    required this.calculateThisMonth,
  });

  List<TranscationModel> _transactions = [];
  bool _isThisMonth = false;
  String _userName = '';

  // ---------------- GETTERS ----------------

  InsightModel? _currentInsight;
  String? _lastInsightId;

  double _budget = 0.0;
  double get budget => _budget;

  InsightModel? get currentInsight => _currentInsight;

  bool get isThisMonth => _isThisMonth;
  String get userName => _userName;
  List<TranscationModel> get transactions => _transactions;

  double get totalBalance => totalBalanceUseCase(_transactions);

  double get totalIncome => totalIncomeUseCase(_transactions);

  double get totalExpense => totalExpenseUseCase(_transactions);

  Future<BudgetEntity?> get budgetEntity => getCurrentMonthBudgetUseCase.call();

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
    _generateInsight();
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

  Future<void> loadBudget() async {
    final budgetData = await getCurrentMonthBudgetUseCase.call();
    _budget = budgetData?.totalBudget ?? 0.0;
    _generateInsight();
    notifyListeners();
  }

  String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  void _generateInsight() {
    _currentInsight = generateInsightsUseCase(
      totalIncome: totalIncome,
      totalExpense: thisMonthExpense,
      budget: budget,
      now: DateTime.now(),
      lastInsightId: _lastInsightId,
    );

    _lastInsightId = _currentInsight?.id;
  }
}
