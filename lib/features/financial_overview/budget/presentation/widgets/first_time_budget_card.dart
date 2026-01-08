import 'package:flutter/material.dart';
import 'package:mono/features/financial_overview/budget/presentation/widgets/decorationbox.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import '../../../../../core/constants/colors/app_colors.dart';
import '../../../../../core/theme/app_texttheme.dart';
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
        color: HexColor('#EBEEFF'),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.26),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
        // gradient: const LinearGradient(
        //   colors: [
        //     Color.fromARGB(255, 28, 27, 30),
        //     Color.fromARGB(255, 31, 32, 30),
        //   ],
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        // ),
      ),
      child: Stack(
        children: [
          const Positioned(
            left: 50,
            top: 44,
            child: DecorationBox(width: 140, height: 140),
          ),
          const Positioned(
            left: 140,
            top: 70,
            child: DecorationBox(width: 100, height: 100),
          ),
          const Positioned(
            left: 230,
            top: 90,
            child: DecorationBox(width: 60, height: 60),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  // gradient: LinearGradient(
                  //     colors: [Color(0xFF521F66), Color(0xFF84509B)]),
                  color: HexColor('#B9B5EC'),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.account_balance_wallet_outlined,
                  color: AppColor.white,
                  size: 24,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Monthly Budget',
                style: AppTextTheme.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColor.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Create your first monthly budget to track expenses and stay in control.',
                style: AppTextTheme.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColor.textGrey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddBudgetScreen()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              HexColor('#00B495'),
                              HexColor('#438883'),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Set Monthly Budget',
                        style: AppTextTheme.montserrart(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColor.white,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
