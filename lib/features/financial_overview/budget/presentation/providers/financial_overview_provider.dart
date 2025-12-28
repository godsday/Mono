import 'package:flutter/material.dart';
import '../../domain/entities/budget_entity.dart';
import '../../domain/usecases/get_current_month_budget_usecase.dart';

class FinancialOverviewProvider extends ChangeNotifier {
  final GetCurrentMonthBudgetUseCase getBudgetUseCase;

  BudgetEntity? _budget;
  bool _isFirstTimeUser = true;
  bool _isLoading = false;

  FinancialOverviewProvider({
    required this.getBudgetUseCase,
  });

  BudgetEntity? get budget => _budget;
  bool get isFirstTimeUser => _isFirstTimeUser;
  bool get isLoading => _isLoading;
  bool get hasBudget => _budget != null;

  Future<void> loadBudget() async {
    _isLoading = true;
    notifyListeners();

    try {
      _budget = await getBudgetUseCase();

      if (_budget == null) {
        _isFirstTimeUser = true;
      } else {
        _isFirstTimeUser = false;
      }
    } catch (e) {
      // Handle error, maybe log it
      _budget = null;
      _isFirstTimeUser = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
