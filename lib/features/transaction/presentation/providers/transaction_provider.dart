import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mono/features/add_screen/data/repositories/category_db.dart';
import 'package:mono/features/add_screen/data/models/category_model.dart';
import 'package:mono/features/transaction/domain/usecases/calcuate_total_income.dart';
import 'package:mono/features/transaction/domain/usecases/calculate_total_balance.dart';
import 'package:mono/features/transaction/domain/usecases/calculate_total_expense.dart';

import 'package:mono/features/transaction/data/models/transcation_model.dart';
import '../../domain/usecases/add_transaction.dart';
import '../../domain/usecases/delete_transaction.dart';
import '../../domain/usecases/get_transactions.dart';
import '../../domain/usecases/update_transaction.dart';
import '../../domain/usecases/group_transactions_by_date.dart';

class TransactionProvider with ChangeNotifier {
  final GetTransactions getTransactionsUseCase;
  final AddTransaction addTransactionUseCase;
  final DeleteTransaction deleteTransactionUseCase;
  final UpdateTransaction updateTransactionUseCase;
  final TotalBalanceUseCase totalBalanceUseCase;
  final TotalIncomeUseCase totalIncomeUseCase;
  final TotalExpenseUseCase totalExpenseUseCase;
  final GroupTransactionsByDateUseCase groupTransactionsUseCase;

  List<TranscationModel> _transactions = [];

  bool _isLoading = false;
  String? _error;
  bool _visible = false;

  TransactionProvider({
    required this.getTransactionsUseCase,
    required this.addTransactionUseCase,
    required this.deleteTransactionUseCase,
    required this.updateTransactionUseCase,
    required this.totalBalanceUseCase,
    required this.totalIncomeUseCase,
    required this.totalExpenseUseCase,
    required this.groupTransactionsUseCase,
  });

  // double get totalBalance => homeProvider.totalBalance;

  DateTimeRange? dateRange;
  DateTime start = DateTime.now().subtract(const Duration(days: 3));
  DateTime end = DateTime.now();
  // List<TranscationModel> _list = [];
  List<CategoryModel> _allCategories = [];

  List<CategoryModel> get allCategories => _allCategories;

  ValueNotifier<List<TranscationModel>> transcationNotifier = ValueNotifier([]);
  ValueNotifier<List<TranscationModel>> incomelistnotifier = ValueNotifier([]);
  ValueNotifier<List<TranscationModel>> expenselistnotifier = ValueNotifier([]);
  ValueNotifier<List<TranscationModel>> todaylistnotifier = ValueNotifier([]);
  ValueNotifier<List<TranscationModel>> yesterdaylistnotifier =
      ValueNotifier([]);
  ValueNotifier<List<TranscationModel>> customlistnotifier = ValueNotifier([]);

  ValueNotifier<List<TranscationModel>> weeklylistnotifier = ValueNotifier([]);
  ValueNotifier<List<TranscationModel>> monthlylistnotifier = ValueNotifier([]);

  List<TranscationModel> get transactions => _transactions;

  bool get isLoading => _isLoading;
  String? get error => _error;

  // Previous Month Logic for Comparison

  List<TranscationModel> get recentTransactions {
    final sorted = List<TranscationModel>.from(_transactions)
      ..sort((a, b) {
        int dateSort = b.date.compareTo(a.date);
        if (dateSort != 0) return dateSort;
        return b.id.compareTo(a.id); // Tie-breaker: latest ID first
      });
    return sorted.take(5).toList();
  }

  bool get visible => _visible;

  graphView() {
    _visible = !_visible;
    notifyListeners();
  }

