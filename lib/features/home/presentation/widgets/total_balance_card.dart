import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mono/core/constants/app_textstyle/app_textstyle.dart';
import 'package:mono/features/home/presentation/widgets/income_expense_card.dart';
import 'package:mono/features/transaction/presentation/providers/transaction_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/constants/colors/app_colors.dart';

class TotalBalanceCard extends StatelessWidget {
  const TotalBalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        return Container(
          height: 25.5.h,
          decoration: BoxDecoration(
            color: AppColor.totalBalanceCardBg,
            boxShadow: [
              BoxShadow(
                spreadRadius: 1.sp,
                blurRadius: 2.sp,
                color: AppColor.transparent,
              )
            ],
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 4.w, top: 1.6.h, right: 4.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total balance",
                          style: AppTextStyles.poppins18w500White(context),
                        ),
                        SizedBox(height: .5.h),
                        AutoSizeText(
                          provider.totalBalance < 0
                              ? "Over Spent"
                              : '₹ ${provider.totalBalance.toStringAsFixed(1)}',
                          maxLines: 1,
                          style:
                              AppTextStyles.roboto18w600SemiBoldWhite(context)!
                                  .copyWith(
                            fontSize: provider.totalBalance < 0 ? 19.sp : 24.sp,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: .6.h),
                          child: Row(
                            children: [
                              Text(
                                'This month',
                                style:
                                    AppTextStyles.poppins12w300White(context)!
                                        .copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(width: 1.5.w),
                              SizedBox(
                                width: 5.w,
                                height: 2.h,
                                child: Transform.scale(
                                  scale: .47,
                                  child: Switch.adaptive(
                                    activeThumbColor: AppColor.mainHexcolor,
                                    value: provider.isThisMonth,
                                    onChanged: (value) {
                                      provider.toggleThisMonth(value);
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: .5.h),
                        if (provider.isThisMonth)
                          Text(
                            provider.spendingCycleLabel,
                            style: AppTextStyles.poppins12w300White(context)!
                                .copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                provider.isThisMonth
                    ? SizedBox(
                        height: 5.7.h,
                        child: Row(
                          children: [
                            Icon(
                              provider.totalExpense > provider.totalIncome
                                  ? Icons.keyboard_arrow_down_rounded
                                  : Icons.keyboard_arrow_up_rounded,
                              color:
                                  provider.totalExpense > provider.totalIncome
                                      ? AppColor.expenseRed
                                      : AppColor.incomeGreen,
                            ),
                            Text(
                              provider.totalExpense > provider.totalIncome
                                  ? "${provider.totalIncome > 0 ? ((provider.totalExpense - provider.totalIncome) / provider.totalIncome * 100).toStringAsFixed(0) : '100'} % "
                                  : "You saved ${((provider.totalIncome - provider.totalExpense) > 0 ? (provider.totalIncome - provider.totalExpense) : 0).toStringAsFixed(0)} % extra ",
                              style: AppTextStyles.poppins12w300White(context),
                            ),
                            Text(
                              provider.totalExpense > provider.totalIncome
                                  ? "higher compared to last month"
                                  : "compared to last month",
                              style: AppTextStyles.poppins12w300White(context)!
                                  .copyWith(fontSize: 13.sp),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(
                        height: 3.h,
                      ),
                Padding(
                  padding: EdgeInsets.only(left: 2.w, right: 2.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IncomeExpenseCard(
                        transactionType: "Earnings",
                        value: provider.totalIncome,
                      ),
                      IncomeExpenseCard(
                        transactionType: "Spendings",
                        value: provider.totalExpense,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
