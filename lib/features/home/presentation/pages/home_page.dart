import 'package:flutter/material.dart';
import 'package:mono/routes/route_names.dart';
import 'package:mono/features/home/presentation/widgets/home_header.dart';
import 'package:mono/features/home/presentation/widgets/total_balance_card.dart';
import 'package:mono/features/transaction/presentation/providers/transaction_provider.dart';
import 'package:mono/features/home/presentation/widgets/bottom_card_l_shape.dart';
import 'package:mono/features/home/presentation/pages/home_empty_state.dart';
import 'package:mono/features/home/presentation/widgets/shapes/curveshape_l_card.dart';
import 'package:mono/features/home/presentation/widgets/shapes/curve_shape_u_card.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/constants/colors/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Initial data load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransactionProvider>(context, listen: false)
          .loadTransactions();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Provider.of<TransactionProvider>(context, listen: false)
          .loadTransactions();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TransactionProvider>(
        builder: (context, transactionProvider, child) {
          if (transactionProvider.transactions.isEmpty &&
              !transactionProvider.isLoading) {
            return const HomeEmptyState();
          }

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
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF429690), Color(0xFF1E4744)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(15),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      height: 55.h,
                    ),
                  ),

                  Positioned(
                    top: 5.h,
                    left: 7.w,
                    child: const HomeHeader(),
                  ),

                  Positioned(
                    top: 4.h,
                    right: 7.w,
                    child: Container(
                      width: 7.w,
                      height: 7.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromARGB(255, 240, 238, 236),
                      ),
                      child: const Icon(
                        Icons.lightbulb,
                        color: Color.fromARGB(255, 60, 104, 125),
                        size: 18,
                      ),
                    ),
                  ),

                  // Detail card (Dark background card)
                  Positioned(
                      top: 30.h,
                      left: 12.w,
                      child: Container(
                        height: 12.h,
                        width: 76.w,
                        decoration: BoxDecoration(
                            color:
                                const Color(0xFF37474F), // HexColor("#37474F")
                            borderRadius: BorderRadius.circular(24.0)),
                      )),

                  Positioned(
                    top: 14.h,
                    left: 7.w,
                    right: 7.w,
                    child: const TotalBalanceCard(),
                  ),

                  // Decorative elements
                  Positioned(
                    top: 17.3.h,
                    child: Image(
                      width: 67.w,
                      image: const AssetImage('assets/images/rings.png'),
                    ),
                  ),

                  Positioned(
                    right: 5.w,
                    bottom: 4.h,
                    // child: ClipRect(
                    //   child: Align(
                    //     alignment: Alignment.topCenter,
                    //     child: SizedBox(
                    //       width: 14.0.h,
                    //       height: 14.h,
                    //       child: ShaderMask(
                    //         shaderCallback: (Rect bounds) {
                    //           return const LinearGradient(
                    //             begin: Alignment.bottomCenter,
                    //             end: Alignment.topCenter,
                    //             colors: [Colors.transparent, Colors.black],
                    //           ).createShader(bounds);
                    //         },
                    //         blendMode: BlendMode.dstIn,
                    child: Image.asset(
                      scale: 1.5,
                      'assets/images/piggybank.png',
                      fit: BoxFit.cover,
                      //     ),
                      //   ),
                      // ),
                      // ),
                    ),
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
                        LShapeWidget(
                          type: "Income",
                          orientation: LShapeOrientation.leftLegOnLeft,
                          color: AppColor.greenContainer,
                          icons: Icons.account_balance,
                          categories: transactionProvider.topIncomeCategories,
                          totalAmount: transactionProvider.totalIncome,
                        ),
                        SizedBox(width: 4.w),
                        LShapeWidget(
                          type: "Expense",
                          orientation: LShapeOrientation.leftLegOnRight,
                          color: AppColor.redContainer,
                          icons: Icons.account_balance_wallet,
                          categories: transactionProvider.topExpenseCategories,
                          totalAmount: transactionProvider.totalExpense,
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
                          color: Colors.amber,
                        ),
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
