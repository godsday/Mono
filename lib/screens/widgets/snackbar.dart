import 'package:flutter/material.dart';

SnackBar customSnak(BuildContext context, {required message}) {
  return SnackBar(
      backgroundColor: Colors.black87,
      duration: const Duration(seconds: 1),
      content: Text(
        message,
        style: TextStyle(color: Theme.of(context).focusColor),
      ));
}
