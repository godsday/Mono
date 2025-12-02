import 'package:flutter/material.dart';
import 'package:mono/constants/colors/app_color.dart';

InputDecoration dropdowndecor() {
  return InputDecoration(
      isDense: false,
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.mainHexcolor, width: 1.0),
          borderRadius: BorderRadius.circular(4)),
      enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10)));
}

InputDecoration textfielddecor(String text) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppColor.mainHexcolor, width: 1.0)),
    hintText: text,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  );
}

Text textstyle(String text) {
  return Text(
    text,
    style: const TextStyle(
        fontWeight: FontWeight.bold, color: Color.fromARGB(255, 116, 112, 112)),
  );
}
