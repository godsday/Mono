import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mono/database/categories_DB/category_db.dart';
import 'package:mono/features/transaction/presentation/transcation_screen/transcation_widgets/heading_widget.dart';
import 'package:mono/models/category_model/category_model.dart';
import 'package:mono/features/transaction/data/models/transcation_model.dart';
import '../../domain/usecases/add_transaction.dart';
import '../../domain/usecases/delete_transaction.dart';
import '../../domain/usecases/get_transactions.dart';
import '../../domain/usecases/update_transaction.dart';

class TransactionProvider with ChangeNotifier {
  final GetTransactions getTransactionsUseCase;
  final AddTransaction addTransactionUseCase;
  final DeleteTransaction deleteTransactionUseCase;
  final UpdateTransaction updateTransactionUseCase;

  List<TranscationModel> _transactions = [];
  bool _isLoading = false;
  String? _error;

  TransactionProvider({
    required this.getTransactionsUseCase,
    required this.addTransactionUseCase,
    required this.deleteTransactionUseCase,
    required this.updateTransactionUseCase,
  });
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
      ..sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(5).toList();
  }

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

  Future<void> addTransaction(TranscationModel transaction) async {
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

  Future<void> updateTransaction(TranscationModel transaction) async {
    try {
      await updateTransactionUseCase(transaction);
      await loadTransactions();
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

  double _totalBalance = 0;
  double _totalIncome = 0;
  double _totalExpense = 0;

  double get totalBalance => _totalBalance;
  set totalBalance(double value) {
    _totalBalance = value;
    notifyListeners();
  }

  double get totalIncome => _totalIncome;
  set totalIncome(double value) {
    _totalIncome = value;
    notifyListeners();
  }

  double get totalExpense => _totalExpense;
  set totalExpense(double value) {
    _totalExpense = value;
    notifyListeners();
  }

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

  headinginnermethod() {
    if (itemvalue == "Income") {
      return HeadingMethod(
          headtext: 'My savings', amount: totalIncome.toStringAsFixed(1));
    } else if (itemvalue == 'Expense') {
      return HeadingMethod(
          headtext: ' My spendings', amount: totalExpense.toStringAsFixed(1));
    } else if (itemvalue == 'Today') {
      double todayTotal = calculateTotalForList(todaylistnotifier);
      return HeadingMethod(
          headtext: 'Today', amount: todayTotal.toStringAsFixed(1));
    } else if (itemvalue == 'Yesterday') {
      return HeadingMethod(headtext: 'Yesterday');
    } else if (itemvalue == 'Weekly') {
      double weeklyTotal = calculateTotalForList(weeklylistnotifier);
      return HeadingMethod(
          headtext: 'This Week', amount: weeklyTotal.toStringAsFixed(1));
    } else if (itemvalue == 'Monthly') {
      double monthlyTotal = calculateTotalForList(monthlylistnotifier);
      return HeadingMethod(
          headtext: 'This Month', amount: monthlyTotal.toStringAsFixed(1));
    } else if (itemvalue == 'Custom') {
      return HeadingMethod(headtext: 'Custom');
    } else {
      return HeadingMethod(
          headtext: 'All Transcations',
          amount: totalBalance.toStringAsFixed(1));
    }
  }

  double calculateTotalForList(ValueNotifier<List<TranscationModel>> list) {
    double total = 0;
    for (var transaction in list.value) {
      if (transaction.type == 'Income') {
        total += transaction.amount;
      } else if (transaction.type == 'Expense') {
        total -= transaction.amount;
      }
    }
    return total;
  }

  double calculateIncomeForList(ValueNotifier<List<TranscationModel>> list) {
    double total = 0;
    for (var transaction in list.value) {
      if (transaction.type == 'Income') {
        total += transaction.amount;
      }
    }
    return total;
  }

  double calculateExpenseForList(ValueNotifier<List<TranscationModel>> list) {
    double total = 0;
    for (var transaction in list.value) {
      if (transaction.type == 'Expense') {
        total += transaction.amount;
      }
    }
    return total;
  }

  Future<void> loadCategories() async {
    _allCategories = await CategoryDB.instance.getCategories();
    notifyListeners();
  }

  Future<void> refresh() async {
    // final list = await TranscationDB.instance.getalltranscation();

    // totalBalanceCheck(list);

    _transactions.sort((first, second) => second.date.compareTo(first.date));
    yesterdaylistnotifier.value.clear();
    transcationNotifier.value.clear();
    incomelistnotifier.value.clear();
    expenselistnotifier.value.clear();
    todaylistnotifier.value.clear();
    // spendingCycleListNotifier.value.clear();
    weeklylistnotifier.value.clear();
    monthlylistnotifier.value.clear();

    transcationNotifier.value.addAll(_transactions);

    final today = DateFormat().add_yMMMMd().format(DateTime.now());
    final yesterday = DateFormat()
        .add_yMMMMd()
        .format(DateTime.now().subtract(const Duration(days: 1)));

    Future.forEach(_transactions, (TranscationModel transcationlist) {
      final dates = DateFormat().add_yMMMMd().format(transcationlist.date);
      if (transcationlist.type == 'Expense') {
        expenselistnotifier.value.add(transcationlist);
      } else {
        incomelistnotifier.value.add(transcationlist);
      }

      if (dates == today) {
        todaylistnotifier.value.add(transcationlist);
      } else if (dates == yesterday) {
        yesterdaylistnotifier.value.add(transcationlist);
      }

      // Add to weekly list (last 7 days)
      if (transcationlist.date
          .isAfter(DateTime.now().subtract(const Duration(days: 7)))) {
        weeklylistnotifier.value.add(transcationlist);
      }

      // Add to monthly list (current month)
      if (transcationlist.date.month == DateTime.now().month &&
          transcationlist.date.year == DateTime.now().year) {
        monthlylistnotifier.value.add(transcationlist);
      }
    });

    // Calculate top categories
    // calculateTopCategories(list);

    // yesterdaylistnotifier.notifyListeners();
    // transcationNotifier.notifyListeners();
    // expenselistnotifier.notifyListeners();
    // incomelistnotifier.notifyListeners();
    // todaylistnotifier.notifyListeners();
  }
}
