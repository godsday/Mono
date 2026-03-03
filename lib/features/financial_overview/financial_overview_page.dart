import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mono/core/constants/app_textstyle/app_textstyle.dart';
import 'package:mono/core/constants/colors/app_colors.dart';
import 'package:mono/features/financial_overview/budget/presentation/providers/budget_provider.dart';
import 'package:mono/routes/route_names.dart';
import 'package:provider/provider.dart';

import 'budget/presentation/widgets/budget_overview_card.dart';
import 'budget/presentation/widgets/first_time_budget_card.dart';
import 'header_section.dart';
import 'asset/presentation/providers/assets_provider.dart';
import 'asset/presentation/widgets/assets_overview_card.dart';
import 'asset/presentation/widgets/first_time_asset_card.dart';
import 'goals/presentation/providers/goals_provider.dart';
import 'goals/presentation/widgets/goals_overview_card.dart';
import 'goals/presentation/widgets/first_time_goal_card.dart';

class FinancialOverviewPage extends StatefulWidget {
  const FinancialOverviewPage({super.key});

  @override
  State<FinancialOverviewPage> createState() => _FinancialOverviewPageState();
}

class _FinancialOverviewPageState extends State<FinancialOverviewPage> {
  // late FinancialOverviewProvider _provider;

  @override
  void initState() {
    super.initState();

    // Load Assets and Goals data once frame is ready to access context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AssetsProvider>().loadAssets();
      context.read<GoalsProvider>().loadGoals();
      context.read<BudgetProvider>().loadBudget();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderSection(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Analytics Header Card

                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, RouteNames.analytics);
                    },
                    // child: ShaderMask(
                    //   shaderCallback: (Rect bounds) {
                    //     return const LinearGradient(
                    //       begin: Alignment.topLeft,
                    //       end: Alignment.bottomRight,
                    //       colors: [
                    //         Colors.black,
                    //         Color.fromARGB(255, 30, 35, 35),
                    //         Colors.amber,
                    //         Color.fromARGB(255, 3, 19, 18)
                    //       ],
                    //     ).createShader(bounds);
                    //   },
                    child: Stack(
                      children: [
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.black,
                                Color.fromARGB(255, 30, 35, 35),
                                Colors.amber,
                                Color.fromARGB(255, 3, 19, 18)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(22),
                            color: Colors.white.withValues(alpha: 0.08),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.15),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              )
                            ],
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Analytics",
                                  style: AppTextStyles.poppins16w400.copyWith(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18,
                                      color: const Color(0xFF21435D)),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 23,
                                  color: Color(0xFF21435D),
                                )
                              ],
                            ),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                color: Colors.white.withValues(alpha: 0.08),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.15),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.15),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  )
                                ],
                              ),
                              child: Icon(
                                Icons.lock,
                                color: AppColor.mainHexcolor,
                                size: 28,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  // ),

                  const SizedBox(height: 20),

                  // Budget section

                  Consumer<BudgetProvider>(
                    builder: (context, provider, _) {
                      if (provider.budget == null ||
                          provider.budget!.totalBudget == 0) {
                        return const FirstTimeBudgetCard();
                      } else {
                        return BudgetOverviewCard(budget: provider.budget!);
                      }
                    },
                  ),
                  const SizedBox(height: 20),

                  // Goals Section
                  Consumer<GoalsProvider>(
                    builder: (context, provider, _) {
                      // if (provider.isLoading) {
                      //   return const Center(
                      //       child: CircularProgressIndicator());
                      // }
                      if (provider.goals.isEmpty) {
                        return const FirstTimeGoalCard();
                      } else {
                        return const GoalsOverviewCard();
                      }
                    },
                  ),
                  const SizedBox(height: 20),

                  // Assets Section
                  Consumer<AssetsProvider>(
                    builder: (context, provider, _) {
                      // if (provider.isLoading) {
                      //   return const Center(
                      //       child: CircularProgressIndicator());
                      // }
                      if (provider.assets.isEmpty) {
                        return const FirstTimeAssetCard();
                      } else {
                        return const AssetsOverviewCard();
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
