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
import 'package:mono/providers/notification_provider.dart';

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
  bool _isThisMonth = true;
  String _userName = '';
  NotificationProvider? _notificationProvider;

  // ---------------- GETTERS ----------------

  InsightModel? _currentInsight;
  String? _lastInsightId;

  double _budget = 0.0;
  double get budget => _budget;

  InsightModel? get currentInsight => _currentInsight;

  bool get isThisMonth => _isThisMonth;
  String get userName => _userName;
  List<TranscationModel> get transactions => _transactions;

  double _totalBalance = 0.0;
  double _totalIncome = 0.0;
  double _totalExpense = 0.0;
  double _thisMonthBalance = 0.0;
  double _thisMonthIncome = 0.0;
  double _thisMonthExpense = 0.0;
  double _previousMonthIncome = 0.0;
  double _previousMonthExpense = 0.0;
  List<TopCategory> _topIncomeCategories = [];
  List<TopCategory> _topExpenseCategories = [];

  double get totalBalance => _totalBalance;
  double get totalIncome => _totalIncome;
  double get totalExpense => _totalExpense;
  double get thisMonthBalance => _thisMonthBalance;
  double get thisMonthIncome => _thisMonthIncome;
  double get thisMonthExpense => _thisMonthExpense;
  double get previousMonthIncome => _previousMonthIncome;
  double get previousMonthExpense => _previousMonthExpense;
  List<TopCategory> get topIncomeCategories => _topIncomeCategories;
  List<TopCategory> get topExpenseCategories => _topExpenseCategories;

  Future<BudgetEntity?> get budgetEntity => getCurrentMonthBudgetUseCase.call();

  List<TranscationModel> get spendingCycleTransactions {
    if (!_isThisMonth) return _transactions;
    return calculateThisMonth.filterLast31Days(_transactions);
  }

  String spendingCycleLabel(String label) =>
      calculateThisMonth.getSpendingCycleLabel(label);

  // ---------------- ACTIONS ----------------

  void updateTransactions({
    required List<TranscationModel> transactions,
    required double totalBalance,
    required double totalIncome,
    required double totalExpense,
  }) {
    // Optimization: Skip update if data hasn't changed
    if (_transactions == transactions &&
        _totalBalance == totalBalance &&
        _totalIncome == totalIncome &&
        _totalExpense == totalExpense) {
      return;
    }

    _transactions = transactions;

    // Use pre-calculated global totals from TransactionProvider
    _totalBalance = totalBalance;
    _totalIncome = totalIncome;
    _totalExpense = totalExpense;

    // These are still month-specific, so we calculate them once here
    _thisMonthBalance = calculateThisMonth.getThisMonthBalance(_transactions);
    _thisMonthIncome = calculateThisMonth.getThisMonthIncome(_transactions);
    _thisMonthExpense = calculateThisMonth.getThisMonthExpense(_transactions);

    _previousMonthIncome =
        calculateThisMonth.getPreviousMonthIncome(_transactions);
    _previousMonthExpense =
        calculateThisMonth.getPreviousMonthExpense(_transactions);

    // Pre-calculate top categories for L-shape widgets
    _topIncomeCategories = getTopCategoriesUseCase.getTopCategories(
      _transactions,
      'Income',
    );
    _topExpenseCategories = getTopCategoriesUseCase.getTopCategories(
      _transactions,
      'Expense',
    );

    _generateInsight();
    _checkBudgetAlerts();
    notifyListeners();
  }

  void updateNotificationProvider(NotificationProvider notificationProvider) {
    _notificationProvider = notificationProvider;
  }

  void _checkBudgetAlerts() {
    if (_notificationProvider != null && _budget > 0) {
      _notificationProvider!.triggerBudgetAlert(thisMonthExpense, _budget);
    }
  }

  void toggleThisMonth(bool value) {
    _isThisMonth = value;
    notifyListeners();
  }

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
