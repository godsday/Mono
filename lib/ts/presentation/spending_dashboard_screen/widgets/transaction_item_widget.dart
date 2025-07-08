import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_image_view.dart';
import '../models/transaction_item_model.dart';

class TransactionItemWidget extends StatelessWidget {
  final TransactionItemModel transaction;

  const TransactionItemWidget({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: appTheme.black,
        borderRadius: BorderRadius.circular(12.h),
        boxShadow: [
          BoxShadow(
            color: appTheme.blackCustom.withAlpha(13),
            blurRadius: 4.h,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.h),
      child: Row(
        children: [
          Container(
            width: 64.h,
            height: 64.h,
            decoration: BoxDecoration(
              color: transaction.backgroundColor,
              borderRadius: BorderRadius.circular(16.h),
            ),
            child: Center(
              child: CustomImageView(
                imagePath: transaction.icon ?? '',
                height: 32.h,
                width: 32.h,
              ),
            ),
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title ?? '',
                  style: TextStyleHelper.instance.title16SemiBold.copyWith(
                    color: appTheme.colorFF1F29,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  transaction.date ?? '',
                  style: TextStyleHelper.instance.body12.copyWith(
                    color: appTheme.colorFF1F29,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '- ${transaction.amount ?? ''}',
            style: TextStyleHelper.instance.title16SemiBold.copyWith(
              color: appTheme.colorFFEF44,
            ),
          ),
        ],
      ),
    );
  }
}
