import 'package:flutter/material.dart';
import '../database/Transctions_DB/transcations_db.dart';
import '../models/transcation_model/transcation_model.dart';
import '../screens/widgets/bottomnavigationbar.dart';
import '../screens/widgets/snackbar.dart';

class AppState extends ChangeNotifier {
  String _selectedType = "Expense";
  String get selectedType => _selectedType;

  set selectedType(String value) {
    _selectedType = value;
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

  Future addtransbutton(context, amountcontrol, notescontrol) async {
    final amountval = amountcontrol.text;
    final purposeval = notescontrol.text;

    final parseamount = double.tryParse(amountval);
    print("number $parseamount");
    if (parseamount == null || parseamount == 0 || parseamount.isNegative) {
      final snack = customSnak(context, message: "Enter valid number");
      return ScaffoldMessenger.of(context).showSnackBar(snack);
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
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const BottomNavigator()));
  }
}
