import 'dart:async';
import 'package:flutter/material.dart';

import '../../../../transaction/data/models/transcation_model.dart';
import '../../../asset/domain/entities/asset_entity.dart';
import '../../../budget/domain/entities/budget_entity.dart';
import '../../../goals/domain/entities/goal_entity.dart';

import '../../domain/entities/ai_insight_data.dart';
import '../../domain/entities/budget_discipline_data.dart';
import '../../domain/entities/financial_health_data.dart';
import '../../domain/entities/goal_analytics_data.dart';
import '../../domain/entities/net_worth_data.dart';
import '../../domain/entities/volatility_data.dart';

import '../../domain/usecases/calculate_asset_allocation_usecase.dart';
import '../../domain/usecases/calculate_budget_discipline_usecase.dart';
import '../../domain/usecases/calculate_expense_trend_usecase.dart';
import '../../domain/usecases/calculate_financial_health_usecase.dart';
import '../../domain/usecases/calculate_goal_analytics_usecase.dart';
import '../../domain/usecases/calculate_net_worth_usecase.dart';
import '../../domain/usecases/calculate_savings_rate_usecase.dart';
import '../../domain/usecases/calculate_volatility_usecase.dart';
import '../../domain/usecases/generate_ai_insights_usecase.dart';
import '../../domain/usecases/project_future_expense_usecase.dart';

class WealthAnalyticsProvider extends ChangeNotifier {
  bool isLoading = true;
  String? error;

  // Raw data dependencies (you'd typically listen to these from other providers or repositories)
  List<TranscationModel> _transactions = [];
  List<AssetEntity> _assets = [];
  List<GoalEntity> _goals = [];
  List<BudgetEntity> _budgets = [];

  // Computed state
  NetWorthData? netWorthData;
  Map<String, double>? assetAllocation;
  GoalAnalyticsData? goalAnalytics;
  double? savingsRate;
  BudgetDisciplineData? budgetDiscipline;
  VolatilityData? volatility;
  Map<String, double>? expenseTrend;
  double? futureProjection;
  FinancialHealthData? financialHealth;
  AiInsightData? currentAiInsight;
  List<AiInsightData> _allInsights = [];
  Timer? _insightTimer;
  int _currentInsightIndex = 0;

  // Use Cases
  final CalculateNetWorthUseCase _calcNetWorth = CalculateNetWorthUseCase();
  final CalculateAssetAllocationUseCase _calcAssetAllocation =
      CalculateAssetAllocationUseCase();
  final CalculateGoalAnalyticsUseCase _calcGoalAnalytics =
      CalculateGoalAnalyticsUseCase();
  final CalculateSavingsRateUseCase _calcSavingsRate =
      CalculateSavingsRateUseCase();
  final CalculateBudgetDisciplineUseCase _calcBudgetDiscipline =
      CalculateBudgetDisciplineUseCase();
  final CalculateVolatilityUseCase _calcVolatility =
      CalculateVolatilityUseCase();
  final CalculateExpenseTrendUseCase _calcExpenseTrend =
      CalculateExpenseTrendUseCase();
  final CalculateFinancialHealthUseCase _calcHealth =
      CalculateFinancialHealthUseCase();
  final GenerateAiInsightsUseCase _generateInsights =
      GenerateAiInsightsUseCase();
  final ProjectFutureExpenseUseCase _projectFutureExpense =
      ProjectFutureExpenseUseCase();

  // Load data method to trigger calculations
  Future<void> loadData({
    required List<TranscationModel> transactions,
    // required List<AssetEntity> assets,
    // required List<GoalEntity> goals,
    required List<BudgetEntity> budgets,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      _transactions = transactions;
      // _assets = assets;
      // _goals = goals;
      _budgets = budgets;

      if (_transactions.isEmpty && _assets.isEmpty && _goals.isEmpty) {
        // Handle empty state gracefully
        netWorthData = null;
        isLoading = false;
        notifyListeners();
        return;
      }

      // Execute calculations
      netWorthData =
          _calcNetWorth(assets: _assets, transactions: _transactions);
      assetAllocation = _calcAssetAllocation(_assets);
      savingsRate = _calcSavingsRate(_transactions);
      budgetDiscipline = _calcBudgetDiscipline(_budgets, _transactions);
      volatility = _calcVolatility(_transactions);
      expenseTrend = _calcExpenseTrend(_transactions);
      futureProjection = _projectFutureExpense(expenseTrend ?? {});

      // For goal analytics, calculate average monthly savings from expense trend
      double totalExpenses =
          expenseTrend!.values.fold(0, (sum, val) => sum + val);
      double avgExpenses =
          expenseTrend!.isEmpty ? 0 : totalExpenses / expenseTrend!.length;
      // In a real app we'd need average income to get average savings. We will approximate it.
      // For now, let's just pass savingsRate * avgIncome.
      double recentIncome = 0; // Find income for current month
      DateTime now = DateTime.now();
      for (var t in _transactions) {
        if (t.date.year == now.year &&
            t.date.month == now.month &&
            t.type.toLowerCase() == 'income') {
          recentIncome += t.amount;
        }
      }
      double currentMonthlySavings = recentIncome * ((savingsRate ?? 0) / 100);

      goalAnalytics = _calcGoalAnalytics(_goals, currentMonthlySavings);

      financialHealth = _calcHealth(
        savingsRate: savingsRate ?? 0,
        budgetDiscipline: budgetDiscipline!,
        goalAnalytics: goalAnalytics!,
        netWorthData: netWorthData!,
        volatilityData: volatility!,
      );

      // Extract liquid assets from allocations
      double liquidAssets = 0;
      if (assetAllocation != null) {
        // simple assumption: cash, bank, equivalents
        liquidAssets =
            assetAllocation?['Cash'] ?? 0; // adjust keys based on real app data
      }

      _allInsights = _generateInsights(
        savingsRate: savingsRate ?? 0,
        netWorth: netWorthData!,
        volatility: volatility!,
        budgetDiscipline: budgetDiscipline!,
        totalExpensesMonthlyAvg: avgExpenses,
        liquidAssets: liquidAssets,
      );

      _startInsightRotation();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  void _startInsightRotation() {
    _insightTimer?.cancel();
    if (_allInsights.isEmpty) return;

    _currentInsightIndex = 0;
    currentAiInsight = _allInsights[_currentInsightIndex];
    notifyListeners();

    _insightTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (_allInsights.length <= 1) {
        timer.cancel();
        return;
      }
      _currentInsightIndex = (_currentInsightIndex + 1) % _allInsights.length;
      currentAiInsight = _allInsights[_currentInsightIndex];
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _insightTimer?.cancel();
    super.dispose();
  }
}
