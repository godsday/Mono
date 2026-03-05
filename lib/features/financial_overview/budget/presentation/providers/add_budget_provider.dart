import 'package:flutter/material.dart';
import 'package:mono/features/add_screen/data/models/category_model.dart';
import '../../../../add_screen/data/repositories/category_db.dart';
import '../../domain/usecases/save_monthly_budget_usecase.dart';
import '../../domain/entities/budget_entity.dart';

class AddBudgetProvider extends ChangeNotifier {
  final SaveMonthlyBudgetUseCase saveBudgetUseCase;

  double _totalBudget = 0;
  final Map<String, double> _categoryBudgets = {};
  List<CategoryModel> _availableCategories = [];
  dynamic existingCategory = [];
  bool _isLoading = false;

  double? isBudgetExist;
  Map<String, double>? budgetdata;

  AddBudgetProvider({required this.saveBudgetUseCase}) {
    _loadCategories();
  }

  void initBudget(BudgetEntity budget) {
    _totalBudget = budget.totalBudget;
    for (var cat in budget.categories) {
      _categoryBudgets[cat.id] = cat.amount;
    }
  }

  double get totalBudget => _totalBudget;
  Map<String, double> get categoryBudgets => _categoryBudgets;
  List<CategoryModel> get availableCategories => _availableCategories;
  bool get isLoading => _isLoading;

  double get allocatedAmount {
    return _categoryBudgets.values.fold(0, (sum, amount) => sum + amount);
  }

  double get remainingAmount => _totalBudget - allocatedAmount;

  bool get isValid {
    return _totalBudget > 0 && remainingAmount >= 0;
  }

  Future<void> _loadCategories() async {
    _isLoading = true;
    notifyListeners();

    // Fetch expense categories only
    final allCats = await CategoryDB.instance.getCategories();
    _availableCategories =
        allCats.where((c) => c.type == CategoryType.expense).toList();

    _isLoading = false;
    notifyListeners();
  }

  void updateTotalBudget(double amount) {
    _totalBudget = amount;
    print("object$_totalBudget");
    notifyListeners();
  }

  void updateCategoryBudget(String categoryId, double amount) {
    if (amount <= 0) {
      _categoryBudgets.remove(categoryId);
    } else {
      _categoryBudgets[categoryId] = amount;
    }
    notifyListeners();
  }

  Future<bool> saveBudget() async {
    if (!isValid) return false;

    _isLoading = true;
    notifyListeners();

    try {
      await saveBudgetUseCase(_totalBudget, _categoryBudgets);
      print("add provider $_totalBudget");
      if (_totalBudget != 0) {
        isBudgetExist = _totalBudget;
        existingCategory = _availableCategories;
      }
      return true;
    } catch (e) {
      debugPrint("Error saving budget: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
