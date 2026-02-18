import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import '../../../../../core/constants/colors/app_colors.dart';
import '../../../../../core/theme/app_texttheme.dart';
import '../../../widgets/safe_background_image.dart';
import '../pages/add_asset_screen.dart';

class FirstTimeAssetCard extends StatelessWidget {
  const FirstTimeAssetCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: HexColor('#E6F5F4'),
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
            HexColor('#E6F5F4'),
            HexColor('#F0FDFB'),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Background Cityscape (Right side)
          Positioned(
            right: 10,
            top: 20,
            width: 150,
            child: Opacity(
              opacity: 0.8,
              child: SafeBackgroundImage(
                imagePath: 'assets/images/building-big.png', // Placeholder
                fit: BoxFit.contain,
                fallback: Icon(Icons.location_city_rounded,
                    size: 80, color: Colors.grey.withValues(alpha: 0.2)),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(),
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Icon(
                        Icons.account_balance_wallet,
                        color: AppColor.textPrimary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Track Your Assets',
                      style: AppTextTheme.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColor.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 200, // Limit width to avoid overlapping image
                  child: Text(
                    'Add what you own to understand your net worth',
                    style: AppTextTheme.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColor.textGrey,
                    ),
                  ),
                ),
                const SizedBox(height: 74),
                SizedBox(
                  width: 140,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddAssetScreen()),
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: HexColor('#21988C'), width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'Add Assets',
                        style: AppTextTheme.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: HexColor('#2D6763'),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
