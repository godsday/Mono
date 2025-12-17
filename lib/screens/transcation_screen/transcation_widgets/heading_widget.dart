import 'package:flutter/material.dart';
import 'package:mono/constants/utils/app_textstyle.dart';
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
          style: AppTextStyles.roboto16w600Black,
        ),
        Text(
          amount!,
          style: AppTextStyles.roboto16w600Black,
        )
      ],
    );
  }
}
