import 'package:flutter/material.dart';
import 'package:mono/core/constants/app_textstyle/app_textstyle.dart';
import 'package:mono/core/constants/colors/app_colors.dart';

SnackBar customSnak(BuildContext context, {required message}) {
  return SnackBar(
      backgroundColor: AppColor.mainHexcolor,
      duration: const Duration(milliseconds: 1500),
      content: Text(
        message,
        style: AppTextStyles.poppins15w400(context)!.copyWith(
            color: Theme.of(context).cardColor, fontWeight: FontWeight.w600),
      ));
}
