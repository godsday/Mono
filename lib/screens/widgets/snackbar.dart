import 'package:flutter/material.dart';
import 'package:mono/constants/app_color.dart';

SnackBar customSnak(BuildContext context, {required message}) {
  return SnackBar(
      backgroundColor: mainHexcolor,
      duration: const Duration(milliseconds: 1500),
      content: Text(
        message,
        style: TextStyle(color: Theme.of(context).focusColor),
      ));
}
