import 'package:flutter/material.dart';
import '../widgets/financial_overview/header_section.dart';
import '../widgets/financial_overview/budget_card.dart';
import '../widgets/financial_overview/assets_card.dart';
import '../widgets/financial_overview/dreams_card.dart';

class FinancialOverviewPage extends StatelessWidget {
  const FinancialOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderSection(),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(height: 30),
                  BudgetCard(),
                  SizedBox(height: 20),
                  AssetsCard(),
                  SizedBox(height: 20),
                  DreamsCard(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
