import 'package:flutter/material.dart';
import 'package:mono/core/constants/app_textstyle/app_textstyle.dart';
import 'package:mono/core/utils/extension/context_extension.dart';
import 'package:mono/core/theme/app_theme.dart';
import 'package:sizer/sizer.dart';

class HeadingMethod extends StatelessWidget {
  final String headtext;
  final double? amount;
  const HeadingMethod({super.key, required this.headtext, this.amount = 0.0});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          headtext,
          style: AppTextStyles.roboto16w600Black.copyWith(
              color: Theme.of(context).extension<AppGradients>()?.textTheme,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700),
        ),
        Text(
          context.formatCurrency(amount ?? 0),
          style: AppTextStyles.roboto16w600Black.copyWith(
              color: Theme.of(context).extension<AppGradients>()?.textTheme,
              fontSize: 16.5.sp,
              fontWeight: FontWeight.w700),
        )
      ],
    );
  }
}
