import 'package:mono/database/categories_DB/category_db.dart';
import 'package:mono/models/category_model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mono/routes/route_names.dart';
import '../database/Transctions_DB/transcations_db.dart';
import '../features/transaction/presentation/transcation_screen/transcation_widgets/heading_widget.dart';
import '../models/transcation_model/transcation_model.dart';
import '../core/widgets/snackbar.dart';
import '../models/top_category_model.dart';

class AppState extends ChangeNotifier {
  ValueNotifier<List<TranscationModel>> transcationNotifier = ValueNotifier([]);
  ValueNotifier<List<TranscationModel>> incomelistnotifier = ValueNotifier([]);
  ValueNotifier<List<TranscationModel>> expenselistnotifier = ValueNotifier([]);
  ValueNotifier<List<TranscationModel>> todaylistnotifier = ValueNotifier([]);
  ValueNotifier<List<TranscationModel>> yesterdaylistnotifier =
      ValueNotifier([]);
  ValueNotifier<List<TranscationModel>> customlistnotifier = ValueNotifier([]);
  ValueNotifier<List<TranscationModel>> spendingCycleListNotifier =
      ValueNotifier([]);
  ValueNotifier<List<TranscationModel>> weeklylistnotifier = ValueNotifier([]);
  ValueNotifier<List<TranscationModel>> monthlylistnotifier = ValueNotifier([]);

  // Top categories data
  List<TopCategory> topIncomeCategories = [];
  List<TopCategory> topExpenseCategories = [];

  DateTimeRange? dateRange;
  DateTime start = DateTime.now().subtract(const Duration(days: 3));
  DateTime end = DateTime.now();
  bool isThisMonth = false;
  List<TranscationModel> _list = [];
  List<CategoryModel> _allCategories = [];
  List<CategoryModel> get allCategories => _allCategories;

  //todo Check Flight mode

  bool _isFilghtMode = false;
  bool get isFilghtMode => _isFilghtMode;

  set isFilghtMode(bool value) {
    _isFilghtMode = value;
    notifyListeners();
  }

  // Getters & Setters

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

