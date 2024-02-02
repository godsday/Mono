import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../database/Transctions_DB/transcations_db.dart';
import '../models/transcation_model/transcation_model.dart';
import '../screens/transcation_screen/transcation_screen.dart';
import '../screens/transcation_screen/transcation_widgets/heading_widget.dart';
import '../screens/widgets/bottomnavigationbar.dart';
import '../screens/widgets/snackbar.dart';

class AppState extends ChangeNotifier {
  bool _isFilghtMode = false;
  bool get isFilghtMode => _isFilghtMode;
  set isFilghtMode(bool value) {
    _isFilghtMode = value;
    notifyListeners();
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

  DateTime _selectedDate = DateTime.now();
  dynamic get selectedDate => _selectedDate;
  set selectedDate(dynamic value) {
    _selectedDate = value;
    notifyListeners();
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

  String? _categorySelected;
  String? get categorySelected => _categorySelected;
  set categorySelected(String? value) {
    _categorySelected = value;
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

  Future addtransbutton(context, amountcontrol, notescontrol) async {
    final amountval = amountcontrol.text;
    final purposeval = notescontrol.text;

    final parseamount = double.tryParse(amountval);
    print("number $parseamount");
    if (parseamount == null || parseamount == 0 || parseamount.isNegative) {
      final snack = customSnak(context, message: "Enter valid number");
      return ScaffoldMessenger.of(context).showSnackBar(snack);
    } else {
      totalBalance = parseamount;
    }
    // if (categoryid == null) {
    //   return;
    // }

    final model = TranscationModel(
        type: selectedType,
        amount: parseamount,
        date: selectedDate,
        category: categorySelected!,
        purpose: purposeval,
        id: DateTime.now().millisecondsSinceEpoch.toString());
    TranscationDB.instance.addtranscation(model);

    final _list = await TranscationDB.instance.getalltranscation();

    totalBalanceCheck(_list);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const BottomNavigator()));
  }

  headinginnermethod() {
    if (itemvalue == "Income") {
      return HeadingMethod(
          headtext: 'My savings', amount: totalIncome.toStringAsFixed(1));
    } else if (itemvalue == 'Expense') {
      return HeadingMethod(
          headtext: ' My spendings', amount: totalExpense.toStringAsFixed(1));
    } else if (itemvalue == 'Today') {
      return HeadingMethod(headtext: 'Today');
    } else if (itemvalue == 'Yesterday') {
      return HeadingMethod(headtext: 'Yesterday');
    } else if (itemvalue == 'Custom') {
      return HeadingMethod(headtext: 'Custom');
    } else {
      return HeadingMethod(
          headtext: 'All Transcations',
          amount: totalBalance.toStringAsFixed(1));
    }
  }

  void totalBalanceCheck(List<TranscationModel> data) {
    totalBalance = 0;
    totalIncome = 0;
    totalExpense = 0;
    for (var value in data) {
      if (value.type == "Income") {
        totalIncome = totalIncome + value.amount;
      }
      if (value.type == 'Expense') {
        totalExpense = totalExpense + value.amount;
      }
      totalBalance = totalIncome - totalExpense;
    }
    if (totalBalance < 0) {
      totalBalance = 0;
    }
    print("1 $totalBalance");
    print("2 $totalIncome");
    print("3 $totalExpense");
  }

  ValueNotifier<List<TranscationModel>> transcationNotifier = ValueNotifier([]);
  ValueNotifier<List<TranscationModel>> incomelistnotifier = ValueNotifier([]);
  ValueNotifier<List<TranscationModel>> expenselistnotifier = ValueNotifier([]);
  ValueNotifier<List<TranscationModel>> todaylistnotifier = ValueNotifier([]);
  ValueNotifier<List<TranscationModel>> yesterdaylistnotifier =
      ValueNotifier([]);
  ValueNotifier<List<TranscationModel>> customlistnotifier = ValueNotifier([]);

  Future<void> refresh() async {
    final _list = await TranscationDB.instance.getalltranscation();

    totalBalanceCheck(_list);

    _list.sort((first, second) => second.date.compareTo(first.date));
    yesterdaylistnotifier.value.clear();
    transcationNotifier.value.clear();
    incomelistnotifier.value.clear();
    expenselistnotifier.value.clear();
    todaylistnotifier.value.clear();

    transcationNotifier.value.addAll(_list);

    final _today = DateFormat().add_yMMMMd().format(DateTime.now());
    final _yesterday = DateFormat()
        .add_yMMMMd()
        .format(DateTime.now().subtract(const Duration(days: 1)));

    Future.forEach(_list, (TranscationModel transcationlist) {
      final _dates = DateFormat().add_yMMMMd().format(transcationlist.date);
      if (transcationlist.type == 'Expense') {
        expenselistnotifier.value.add(transcationlist);
      } else {
        incomelistnotifier.value.add(transcationlist);
      }

      if (_dates == _today) {
        todaylistnotifier.value.add(transcationlist);
      } else if (_dates == _yesterday) {
        yesterdaylistnotifier.value.add(transcationlist);
      }
    });

    // yesterdaylistnotifier.notifyListeners();
    // transcationNotifier.notifyListeners();
    // expenselistnotifier.notifyListeners();
    // incomelistnotifier.notifyListeners();
    // todaylistnotifier.notifyListeners();
  }

  custompick(DateTime start, DateTime end) {
    customlistnotifier.value.clear();

    for (TranscationModel data in transcationNotifier.value) {
      if ((data.date.day >= start.day) &&
          (data.date.day <= end.day) &&
          (data.date.month >= start.month) &&
          (data.date.month >= end.month) &&
          (data.date.year <= start.year) &&
          (data.date.year >= end.year)) {
        customlistnotifier.value.add(data);
      }
    }
    // customlistnotifier.notifyListeners();
  }

  listingmethod() {
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
  }

  String parsedate(DateTime date) {
    final date0 = DateFormat().add_MMMd().format(date);
    final splitdate = date0.split(" ");
    return '${splitdate.last}\n${splitdate.first}';
  }

  DateTimeRange? dateRange;
  DateTime start = DateTime.now().subtract(const Duration(days: 3));
  DateTime end = DateTime.now();

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
}
