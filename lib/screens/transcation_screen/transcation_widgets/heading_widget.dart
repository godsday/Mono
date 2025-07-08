import 'package:flutter/material.dart';
import 'package:mono/utils/app_textstyle.dart';
import 'package:sizer/sizer.dart';

// ignore: must_be_immutable
class HeadingMethod extends StatelessWidget {
  String headtext;
  String? amount;
  HeadingMethod({Key? key, required this.headtext, this.amount = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
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
