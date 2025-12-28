import 'package:flutter/material.dart';
import '../../../../../database/categories_DB/category_db.dart';
import '../../../../../models/category_model/category_model.dart';
import '../../domain/usecases/save_monthly_budget_usecase.dart';

class AddBudgetProvider extends ChangeNotifier {
  final SaveMonthlyBudgetUseCase saveBudgetUseCase;

  double _totalBudget = 0;
  final Map<String, double> _categoryBudgets = {};
  List<CategoryModel> _availableCategories = [];
  bool _isLoading = false;

  AddBudgetProvider({required this.saveBudgetUseCase}) {
    _loadCategories();
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
