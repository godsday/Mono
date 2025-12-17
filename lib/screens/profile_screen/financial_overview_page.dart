import 'package:flutter/material.dart';
import 'package:mono/constants/colors/app_color.dart';
import '../widgets/financial_overview/header_section.dart';
import '../widgets/financial_overview/budget_card.dart';
import '../widgets/financial_overview/assets_card.dart';
import '../widgets/financial_overview/dreams_card.dart';

class FinancialOverviewPage extends StatelessWidget {
  const FinancialOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderSection(),
            const SizedBox(height: 30),
            const BudgetCard(),
            const SizedBox(height: 20),
            const AssetsCard(),
            const SizedBox(height: 20),
            const DreamsCard(),
          ],
        ),
      ),
    );
  }
}