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
      child: ClipRRect(
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
                top: 20,
                left: 80,
                child: RotatedSquareDecoration(quarterTurns: .82, color: [
                  HexColor('#FFFFFF'),
                  HexColor('#9995AF'),
                ])),
            // medium
            Positioned(
                top: 30,
                left: 40,
                child: RotatedSquareDecoration(
                  color: [
                    HexColor('#FFFFFF'),
                    HexColor('#9995AF'),
                  ],
                  quarterTurns: .82,
                  size: 80,
                )),
            //small
            Positioned(
                top: 45,
                left: 5,
                child: RotatedSquareDecoration(
                    size: 55,
                    quarterTurns: 5.54,
                    color: [
                      HexColor('#FFFFFF'),
                      HexColor('#9995AF'),
                    ])),

            ///////////////////////
            Positioned(
                top: 20,
                left: 180,
                child: RotatedSquareDecoration(quarterTurns: .82, color: [
                  HexColor('#FFFFFF'),
                  HexColor('#9995AF'),
                ])),
            Positioned(
                top: 30,
                left: 250,
                child: RotatedSquareDecoration(
                  opacity: .5,
                  color: [
                    HexColor('#FFFFFF'),
                    HexColor('#9995AF'),
                  ],
                  quarterTurns: .82,
                  size: 80,
                )),
            Positioned(
                top: 45,
                left: 160,
                child: RotatedSquareDecoration(
                    size: 55,
                    quarterTurns: 5.54,
                    color: [
                      HexColor('#FFFFFF'),
                      HexColor('#9995AF'),
                    ])),

            Positioned(
                top: 45,
                left: 310,
                child: RotatedSquareDecoration(
                    size: 55,
                    quarterTurns: 5.54,
                    color: [
                      HexColor('#FFFFFF'),
                      HexColor('#9995AF'),
                    ])),

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
      ),
    );
  }
}

class RotatedSquareDecoration extends StatelessWidget {
  final double size;
  final double borderRadius;
  final List<Color> color;
  final double opacity;
  final double quarterTurns;

  const RotatedSquareDecoration({
    super.key,
    this.size = 100,
    this.borderRadius = 0,
    required this.color,
    this.opacity = 0.25,
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
              colors: color,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}
