import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

      // Filter transactions for current month, Expense type
      final List<TranscationModel> currentMonthExpenses =
          transactions.where((t) {
        final bool isSameMonth =
            t.date.year == now.year && t.date.month == now.month;
        final bool isExpense = t.type == 'Expense';
        return isSameMonth && isExpense;
      }).toList();

      double totalSpent = 0.0;
      double othersSpent = 0.0;
      final Map<String, double> categorySpent = {};

      for (var exp in currentMonthExpenses) {
        totalSpent += exp.amount;
        bool matched = false;

        for (var cat in _budget!.categories) {
          if (cat.id == exp.category ||
              cat.name.toLowerCase() == exp.category.toLowerCase()) {
            categorySpent[cat.id] = (categorySpent[cat.id] ?? 0.0) + exp.amount;
            matched = true;
            break;
          }
        }

        if (!matched) {
          othersSpent += exp.amount;
        }
      }

      final List<BudgetCategoryEntity> updatedCategories =
          _budget!.categories.map((c) {
        return BudgetCategoryEntity(
          id: c.id,
          name: c.name,
          amount: c.amount,
          spentAmount: categorySpent[c.id] ?? 0.0,
        );
      }).toList();

      if (othersSpent > 0) {
        updatedCategories.add(BudgetCategoryEntity(
          id: 'others',
          name: 'Others',
          amount: 0.0,
          spentAmount: othersSpent,
        ));
      }

      // Update BudgetEntity with calculated spent amount
      final monthKey = DateFormat('MMM yyyy').format(DateTime.now());
      _budget = BudgetEntity(
        month: monthKey,
        totalBudget: _budget!.totalBudget,
        spentAmount: totalSpent,
        remainingAmount: _budget!.totalBudget - totalSpent,
        categories: updatedCategories,
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
