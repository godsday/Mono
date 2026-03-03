import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors/app_colors.dart';
import 'package:mono/features/home/presentation/providers/home_provider.dart';
import 'package:mono/features/home/presentation/widgets/income_expense_card.dart';
import 'package:mono/core/constants/app_textstyle/app_textstyle.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

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
            color: AppColor.totalBalanceCardBg,
            boxShadow: [
              BoxShadow(
                  spreadRadius: 1.sp,
                  blurRadius: 2.sp,
                  color: AppColor.transparent)
            ],
            borderRadius: BorderRadius.circular(20.0)),
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
                            ? "is Zero"
                            : homeProvider.totalBalance < 0
                                ? "Over Spent"
                                : homeProvider.isThisMonth
                                    ? '₹ ${homeProvider.thisMonthBalance.toStringAsFixed(0)}'
                                    : '₹ ${homeProvider.totalBalance.toStringAsFixed(0)}',
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
                        child: Row(
                          children: [
                            Text(
                              'This month',
                              style: AppTextStyles.poppins12w300White(context)!
                                  .copyWith(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.sp),
                            ),
                            SizedBox(
                              width: 1.5.w,
                            ),
                            SizedBox(
                                width: 5.w,
                                height: 2.h,
                                child: Transform.scale(
                                  scale: .47,
                                  child: Switch.adaptive(
                                      activeThumbColor: AppColor.mainHexcolor,
                                      value: homeProvider.isThisMonth,
                                      onChanged: (value) {
                                        homeProvider.toggleThisMonth(value);
                                      }),
                                ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: .5.h,
                      ),
                      if (homeProvider.isThisMonth)
                        Text(
                          homeProvider.spendingCycleLabel,
                          style: AppTextStyles.poppins12w300White(context)!
                              .copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              homeProvider.isThisMonth
                  ? SizedBox(
                      height: 6.5.h,
                      child: Row(
                        children: [
                          Icon(
                            homeProvider.totalExpense > homeProvider.totalIncome
                                ? Icons.keyboard_arrow_down_rounded
                                : Icons.keyboard_arrow_up_rounded,
                            color: homeProvider.totalExpense >
                                    homeProvider.totalIncome
                                ? AppColor.expenseRed
                                : AppColor.incomeGreen,
                          ),
                          Text(
                            homeProvider.totalExpense > homeProvider.totalIncome
                                ? "${((homeProvider.totalExpense - homeProvider.totalIncome) / homeProvider.totalIncome * 100).toStringAsFixed(0)} % "
                                : "You saved ${(homeProvider.totalIncome - homeProvider.totalExpense).toStringAsFixed(0)} % extra ",
                            style: AppTextStyles.poppins12w300White(context),
                          ),
                          Text(
                            homeProvider.totalExpense > homeProvider.totalIncome
                                ? "higher compared to last month"
                                : "compared to last month",
                            style: AppTextStyles.poppins12w300White(context)!
                                .copyWith(fontSize: 13.sp),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      height: 6.5.h,
                    ),
              Padding(
                padding: EdgeInsets.only(top: 1.h, left: 5.w, right: 4.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IncomeExpenseCard(
                      transactionType: "Earnings",
                      value: homeProvider.isThisMonth
                          ? homeProvider.thisMonthIncome
                          : homeProvider.totalIncome,
                    ),
                    IncomeExpenseCard(
                      transactionType: "Spendings",
                      value: homeProvider.isThisMonth
                          ? homeProvider.thisMonthExpense
                          : homeProvider.totalExpense,
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
