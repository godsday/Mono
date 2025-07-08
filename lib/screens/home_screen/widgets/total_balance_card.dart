import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mono/constants/app_color.dart';
import 'package:mono/main.dart';
import 'package:mono/providers/app_state.dart';
import 'package:mono/screens/home_screen/home_screen.dart';
import 'package:mono/utils/app_textstyle.dart';
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
            color: HexColor("#37474F"),
            boxShadow: [
              BoxShadow(
                  spreadRadius: 1.sp,
                  blurRadius: 2.sp,
                  color: Colors.transparent)
            ],
            borderRadius: BorderRadius.circular(12.0)),
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
                            ? "Over Spended"
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
                        padding: EdgeInsets.only(top: 1.5.h),
                        child: Row(
                          children: [
                            Text(
                              'This month',
                              style: AppTextStyles.poppins12w300White(context)!
                                  .copyWith(fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              width: 1.w,
                            ),
                            SizedBox(
                                width: 5.w,
                                height: 1.h,
                                child: Transform.scale(
                                  scale: .4,
                                  child: Switch.adaptive(
                                      value: appState.isThisMonth,
                                      onChanged: (value) {
                                        appState.thisMonthSwitch(value);
                                      }),
                                ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
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
                  ? Row(
                      children: [
                        Icon(
                          Icons.keyboard_arrow_up_rounded,
                          color: mainHexcolor,
                        ),
                        Text(
                          "25 % ",
                          style: AppTextStyles.poppins12w300White(context),
                        ),
                        Text(
                          " higher compared to last month",
                          style: AppTextStyles.poppins12w300White(context)!
                              .copyWith(fontSize: 9),
                        ),
                      ],
                    )
                  : SizedBox(
                      height: 3.7.h,
                    ),
              Padding(
                padding: EdgeInsets.only(top: 2.h, left: 5.w, right: 5.w),
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
