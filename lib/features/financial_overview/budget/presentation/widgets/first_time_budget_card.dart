import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import '../../../../../core/constants/colors/app_colors.dart';
import '../../../../../core/theme/app_texttheme.dart';
import '../../../widgets/safe_background_image.dart';
import '../pages/add_budget_screen.dart';
import '../providers/financial_overview_provider.dart';
import 'package:provider/provider.dart';

class FirstTimeBudgetCard extends StatelessWidget {
  const FirstTimeBudgetCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: HexColor('#EBEEFF'),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: LinearGradient(
          colors: [
            HexColor('#E3E6FF'),
            HexColor('#F2F4FF'),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Background Pattern (Placeholder)
          const Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: SafeBackgroundImage(
                imagePath: 'assets/images/onboard_bacground.svg', // Placeholder
                fit: BoxFit.cover,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_rounded,
                    color: HexColor('#6C63FF'),
                    size: 28,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Plan Your Money Smarter',
                  style: AppTextTheme.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColor.blackText,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
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
                  child: GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddBudgetScreen()),
                      );
                      // Since we are back, let's try to reload the budget to check if it was added
                      if (context.mounted) {
                        context.read<BudgetProvider>().loadBudget();
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                HexColor('#21988C'),
                                HexColor('#21988C').withValues(alpha: 0.8),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: HexColor('#21988C').withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        'Set Monthly Budget',
                        style: AppTextTheme.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColor.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
