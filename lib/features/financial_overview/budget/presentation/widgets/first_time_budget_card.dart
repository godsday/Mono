import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mono/core/widgets/app_button_decoration.dart';
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
      decoration: BoxDecoration(
        color: HexColor('#EBEEFF'),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 1,
            offset: const Offset(0, 1),
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
          const Positioned(
              top: 130,
              left: 170,
              child: RotatedSquareDecoration(quarterTurns: .82)),
          const Positioned(
              top: 140,
              left: 230,
              child: RotatedSquareDecoration(
                quarterTurns: .82,
                size: 80,
              )),
          const Positioned(
              bottom: 20,
              left: 30,
              child: RotatedSquareDecoration(
                size: 35,
                quarterTurns: 1,
              )),
          const Positioned(
              top: 10,
              right: 30,
              child: RotatedSquareDecoration(
                size: 36,
                quarterTurns: 1.3,
              )),
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
                        blurRadius: 3,
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
                    color: AppColor.textGrey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                AppElevetedButton(
                  onPressed: () async {
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
                  appButtonText: 'Set Monthly Budget',
                  // height: 42,
                  width: double.infinity,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RotatedSquareDecoration extends StatelessWidget {
  final double size;
  final double borderRadius;
  final Color color;
  final double opacity;
  final double quarterTurns;

  const RotatedSquareDecoration({
    super.key,
    this.size = 100,
    this.borderRadius = 0,
    this.color = Colors.black,
    this.opacity = 0.08,
    this.quarterTurns = math.pi / 2, // 90°
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: quarterTurns,
      child: Opacity(
        opacity: opacity,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                HexColor('#69639B'),
                HexColor('#9995AF'),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            color: color,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}