  DateTime _selectedDate = DateTime.now();
  dynamic get selectedDate => _selectedDate;
  set selectedDate(dynamic value) {
    _selectedDate = value;
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

  // Date Range picker

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

  Future addtransbutton(context, amountcontrol, notescontrol) async {
    final amountval = amountcontrol.text;
    final purposeval = notescontrol.text;

    final parseamount = double.tryParse(amountval);
    print("number $parseamount");
    if (parseamount == null || parseamount == 0 || parseamount.isNegative) {
      final snack = customSnak(context, message: "Enter valid number");
      return ScaffoldMessenger.of(context).showSnackBar(snack);
    }

    // Check if category is selected
    if (categorySelected == null || categorySelected!.isEmpty) {
      final snack = customSnak(context, message: "Please select a category");
      return ScaffoldMessenger.of(context).showSnackBar(snack);
    }

    final model = TranscationModel(
        type: selectedType,
        amount: parseamount,
        date: selectedDate,
        category: categorySelected!,
        purpose: purposeval,
        id: DateTime.now().millisecondsSinceEpoch.toString());
    TranscationDB.instance.addtranscation(model);

    _list = await TranscationDB.instance.getalltranscation();

    totalBalanceCheck(_list);
    Navigator.pushReplacementNamed(context, RouteNames.home);
  }

  /* listingmethod() {
    if (itemvalue == "Income") {
      return incomelistnotifier;
    } else if (itemvalue == "Expense") {
      return expenselistnotifier;
    } else if (itemvalue == "Today") {
      return todaylistnotifier;
    } else if (itemvalue == "Yesterday") {
      return yesterdaylistnotifier;
    } else if (itemvalue == "Custom") {
      return customlistnotifier;
    } else {
      return transcationNotifier;
    }
  }*/

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
      case "Spending Cycle":
        return spendingCycleListNotifier;
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

  void totalBalanceCheck(List<TranscationModel> data) {
    double income = 0;
    double expense = 0;

    for (var value in data) {
      if (value.type == "Income") {
        income += value.amount;
      } else if (value.type == 'Expense') {
        expense += value.amount;
      }
    }

    _totalIncome = income;
    _totalExpense = expense;
    _totalBalance = income - expense;

    notifyListeners();

    print("Total Balance: $_totalBalance");
    print("Total Income: $_totalIncome");
    print("Total Expense: $_totalExpense");
  }

  Future<void> refresh() async {
    final list = await TranscationDB.instance.getalltranscation();

    totalBalanceCheck(list);

    list.sort((first, second) => second.date.compareTo(first.date));
    yesterdaylistnotifier.value.clear();
    transcationNotifier.value.clear();
    incomelistnotifier.value.clear();
    expenselistnotifier.value.clear();
    todaylistnotifier.value.clear();
    spendingCycleListNotifier.value.clear();
    weeklylistnotifier.value.clear();
    monthlylistnotifier.value.clear();

    transcationNotifier.value.addAll(list);

    final today = DateFormat().add_yMMMMd().format(DateTime.now());
    final yesterday = DateFormat()
        .add_yMMMMd()
        .format(DateTime.now().subtract(const Duration(days: 1)));

    Future.forEach(list, (TranscationModel transcationlist) {
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
    calculateTopCategories(list);

    // yesterdaylistnotifier.notifyListeners();
    // transcationNotifier.notifyListeners();
    // expenselistnotifier.notifyListeners();
    // incomelistnotifier.notifyListeners();
    // todaylistnotifier.notifyListeners();
  }

  void calculateTopCategories(List<TranscationModel> transactions) {
    // Clear previous data
    topIncomeCategories.clear();
    topExpenseCategories.clear();

    // Maps to store category totals
    Map<String, double> incomeCategoryTotals = {};
    Map<String, double> expenseCategoryTotals = {};

    // Calculate totals for each category
    for (var transaction in transactions) {
      if (transaction.type == 'Income') {
        if (incomeCategoryTotals.containsKey(transaction.category)) {
          incomeCategoryTotals[transaction.category] =
              incomeCategoryTotals[transaction.category]! + transaction.amount;
        } else {
          incomeCategoryTotals[transaction.category] = transaction.amount;
        }
      } else if (transaction.type == 'Expense') {
        if (expenseCategoryTotals.containsKey(transaction.category)) {
          expenseCategoryTotals[transaction.category] =
              expenseCategoryTotals[transaction.category]! + transaction.amount;
        } else {
          expenseCategoryTotals[transaction.category] = transaction.amount;
        }
      }
    }

    // Convert maps to lists and sort by amount (descending)
    List<MapEntry<String, double>> sortedIncomeCategories =
        incomeCategoryTotals.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    List<MapEntry<String, double>> sortedExpenseCategories =
        expenseCategoryTotals.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    // Calculate total amounts for percentage calculation
    double totalIncome =
        sortedIncomeCategories.fold(0, (sum, entry) => sum + entry.value);
    double totalExpense =
        sortedExpenseCategories.fold(0, (sum, entry) => sum + entry.value);

    // Take top 3 categories for each type
    int incomeCount =
        sortedIncomeCategories.length > 3 ? 3 : sortedIncomeCategories.length;
    int expenseCount =
        sortedExpenseCategories.length > 3 ? 3 : sortedExpenseCategories.length;

    // Create TopCategory objects for income
    for (int i = 0; i < incomeCount; i++) {
      var entry = sortedIncomeCategories[i];
      double percentage =
          totalIncome > 0 ? (entry.value / totalIncome) * 100 : 0;
      topIncomeCategories.add(TopCategory(
        name: entry.key,
        amount: entry.value,
        percentage: percentage,
      ));
    }

    // Create TopCategory objects for expense
    for (int i = 0; i < expenseCount; i++) {
      var entry = sortedExpenseCategories[i];
      double percentage =
          totalExpense > 0 ? (entry.value / totalExpense) * 100 : 0;
      topExpenseCategories.add(TopCategory(
        name: entry.key,
        amount: entry.value,
        percentage: percentage,
      ));
    }

    notifyListeners();
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
  /*void custompick(DateTime start, DateTime end) {
  customlistnotifier.value.clear();

  for (TranscationModel data in transcationNotifier.value) {
    if (data.date.isAfter(start.subtract(const Duration(days: 1))) &&
        data.date.isBefore(end.add(const Duration(days: 1)))) {
      customlistnotifier.value.add(data);
    }
  }

  customlistnotifier.notifyListeners();
}*/

  // Monthy cycle

  void filterLast31Days() {
    // spendingCycleListNotifier.value.clear();
    DateTime today = DateTime.now();
    DateTime cycleStart =
        today.subtract(const Duration(days: 30)); // 31 days including today

    List<TranscationModel> filtered = transcationNotifier.value.where((tx) {
      return tx.date.isAfter(cycleStart.subtract(const Duration(days: 1))) &&
          tx.date.isBefore(today.add(const Duration(days: 1)));
    }).toList();

    spendingCycleListNotifier.value = filtered;
    spendingCycleListNotifier.notifyListeners();
  }

  String getSpendingCycleLabel() {
    final today = DateTime.now();
    final start = today.subtract(const Duration(days: 30));
    final formatter = DateFormat('MMM dd'); // Example: Jun 12

    return 'Spending Cycle: ${formatter.format(start)} – ${formatter.format(today)}';
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

  thisMonthSwitch(bool value) async {
    isThisMonth = !isThisMonth;
    print('isThisMonth $isThisMonth');
    if (isThisMonth) {
      filterLast31Days();
      getSpendingCycleLabel();
      totalBalanceCheck(spendingCycleListNotifier.value);
    } else {
      _list = await TranscationDB.instance.getalltranscation();
      totalBalanceCheck(_list);
    }
    notifyListeners();
  }

  Future<void> loadCategories() async {
    _allCategories = await CategoryDB.instance.getCategories();
    notifyListeners();
  }
}
