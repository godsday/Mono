import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/constants/colors/app_colors.dart';

class IncomeExpenseCard extends StatelessWidget {
  final String transactionType;
  final double value;

  const IncomeExpenseCard({
    super.key,
    required this.transactionType,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    bool isIncome = transactionType == "Earnings";

    return Container(
      decoration: BoxDecoration(
        color: isIncome
            ? AppColor.mainHexcolor
            : const Color.fromARGB(255, 105, 55, 55),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.1.w, vertical: 1.5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withValues(alpha: 0.2), // Fixed deprecated withOpacity
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                SizedBox(width: 2.w),
                Text(
                  transactionType,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
            AutoSizeText(
              '₹ ${value.toStringAsFixed(0)}',
              maxLines: 1,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
