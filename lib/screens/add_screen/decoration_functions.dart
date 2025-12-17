import 'package:flutter/material.dart';
import 'package:mono/constants/colors/app_color.dart';
import 'package:mono/constants/utils/app_textstyle.dart';
import 'package:mono/constants/utils/app_texttheme.dart';
import 'package:sizer/sizer.dart';

InputDecoration dropdowndecor() {
  return InputDecoration(
      isDense: false,
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.mainHexcolor, width: 1.0),
          borderRadius: BorderRadius.circular(4)),
      enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(12)));
}

InputDecoration textfielddecor(String text) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 2.0),
    ),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: AppColor.mainHexcolor, width: 1.0)),
    hintText: text, hintStyle: AppTextStyles.montserrat18w600.copyWith(color: AppColor.textGrey, fontSize: 14,fontWeight: FontWeight.normal),
    
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  );
}

