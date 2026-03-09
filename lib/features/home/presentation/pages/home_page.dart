import 'package:flutter/material.dart';
import 'package:mono/core/notifications/firebase_notification_service.dart';
import 'package:mono/core/theme/app_theme.dart';
import 'package:mono/features/home/presentation/providers/home_provider.dart';
import 'package:mono/features/home/presentation/widgets/smart_insight_card.dart';
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
import 'package:mono/core/utils/extension/context_extension.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseNotificationService().init();
      Provider.of<TransactionProvider>(context, listen: false)
          .loadTransactions();

      final homeProvider = Provider.of<HomeProvider>(context, listen: false);
      homeProvider.loadUserName();
      homeProvider.loadBudget();
    });
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     Provider.of<TransactionProvider>(context, listen: false)
  //         .loadTransactions();
  //   }
  // }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<TransactionProvider>(
          builder: (context, transactionProvider, child) {
            print("transactions: called");
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
                    // curve shape
                    const HomepageCurveShape(),

                    // name and greeting Header
                    Positioned(
                      top: 2.5.h,
                      left: 7.w,
                      child: const HomeHeader(),
                    ),

                    // lightbulb icon
                    Positioned(
                      top: 1.5.h,
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
                        top: 28.h,
                        left: 12.w,
                        child: Container(
                          height: 12.h,
                          width: 76.w,
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(24.0)),
                        )),

                    // total balance card
                    Positioned(
                      top: 12.h,
                      left: 7.w,
                      right: 7.w,
                      child: const TotalBalanceCard(),
                    ),

                    // Decorative elements
                    Positioned(
                      top: 14.h,
                      child: Image(
                        width: 67.w,
                        image: const AssetImage('assets/images/rings.png'),
                      ),
                    ),
                    Positioned(
                      left: -11.w,
                      bottom: 2.h,
                      child: Image(
                        image: const AssetImage("assets/images/monotree.png"),
                        width: 31.h,
                        height: 31.h,
                      ),
                    ),

                    // Smart Insight

                    Positioned(
                      bottom: 2.h,
                      left: 0,
                      right: 0,
                      child: Consumer<HomeProvider>(
                          builder: (context, homeProvider, child) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 5000),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          child: homeProvider.currentInsight == null
                              ? const SizedBox()
                              : SmartInsightCard(
                                  key:
                                      ValueKey(homeProvider.currentInsight!.id),
                                  id: homeProvider.currentInsight!.id,
                                  title: homeProvider.currentInsight!.title,
                                  message: homeProvider.currentInsight!.message,
                                  icon: Icons.lightbulb_outline,
                                  type: homeProvider.currentInsight!.type,
                                ),
                        );
                      }),
                    ),
                    Positioned(
                      right: 5.w,
                      bottom: 6.h,
                      child: ClipRect(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            width: 14.0.h,
                            height: 14.h,
                            child: ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return const LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.amberAccent
                                  ],
                                ).createShader(bounds);
                              },
                              blendMode: BlendMode.dstIn,
                              child: Image.asset(
                                scale: 1.5,
                                'assets/images/piggybank.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16),
                      child: Consumer<HomeProvider>(
                          builder: (context, homeProvider, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            LShapeWidget(
                              type: context.l10n.transaction_type_income,
                              orientation: LShapeOrientation.leftLegOnLeft,
                              color: Theme.of(context).dividerColor,
                              icons: Icons.account_balance,
                              categories: homeProvider.topIncomeCategories,
                              totalAmount: homeProvider.totalIncome,
                            ),
                            SizedBox(width: 4.w),
                            LShapeWidget(
                              type: context.l10n.transaction_type_expense,
                              orientation: LShapeOrientation.leftLegOnRight,
                              color: Theme.of(context).hoverColor,
                              icons: Icons.account_balance_wallet,
                              categories: homeProvider.topExpenseCategories,
                              totalAmount: homeProvider.totalExpense,
                            ),
                          ],
                        );
                      }),
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
      ),
    );
  }
}

class HomepageCurveShape extends StatelessWidget {
  const HomepageCurveShape({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CurveClipper2(),
      child: Container(
        decoration: BoxDecoration(
          gradient:
              Theme.of(context).extension<AppGradients>()?.primaryGradient,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        height: 67.h,
      ),
    );
  }
}
