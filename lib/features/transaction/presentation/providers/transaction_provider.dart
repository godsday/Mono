import 'package:flutter/material.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/usecases/add_transaction.dart';
import '../../domain/usecases/delete_transaction.dart';
import '../../domain/usecases/get_transactions.dart';
import '../../../../models/top_category_model.dart';
import '../../domain/usecases/update_transaction.dart';

class TransactionProvider with ChangeNotifier {
  final GetTransactions getTransactionsUseCase;
  final AddTransaction addTransactionUseCase;
  final DeleteTransaction deleteTransactionUseCase;
  final UpdateTransaction updateTransactionUseCase;

  List<TransactionEntity> _transactions = [];
  bool _isLoading = false;
  String? _error;

  TransactionProvider({
    required this.getTransactionsUseCase,
    required this.addTransactionUseCase,
    required this.deleteTransactionUseCase,
    required this.updateTransactionUseCase,
  });

  List<TransactionEntity> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  bool _isThisMonth = false;
  bool get isThisMonth => _isThisMonth;

  void toggleThisMonth(bool value) {
    _isThisMonth = value;
    notifyListeners();
  }

  List<TransactionEntity> get filteredTransactions {
    if (!_isThisMonth) return _transactions;
    final now = DateTime.now();
    return _transactions.where((t) {
      return t.date.month == now.month && t.date.year == now.year;
    }).toList();
  }

  String get spendingCycleLabel {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    // Simple label for now, can be enhanced
    return "Spending Cycle: ${start.day}/${start.month} - ${now.day}/${now.month}";
  }

  double get totalIncome => filteredTransactions
      .where((t) => t.type == 'Income')
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpense => filteredTransactions
      .where((t) => t.type == 'Expense')
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalBalance => totalIncome - totalExpense;

  // Previous Month Logic for Comparison
  List<TransactionEntity> get prevMonthTransactions {
    final now = DateTime.now();
    final prevMonthDate = DateTime(now.year, now.month - 1, 1);
    return _transactions.where((t) {
      return t.date.month == prevMonthDate.month &&
          t.date.year == prevMonthDate.year;
    }).toList();
  }

  double get prevMonthIncome => prevMonthTransactions
      .where((t) => t.type == 'Income')
      .fold(0.0, (sum, t) => sum + t.amount);

  double get prevMonthExpense => prevMonthTransactions
      .where((t) => t.type == 'Expense')
      .fold(0.0, (sum, t) => sum + t.amount);

  List<TransactionEntity> get recentTransactions {
    final sorted = List<TransactionEntity>.from(_transactions)
      ..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(5).toList();
  }

  List<TopCategory> getTopCategories(String type) {
    var categoryTotals = <String, double>{};
    double totalTypeAmount = 0;

    // Filter transactions by type and calculate totals
    var transactionsOfType =
        _transactions.where((t) => t.type == type).toList();
    for (var t in transactionsOfType) {
      categoryTotals[t.category] = (categoryTotals[t.category] ?? 0) + t.amount;
      totalTypeAmount += t.amount;
    }

    // Convert to TopCategory list
    var topCategories = categoryTotals.entries.map((entry) {
      return TopCategory(
        name: entry.key,
        amount: entry.value,
        percentage: totalTypeAmount > 0 ? (entry.value / totalTypeAmount) : 0,
      );
    }).toList();

    // Sort by amount descending
    topCategories.sort((a, b) => b.amount.compareTo(a.amount));

    return topCategories.take(3).toList();
  }

  List<TopCategory> get topIncomeCategories => getTopCategories('Income');
  List<TopCategory> get topExpenseCategories => getTopCategories('Expense');

  Future<void> loadTransactions() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _transactions = await getTransactionsUseCase();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTransaction(TransactionEntity transaction) async {
    try {
      await addTransactionUseCase(transaction);
      // Optimistic update or reload
      await loadTransactions();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await deleteTransactionUseCase(id);
      await loadTransactions();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateTransaction(TransactionEntity transaction) async {
    try {
      await updateTransactionUseCase(transaction);
      await loadTransactions();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
