import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../models/spending_dashboard_model.dart';
import '../models/transaction_item_model.dart';

class SpendingDashboardProvider extends ChangeNotifier {
  SpendingDashboardModel spendingDashboardModel = SpendingDashboardModel();

  int _selectedExpenseTab = 1;
  int _selectedTimePeriod = 1;

  List<TransactionItemModel> _todayTransactions = [];
  List<TransactionItemModel> _yesterdayTransactions = [];
  List<TransactionItemModel> _may13Transactions = [];

  int get selectedExpenseTab => _selectedExpenseTab;
  int get selectedTimePeriod => _selectedTimePeriod;
  List<TransactionItemModel> get todayTransactions => _todayTransactions;
  List<TransactionItemModel> get yesterdayTransactions =>
      _yesterdayTransactions;
  List<TransactionItemModel> get may13Transactions => _may13Transactions;

  void initialize() {
    _initializeTransactions();
  }

  void selectExpenseTab(int index) {
    _selectedExpenseTab = index;
    notifyListeners();
  }

  void selectTimePeriod(int index) {
    _selectedTimePeriod = index;
    notifyListeners();
  }

  void _initializeTransactions() {
    _todayTransactions = [
      TransactionItemModel(
        id: '1',
        title: 'Shopping',
        date: '10 jan 2022',
        amount: '₹500.0',
        icon: ImageConstant.imgBxsstore1,
        backgroundColor: appTheme.colorFF81B2,
        isExpense: true,
      ),
      TransactionItemModel(
        id: '2',
        title: 'Restaurant',
        date: '11 jan 2022',
        amount: '₹400.0',
        icon: ImageConstant.imgBxscoffee1,
        backgroundColor: appTheme.colorFF836F,
        isExpense: true,
      ),
      TransactionItemModel(
        id: '3',
        title: 'Transport',
        date: '12 jan 2022',
        amount: '₹100.0',
        icon: ImageConstant.imgBxsbus1,
        backgroundColor: appTheme.colorFF4288,
        isExpense: true,
      ),
    ];

    _yesterdayTransactions = [
      TransactionItemModel(
        id: '4',
        title: 'Shopping',
        date: '10 jan 2022',
        amount: '₹500.0',
        icon: ImageConstant.imgBxsstore1,
        backgroundColor: appTheme.colorFF81B2,
        isExpense: true,
      ),
      TransactionItemModel(
        id: '5',
        title: 'Restaurant',
        date: '11 jan 2022',
        amount: '₹400.0',
        icon: ImageConstant.imgBxscoffee1,
        backgroundColor: appTheme.colorFF836F,
        isExpense: true,
      ),
      TransactionItemModel(
        id: '6',
        title: 'Transport',
        date: '12 jan 2022',
        amount: '₹100.0',
        icon: ImageConstant.imgBxsbus1,
        backgroundColor: appTheme.colorFF4288,
        isExpense: true,
      ),
    ];

    _may13Transactions = [
      TransactionItemModel(
        id: '7',
        title: 'Shopping',
        date: '10 jan 2022',
        amount: '₹500.0',
        icon: ImageConstant.imgBxsstore1,
        backgroundColor: appTheme.colorFF81B2,
        isExpense: true,
      ),
      TransactionItemModel(
        id: '8',
        title: 'Restaurant',
        date: '11 jan 2022',
        amount: '₹400.0',
        icon: ImageConstant.imgBxscoffee1,
        backgroundColor: appTheme.colorFF836F,
        isExpense: true,
      ),
      TransactionItemModel(
        id: '9',
        title: 'Transport',
        date: '12 jan 2022',
        amount: '₹100.0',
        icon: ImageConstant.imgBxsbus1,
        backgroundColor: appTheme.colorFF4288,
        isExpense: true,
      ),
    ];
  }
}
