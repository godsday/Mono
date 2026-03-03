import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../transaction/presentation/providers/transaction_provider.dart';

import '../../../budget/presentation/providers/budget_provider.dart';

import '../providers/wealth_analytics_provider.dart';

import '../widgets/budget_discipline_chart.dart';
import '../widgets/expense_trend_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    final transactions = context.read<TransactionProvider>().transactions;
    // final assets = context.read<AssetsProvider>().assets;
    // final goals = context.read<GoalsProvider>().goals;

    // BudgetProvider might just have one current budget or a list.
    // Assuming it has a list if we want history, but if it only has current, we'll just pass that.
    // The previous implementation used context.read<BudgetProvider>().budget!
    // Let's check how many we can get. For now, pass an empty list if not available as history.
    final budgetProvider = context.read<BudgetProvider>();
    final budgets =
        budgetProvider.budget != null ? [budgetProvider.budget!] : [];

    context.read<WealthAnalyticsProvider>().loadData(
          transactions: transactions.cast(),
          // assets: assets,
          // goals: goals,
          budgets: budgets.cast(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Analytics',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Consumer<WealthAnalyticsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.netWorthData == null) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: () async {
              _loadData();
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // if (provider.currentAiInsight != null) ...[
                  //   AiInsightCard(insight: provider.currentAiInsight!),
                  //   const SizedBox(height: 16),
                  // ],
                  /*  _buildSectionCard(
                    title: 'Financial Health',
                    child: FinancialHealthCard(data: provider.financialHealth!),
                    removePadding: true,
                  ),
                  const SizedBox(height: 16),*/
                  /*  _buildSectionCard(
                    title: 'Net Worth Growth',
                    subtitle:
                        '₹${provider.netWorthData!.currentNetWorth.toStringAsFixed(0)}',
                    child: NetWorthChart(data: provider.netWorthData!),
                  ),*/
                  // const SizedBox(height: 16),
                  /*      Row(
                    children: [
                      Expanded(
                        child: _buildSectionCard(
                          title: 'Savings Rate',
                          child: SavingsRateIndicator(
                              rate: provider.savingsRate ?? 0),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSectionCard(
                          title: 'Goal Progress',
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                            child: Column(
                              children: [
                                Text(
                                  '${provider.goalAnalytics?.averageCompletionPercentage.toStringAsFixed(1) ?? '0'}%',
                                  style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue),
                                ),
                                const Text('Avg Completion',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),*/
                  /*  const SizedBox(height: 16),
                  _buildSectionCard(
                    title: 'Asset Allocation',
                    child: provider.assetAllocation != null
                        ? AssetAllocationChart(
                            allocation: provider.assetAllocation!)
                        : const SizedBox(),
                  ),*/
                  const SizedBox(height: 16),
                  _buildSectionCard(
                    title: 'Expense Trend (6 Months)',
                    child: provider.expenseTrend != null
                        ? ExpenseTrendChart(data: provider.expenseTrend!)
                        : const SizedBox(),
                  ),
                  const SizedBox(height: 16),
                  _buildSectionCard(
                    title: 'Budget Discipline',
                    child: provider.budgetDiscipline != null
                        ? BudgetDisciplineChart(
                            data: provider.budgetDiscipline!)
                        : const SizedBox(),
                  ),
                  // const SizedBox(height: 16),
                  // if (provider.futureProjection != null &&
                  //     provider.futureProjection! > 0)
                  // _buildSectionCard(
                  //   title: 'Projected Next Month Expense',
                  //   child: Padding(
                  //     padding: const EdgeInsets.symmetric(vertical: 16.0),
                  //     child: Center(
                  //       child: Text(
                  //         '₹${provider.futureProjection!.toStringAsFixed(0)}',
                  //         style: const TextStyle(
                  //             fontSize: 32,
                  //             fontWeight: FontWeight.bold,
                  //             color: Colors.redAccent),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    String? subtitle,
    required Widget child,
    bool removePadding = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Padding(
        padding: removePadding ? EdgeInsets.zero : const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!removePadding) ...[
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
              const SizedBox(height: 20),
            ],
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: child,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.analytics_outlined,
                  size: 64, color: Colors.blue),
            ),
            const SizedBox(height: 24),
            const Text(
              "Start tracking to unlock wealth insights.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            const Text(
              "Add transactions, assets, and goals to see your financial health.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
