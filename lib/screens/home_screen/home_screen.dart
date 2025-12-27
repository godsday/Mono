import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mono/core/constants/colors/app_colors.dart';
import 'package:mono/core/theme/app_texttheme.dart';
import 'package:mono/core/utils/extension/app_extension.dart';
import 'package:mono/providers/app_state.dart';
import 'package:mono/screens/home_screen/widgets/bottom_card_l_shape.dart';
import 'package:mono/screens/home_screen/widgets/home_empty_state.dart';
import 'package:mono/screens/home_screen/widgets/shapes/curveshape_l_card.dart';
import 'package:mono/screens/home_screen/widgets/shapes/curve_shape_u_card.dart';
import 'package:mono/screens/home_screen/widgets/total_balance_card.dart';
import 'package:mono/core/constants/app_textstyle/app_textstyle.dart';
import 'package:mono/routes/route_names.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String enteredname = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AppState>(context, listen: false).refresh();
    });

    getnamedata();
  }

  getnamedata() async {
    final sharedprefer = await SharedPreferences.getInstance();
    enteredname = sharedprefer.getString('namekey')!;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          // Check if there are no transactions
          final hasTransactions = appState.transcationNotifier.value.isNotEmpty;

          if (!hasTransactions) {
            log("checking no transc -----");

            // Show empty state when there are no transactions
            return const HomeEmptyState();
          }
          log("checking with transc -----");
          // Show normal home screen when there are transactions
          return Column(
            children: [
              Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
                  ClipPath(
                    clipper: CurveClipper2(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                      ),
                      height: 55.h,
                    ),
                  ),

                  Positioned(
                    top: 5.h,
                    left: 7.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Hi ${enteredname.capitalizeFirstLetter()},",
                          style: AppTextTheme.montserrart(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColor.white,
                          ),
                        ),
                        Text(
                          getGreetingWithEmoji(),
                          style: AppTextTheme.montserrart(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColor.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                      top: 4.h,
                      right: 7.w,
                      child: Container(
                        width: 7.w,
                        height: 7.h,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 240, 238, 236)),
                        child: const Icon(
                          Icons.lightbulb,
                          color: Color.fromARGB(255, 60, 104, 125),
                          size: 18,
                        ),
                      )),

                  // detail card
                  Positioned(
                      top: 30.h,
                      left: 12.w,
                      child: Container(
                        height: 12.h,
                        width: 76.w,
                        decoration: BoxDecoration(
                            color: HexColor("#37474F"),
                            borderRadius: BorderRadius.circular(24.0)),
                      )),

                  Positioned(
                    top: 14.h,
                    left: 7.w,
                    right: 7.w,
                    child: InkWell(
                      onTap: () async {
                        Navigator.pushNamed(context, RouteNames.home);
                      },
                      // Total Balance Card
                      child: const TotalBalanceCard(),
                    ),
                  ),
                  Positioned(
                      top: 20.3.h,
                      child: Image(
                        width: 67.w,
                        image: const AssetImage(
                          'assets/images/rings.png',
                        ),
                      )),
                  Positioned(
                    right: 10.w,
                    bottom: 0.h,
                    child: ClipRect(
                        child: Align(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                          width: 14.0.h,
                          height: 14.h,
                          // Height of the visible portion
                          child: ShaderMask(
                            shaderCallback: (Rect bounds) {
                              return const LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [Colors.transparent, Colors.black],
                              ).createShader(bounds);
                            },
                            blendMode: BlendMode.dstIn,
                            child: Image.asset(
                              'assets/images/piggybank.png', // Replace 'your_image.jpg' with your image asset
                              fit: BoxFit.cover,
                            ),
                            // ),
                          )),
                    )),
                  ),
                  Positioned(
                    left: -11.w,
                    bottom: -10.h,
                    child: Image(
                      image: const AssetImage("assets/images/monotree.png"),
                      width: 31.h,
                      height: 31.h,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  Text(
                    "Cash",
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Consumer<AppState>(
                          builder: (context, appState, child) {
                            return LShapeWidget(
                              type: "Income",
                              orientation: LShapeOrientation.leftLegOnLeft,
                              color: AppColor.greenContainer,
                              icons: Icons.account_balance,
                              categories: appState.topIncomeCategories,
                              totalAmount: appState.totalIncome,
                            );
                          },
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        Consumer<AppState>(
                          builder: (context, appState, child) {
                            return LShapeWidget(
                              type: "Expense",
                              orientation: LShapeOrientation.leftLegOnRight,
                              color: AppColor.redContainer,
                              icons: Icons.account_balance_wallet,
                              categories: appState.topExpenseCategories,
                              totalAmount: appState.totalExpense,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 8.6.h,
                    left: 40.5.w,
                    child: GestureDetector(
                      onTap: () => Navigator.pushNamed(
                          context, RouteNames.addTransaction),
                      child: Container(
                        width: 8.5.h,
                        height: 8.5.h,
                        decoration: BoxDecoration(
                            border: Border.all(width: 2, color: Colors.white),
                            shape: BoxShape.circle,
                            color: Colors.amber),
                        child: Icon(
                          Icons.add,
                          color: Colors.black,
                          size: 28.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          transactionType,
          style: AppTextStyles.poppins18w500White(context),
        ),
        Text(
          "₹ ${value.toString()}",
          style: AppTextStyles.roboto18w600SemiBoldWhite(context),
        ),
      ],
    );
  }
}

String getGreetingWithEmoji() {
  final hour = DateTime.now().hour;

  if (hour >= 5 && hour < 12) {
    return 'Good Morning ☀️';
  } else if (hour >= 12 && hour < 17) {
    return 'Good Afternoon 🌤️';
  } else if (hour >= 17 && hour < 21) {
    return 'Good Evening 🌆';
  } else {
    return 'Good Night 🌙';
  }
}
