import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors/app_colors.dart';
import 'package:mono/core/theme/app_theme.dart' show AppGradients;
import 'package:mono/features/home/presentation/providers/home_provider.dart';
import 'package:mono/features/home/presentation/widgets/income_expense_card.dart';
import 'package:mono/core/constants/app_textstyle/app_textstyle.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:mono/core/utils/extension/context_extension.dart';

class TotalBalanceCard extends StatelessWidget {
  const TotalBalanceCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, homeProvider, child) {
      print("total balance called: ${homeProvider.transactions}");
      return Container(
        height: 25.5.h,
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                  spreadRadius: 1.sp,
                  blurRadius: 2.sp,
                  color: AppColor.transparent)
            ],
            borderRadius: BorderRadius.circular(16.0.sp)),
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
                        context.l10n.total_balance_title,
                        style:
                            AppTextStyles.poppins18w500White(context)!.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: .5.h,
                      ),
                      AutoSizeText(
                        homeProvider.totalBalance == 0
                            ? context.l10n.balance_is_zero
                            : homeProvider.totalBalance < 0
                                ? context.l10n.balance_overspent
                                : context
                                    .formatCurrency(homeProvider.totalBalance),
                        maxLines: 1,
                        style: AppTextStyles.roboto18w600SemiBoldWhite(context)!
                            .copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: homeProvider.totalBalance < 0
                                    ? 19.sp
                                    : 19.sp),
                      ),

                      /*  TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        const TranscationScreen())));
                          },
                          child: const Text(
                            "See details",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),*/
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: .6.h),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            homeProvider
                                .toggleThisMonth(!homeProvider.isThisMonth);
                          },
                          child: Row(
                            children: [
                              Text(
                                context.l10n.this_month_toggle,
                                style:
                                    AppTextStyles.poppins12w300White(context)!
                                        .copyWith(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15.sp),
                              ),
                              SizedBox(
                                width: 3.5.w,
                              ),
                              SizedBox(
                                  width: 5.w,
                                  height: 2.h,
                                  child: Transform.scale(
                                    scale: .67,
                                    child: Switch.adaptive(
                                        activeThumbColor: Theme.of(context)
                                            .extension<AppGradients>()!
                                            .switchColor,
                                        value: homeProvider.isThisMonth,
                                        onChanged: (value) {
                                          homeProvider.toggleThisMonth(value);
                                        }),
                                  ))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: .5.h,
                      ),
                      if (homeProvider.isThisMonth)
                        Text(
                          homeProvider.spendingCycleLabel(
                              context.l10n.spending_cycle_label),
                          style: AppTextStyles.poppins12w300White(context)!
                              .copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 13.sp,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              homeProvider.isThisMonth
                  ? SizedBox(
                      height: 6.5.h,
                      child: homeProvider.previousMonthExpense == 0
                          ? const SizedBox.shrink()
                          : Row(
                              children: [
                                Icon(
                                  homeProvider.thisMonthExpense >
                                          homeProvider.previousMonthExpense
                                      ? Icons.keyboard_arrow_down_rounded
                                      : Icons.keyboard_arrow_up_rounded,
                                  color: homeProvider.thisMonthExpense >
                                          homeProvider.previousMonthExpense
                                      ? AppColor.expenseRed
                                      : AppColor.incomeGreen,
                                ),
                                Text(
                                  homeProvider.thisMonthExpense >
                                          homeProvider.previousMonthExpense
                                      ? "${((homeProvider.thisMonthExpense - homeProvider.previousMonthExpense) / homeProvider.previousMonthExpense * 100).toStringAsFixed(0)} % "
                                      : "${context.l10n.you_saved_prefix} ${((homeProvider.previousMonthExpense - homeProvider.thisMonthExpense) / homeProvider.previousMonthExpense * 100).toStringAsFixed(0)} % ${context.l10n.extra_saved_suffix} ",
                                  style:
                                      AppTextStyles.poppins12w300White(context)!
                                          .copyWith(fontSize: 13.sp),
                                ),
                                Text(
                                  homeProvider.thisMonthExpense >
                                          homeProvider.previousMonthExpense
                                      ? context.l10n.higher_than_last_month
                                      : context.l10n.compared_to_last_month,
                                  style:
                                      AppTextStyles.poppins12w300White(context)!
                                          .copyWith(fontSize: 13.sp),
                                ),
                              ],
                            ),
                    )
                  : SizedBox(
                      height: 6.5.h,
                    ),
              Padding(
                padding: EdgeInsets.only(top: .5.h, left: 5.w, right: 4.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IncomeExpenseCard(
                      transactionType: context.l10n.earnings_label,
                      value: homeProvider.isThisMonth
                          ? homeProvider.thisMonthIncome
                          : homeProvider.totalIncome,
                      isIncome: true,
                    ),
                    IncomeExpenseCard(
                      transactionType: context.l10n.spendings_label,
                      value: homeProvider.isThisMonth
                          ? homeProvider.thisMonthExpense
                          : homeProvider.totalExpense,
                      isIncome: false,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