  Future<void> loadTransactions() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _transactions = await getTransactionsUseCase();
      await refresh(); // Ensure data is sorted and categorized after loading
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTransaction(TranscationModel transaction) async {
    try {
      await addTransactionUseCase(transaction);
      // Optimistic update or reload
      await loadTransactions();
      await refresh();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      await deleteTransactionUseCase(id);
      await loadTransactions();
      await refresh();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateTransaction(TranscationModel transaction) async {
    try {
      await updateTransactionUseCase(transaction);
      await loadTransactions();
      await refresh();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  String _selectedType = "Expense";
  String get selectedType => _selectedType;
  set selectedType(String value) {
    _selectedType = value;
    notifyListeners();
  }

  String _itemvalue = 'All';
  String get itemvalue => _itemvalue;
  set itemvalue(String value) {
    _itemvalue = value;
    notifyListeners();
  }

  double get totalBalance => totalBalanceUseCase(_transactions);
  double get totalIncome => totalIncomeUseCase(_transactions);
  double get totalExpense => totalExpenseUseCase(_transactions);

  // set totalBalance(double value) {
  //   _totalBalance = value;
  //   notifyListeners();
  // }

  // double get totalIncome => _totalIncome;
  // set totalIncome(double value) {
  //   _totalIncome = totalIncomeUseCase(_transactions);
  //   notifyListeners();
  // }

  // double get totalExpense => _totalExpense;
  // set totalExpense(double value) {
  //   _totalExpense = totalExpenseUseCase(_transactions);
  //   notifyListeners();
  // }

  String? _categorySelected;
  String? get categorySelected => _categorySelected;
  set categorySelected(String? value) {
    _categorySelected = value;
    notifyListeners();
  }

  DateTime _selectedDate = DateTime.now();
  dynamic get selectedDate => _selectedDate;
  set selectedDate(dynamic value) {
    _selectedDate = value;
    notifyListeners();
  }

  String parsedate(DateTime date) {
    final date0 = DateFormat().add_MMMd().format(date);
    final splitdate = date0.split(" ");
    return '${splitdate.last} ${splitdate.first}';
  }

  showdatepicker(context) async {
    final newdateRange = await showDateRangePicker(
      context: context,
      initialDateRange: dateRange,
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );
    if (newdateRange == null) return;

    dateRange = newdateRange;
    start = dateRange!.start;
    end = dateRange!.end;

    custompick(start, end);
  }

  Future<DateTime?> pickDate(context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );

    if (selected != null && selected != _selectedDate) {
      _selectedDate = selected;
    }
    return _selectedDate;
  }

  custompick(DateTime start, DateTime end) {
    customlistnotifier.value.clear();

    // Normalize the start and end dates to compare only the date part (ignore time)
    final startDate = DateTime(start.year, start.month, start.day);
    final endDate = DateTime(end.year, end.month, end.day);

    for (TranscationModel data in transcationNotifier.value) {
      // Normalize the transaction date
      final transactionDate =
          DateTime(data.date.year, data.date.month, data.date.day);

      // Check if transaction date is within the selected range (inclusive)
      if (transactionDate
              .isAfter(startDate.subtract(const Duration(days: 1))) &&
          transactionDate.isBefore(endDate.add(const Duration(days: 1)))) {
        customlistnotifier.value.add(data);
      }
    }
    customlistnotifier.notifyListeners();
  }

  ValueNotifier<List<TranscationModel>> listingMethod() {
    switch (itemvalue) {
      case "Income":
        return incomelistnotifier;
      case "Expense":
        return expenselistnotifier;
      case "Today":
        return todaylistnotifier;
      case "Yesterday":
        return yesterdaylistnotifier;
      case "Weekly":
        return weeklylistnotifier;
      case "Monthly":
        return monthlylistnotifier;
      case "Custom":
        return customlistnotifier;
      // case "Spending Cycle":
      //   return spendingCycleListNotifier;
      default:
        return transcationNotifier;
    }
  }

  Map<String, List<TranscationModel>> get groupedTransactions {
    return groupTransactionsUseCase(listingMethod().value);
  }

  ({String title, double amount}) getHeadingData() {
    if (itemvalue == "Income") {
      return (title: 'Savings', amount: totalIncome);
    } else if (itemvalue == 'Expense') {
      return (title: 'Spendings', amount: totalExpense);
    } else if (itemvalue == 'Today') {
      double todayTotal = totalBalanceUseCase.call(todaylistnotifier.value);
      return (title: 'Today', amount: todayTotal);
    } else if (itemvalue == 'Yesterday') {
      return (title: 'Yesterday', amount: 0.0);
    } else if (itemvalue == 'Weekly') {
      double weeklyTotal = totalBalanceUseCase.call(weeklylistnotifier.value);
      return (title: 'This Week', amount: weeklyTotal);
    } else if (itemvalue == 'Monthly') {
      double monthlyTotal = totalBalanceUseCase.call(monthlylistnotifier.value);
      return (title: 'This Month', amount: monthlyTotal);
    } else if (itemvalue == 'Custom') {
      double customTotal = totalBalanceUseCase.call(customlistnotifier.value);
      return (title: 'Custom', amount: customTotal);
    } else {
      return (title: 'All Transcations', amount: totalBalance);
    }
  }

  Future<void> loadCategories() async {
    _allCategories = await CategoryDB.instance.getCategories();
    notifyListeners();
  }

  Future<void> refresh() async {
    // Strict sorting: Date first (desc), then ID (desc) as tie-breaker for same-time additions
    _transactions.sort((a, b) {
      int dateSort = b.date.compareTo(a.date);
      if (dateSort != 0) return dateSort;
      return b.id.compareTo(a.id);
    });

    // Clear all notifiers before repopulating
    transcationNotifier.value.clear();
    incomelistnotifier.value.clear();
    expenselistnotifier.value.clear();
    todaylistnotifier.value.clear();
    yesterdaylistnotifier.value.clear();
    weeklylistnotifier.value.clear();
    monthlylistnotifier.value.clear();

    // Populate the 'All' list
    transcationNotifier.value.addAll(_transactions);

    final todayStr = DateFormat().add_yMMMMd().format(DateTime.now());
    final yesterdayStr = DateFormat()
        .add_yMMMMd()
        .format(DateTime.now().subtract(const Duration(days: 1)));

    for (var transaction in _transactions) {
      final dateStr = DateFormat().add_yMMMMd().format(transaction.date);

      // Category Lists
      if (transaction.type == 'Expense') {
        expenselistnotifier.value.add(transaction);
      } else {
        incomelistnotifier.value.add(transaction);
      }

      // Today/Yesterday Filters
      if (dateStr == todayStr) {
        todaylistnotifier.value.add(transaction);
      } else if (dateStr == yesterdayStr) {
        yesterdaylistnotifier.value.add(transaction);
      }

      // Weekly (Last 7 days)
      if (transaction.date
          .isAfter(DateTime.now().subtract(const Duration(days: 7)))) {
        weeklylistnotifier.value.add(transaction);
      }

      // Monthly (Current Month)
      if (transaction.date.month == DateTime.now().month &&
          transaction.date.year == DateTime.now().year) {
        monthlylistnotifier.value.add(transaction);
      }
    }

    // Explicitly notify all listeners to ensure UI updates across all filters
    transcationNotifier.notifyListeners();
    incomelistnotifier.notifyListeners();
    expenselistnotifier.notifyListeners();
    todaylistnotifier.notifyListeners();
    yesterdaylistnotifier.notifyListeners();
    weeklylistnotifier.notifyListeners();
    monthlylistnotifier.notifyListeners();
    customlistnotifier.notifyListeners();
  }
}
