import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:mono/core/constants/colors/app_colors.dart';
import 'package:mono/providers/app_state.dart';
import 'package:mono/screens/home_screen/home_screen.dart';
import 'package:mono/core/constants/app_textstyle/app_textstyle.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class TotalBalanceCard extends StatelessWidget {
  const TotalBalanceCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      return Container(
        height: 25.5.h,
        decoration: BoxDecoration(
            // boxShadow: ,
            // backgroundBlendMode: BlendMode.s,
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
                        style: AppTextStyles.poppins18w500White(context),
                      ),
                      SizedBox(
                        height: .5.h,
                      ),
                      AutoSizeText(
                        appState.totalBalance < 0
                            ? "Over Spent"
                            : '₹ ${appState.totalBalance.toStringAsFixed(1)}',
                        maxLines: 1,
                        style: AppTextStyles.roboto18w600SemiBoldWhite(context)!
                            .copyWith(
                                fontSize:
                                    appState.totalBalance < 0 ? 19.sp : 24.sp),
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
                                      value: appState.isThisMonth,
                                      onChanged: (value) {
                                        appState.thisMonthSwitch(value);
                                      }),
                                ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: .5.h,
                      ),
                      if (appState.isThisMonth)
                        Text(
                          appState.getSpendingCycleLabel(),
                          style: AppTextStyles.poppins12w300White(context)!
                              .copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              appState.isThisMonth
                  ? SizedBox(
                      height: 5.7.h,
                      child: Row(
                        children: [
                          Icon(
                            appState.totalExpense > appState.totalIncome
                                ? Icons.keyboard_arrow_down_rounded
                                : Icons.keyboard_arrow_up_rounded,
                            color: appState.totalExpense > appState.totalIncome
                                ? AppColor.expenseRed
                                : AppColor.incomeGreen,
                          ),
                          Text(
                            appState.totalExpense > appState.totalIncome
                                ? "${((appState.totalExpense - appState.totalIncome) / appState.totalIncome * 100).toStringAsFixed(0)} % "
                                : "You saved ${(appState.totalIncome - appState.totalExpense).toStringAsFixed(0)} % extra ",
                            style: AppTextStyles.poppins12w300White(context),
                          ),
                          Text(
                            appState.totalExpense > appState.totalIncome
                                ? "higher compared to last month"
                                : "compared to last month",
                            style: AppTextStyles.poppins12w300White(context)!
                                .copyWith(fontSize: 13.sp),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      height: 3.7.h,
                    ),
              Padding(
                padding: EdgeInsets.only(top: 1.h, left: 5.w, right: 5.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IncomeExpenseCard(
                      transactionType: "Earnings",
                      value: appState.totalIncome,
                    ),
                    IncomeExpenseCard(
                      transactionType: "Spendings",
                      value: appState.totalExpense,
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
