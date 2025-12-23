import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors/app_colors.dart';

SnackBar customSnak(BuildContext context, {required message}) {
  return SnackBar(
      backgroundColor: AppColor.mainHexcolor,
      duration: const Duration(milliseconds: 1500),
      content: Text(
        message,
        style: TextStyle(color: Theme.of(context).focusColor),
      ));
}
