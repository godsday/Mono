import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class TransactionItemModel {
  String? id;
  String? title;
  String? date;
  String? amount;
  String? icon;
  Color? backgroundColor;
  bool? isExpense;

  TransactionItemModel({
    this.id,
    this.title,
    this.date,
    this.amount,
    this.icon,
    this.backgroundColor,
    this.isExpense,
  }) {
    id = id ?? '';
    title = title ?? '';
    date = date ?? '';
    amount = amount ?? '';
    icon = icon ?? '';
    backgroundColor = backgroundColor ?? appTheme.greyCustom;
    isExpense = isExpense ?? true;
  }
}
