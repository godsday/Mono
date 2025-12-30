import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../financial_overview/budget/data/repositories/budget_repository_impl.dart';
import '../financial_overview/budget/domain/usecases/get_current_month_budget_usecase.dart';
import '../financial_overview/budget/presentation/providers/financial_overview_provider.dart';
import '../financial_overview/budget/presentation/widgets/budget_overview_card.dart';
import '../financial_overview/budget/presentation/widgets/first_time_budget_card.dart';
import '../financial_overview/header_section.dart';
import '../financial_overview/assets/presentation/providers/assets_provider.dart';
import '../financial_overview/assets/presentation/widgets/assets_overview_card.dart';
import '../financial_overview/assets/presentation/widgets/first_time_asset_card.dart';
import '../financial_overview/goals/presentation/providers/goals_provider.dart';
import '../financial_overview/goals/presentation/widgets/goals_overview_card.dart';
import '../financial_overview/goals/presentation/widgets/first_time_goal_card.dart';

class FinancialOverviewPage extends StatefulWidget {
  const FinancialOverviewPage({super.key});

  @override
  State<FinancialOverviewPage> createState() => _FinancialOverviewPageState();
}

class _FinancialOverviewPageState extends State<FinancialOverviewPage> {
  late FinancialOverviewProvider _provider;

  @override
  void initState() {
    super.initState();
    // Initialize provider with dependencies
    final repository = BudgetRepositoryImpl();
    final useCase = GetCurrentMonthBudgetUseCase(repository);
    _provider = FinancialOverviewProvider(getBudgetUseCase: useCase);

    // Load initial data
    _provider.loadBudget();

    // Load Assets and Goals data once frame is ready to access context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AssetsProvider>().loadAssets();
      context.read<GoalsProvider>().loadGoals();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Scaffold(
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
                    const SizedBox(height: 30),
                    Consumer<FinancialOverviewProvider>(
                      builder: (context, provider, _) {
                        // if (provider.isLoading) {
                        //   return const Center(
                        //       child: CircularProgressIndicator());
                        // }

                        if (provider.isFirstTimeUser) {
                          return const FirstTimeBudgetCard();
                        } else {
                          return BudgetOverviewCard(budget: provider.budget!);
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
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
