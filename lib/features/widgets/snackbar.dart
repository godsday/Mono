import 'package:flutter/material.dart';
import 'package:mono/core/constants/app_textstyle/app_textstyle.dart';
import 'package:mono/core/theme/app_theme.dart';

SnackBar customSnack(BuildContext context, {required message}) {
  return SnackBar(
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      duration: const Duration(milliseconds: 1500),
      content: Text(
        message,
        style: AppTextStyles.poppins15w400(context)!.copyWith(
            color: Theme.of(context).extension<AppGradients>()!.textTheme,
            fontWeight: FontWeight.w600),
      ));
}
