import 'package:flutter/material.dart';
import 'package:mono/core/constants/app_textstyle/app_textstyle.dart';
import 'package:mono/core/constants/colors/app_colors.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class HeadingMethod extends StatelessWidget {
  String headtext;
  String? amount;
  HeadingMethod({super.key, required this.headtext, this.amount = ''});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          headtext,
          style: AppTextStyles.poppins18w500White(context)!.copyWith(
              color: AppColor.blackText,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700),
        ),
        Text(
          amount!,
          style: AppTextStyles.poppins18w500White(context)!.copyWith(
              color: AppColor.blackText,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700),
        )
      ],
    );
  }
}
