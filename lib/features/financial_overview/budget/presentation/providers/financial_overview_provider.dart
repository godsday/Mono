import 'package:flutter/material.dart';
import 'package:mono/features/transaction/data/models/transcation_model.dart';
import '../../domain/entities/budget_entity.dart';
import '../../domain/usecases/get_current_month_budget_usecase.dart';
import '../../../../transaction/domain/usecases/get_transactions.dart';

class BudgetProvider extends ChangeNotifier {
  final GetCurrentMonthBudgetUseCase getBudgetUseCase;
  final GetTransactions getTransactions;

  BudgetEntity? _budget;
  // bool _isFirstTimeUser = true;
  bool _isLoading = false;

  BudgetProvider({
    required this.getBudgetUseCase,
    required this.getTransactions,
  });

  BudgetEntity? get budget => _budget;
  // bool get isFirstTimeUser => _isFirstTimeUser;
  bool get isLoading => _isLoading;
  bool get hasBudget => _budget != null;

  Future<void> loadBudget() async {
    _isLoading = true;
    notifyListeners();

    try {
      _budget = await getBudgetUseCase();
      if (_budget == null) return;

      // Sync expenses
      final transactions = await getTransactions();
      final now = DateTime.now();

      // Filter transactions for current month, Expense type, and matching categories
      final List<TranscationModel> currentMonthExpenses =
          transactions.where((t) {
        final bool isSameMonth =
            t.date.year == now.year && t.date.month == now.month;
        final bool isExpense = t.type == 'Expense';

        // Check if transaction category matches any budget category
        // Matching by ID or Name to be robust
        // final bool isBudgetCategory = _budget!.categories.any((c) =>
        //     c.id == t.category ||
        //     c.name.toLowerCase() == t.category.toLowerCase());

        return isSameMonth && isExpense;
      }).toList();

      final totalSpent =
          currentMonthExpenses.fold(0.0, (sum, t) => sum + t.amount);

      // Update BudgetEntity with calculated spent amount
      _budget = BudgetEntity(
        month: DateTime.now().month.toString(),
        totalBudget: _budget!.totalBudget,
        spentAmount: totalSpent,
        remainingAmount: _budget!.totalBudget - totalSpent,
        categories: _budget!.categories,
      );
      // }
    } catch (e) {
      // Handle error, maybe log it
      _budget = null;
      // _isFirstTimeUser = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
