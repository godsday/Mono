import 'package:flutter/material.dart';
import '../../../../core/constants/colors/app_colors.dart';
import '../../../../core/theme/app_texttheme.dart';
import '../pages/add_budget_screen.dart';
import '../providers/financial_overview_provider.dart';
import 'package:provider/provider.dart';

class FirstTimeBudgetCard extends StatelessWidget {
  const FirstTimeBudgetCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: const LinearGradient(
          colors: [
            Color(0xFFF9F5FF),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColor.mainHexcolor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.account_balance_wallet_outlined,
              color: AppColor.mainHexcolor,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Plan Your Money Smarter',
            style: AppTextTheme.montserrart(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColor.mainHexcolor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first monthly budget to track expenses and stay in control.',
            style: AppTextTheme.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColor.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                // Navigate to new budget setup flow
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddBudgetScreen()),
                );

                // If saved successfully, reload the overview
                if (result == true && context.mounted) {
                  // Refresh the provider
                  context.read<FinancialOverviewProvider>().loadBudget();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.mainHexcolor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Set Monthly Budget',
                style: AppTextTheme.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
