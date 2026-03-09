import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mono/core/theme/app_theme.dart';
import 'package:sizer/sizer.dart';
import 'package:mono/core/utils/extension/context_extension.dart';

class IncomeExpenseCard extends StatelessWidget {
  final String transactionType;
  final double value;
  final bool isIncome;

  const IncomeExpenseCard({
    super.key,
    required this.transactionType,
    required this.value,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradients = theme.extension<AppGradients>()!;

    return Container(
      decoration: BoxDecoration(
        color:
            isIncome ? gradients.incomeContainer : gradients.expenseContainer,
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
              context.formatCurrency(value),
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
