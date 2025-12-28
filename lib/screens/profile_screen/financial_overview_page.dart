import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/budget/data/repositories/budget_repository_impl.dart';
import '../../features/budget/domain/usecases/get_current_month_budget_usecase.dart';
import '../../features/budget/presentation/providers/financial_overview_provider.dart';
import '../../features/budget/presentation/widgets/budget_overview_card.dart';
import '../../features/budget/presentation/widgets/first_time_budget_card.dart';
import '../widgets/financial_overview/header_section.dart';
import '../widgets/financial_overview/assets_card.dart';
import '../widgets/financial_overview/dreams_card.dart';

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
                        if (provider.isLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (provider.isFirstTimeUser) {
                          return const FirstTimeBudgetCard();
                        } else {
                          return BudgetOverviewCard(budget: provider.budget!);
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    const AssetsCard(),
                    const SizedBox(height: 20),
                    const DreamsCard(),
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
