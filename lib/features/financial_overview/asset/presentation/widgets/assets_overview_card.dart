import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import '../../../../../core/constants/colors/app_colors.dart';
import '../../../../../core/theme/app_texttheme.dart';

import '../pages/add_asset_screen.dart';
import '../providers/assets_provider.dart';
import '../../../widgets/safe_background_image.dart';

class AssetsOverviewCard extends StatelessWidget {
  const AssetsOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AssetsProvider>(
      builder: (context, provider, child) {
        final assets = provider.assets;
        final totalValue = provider.totalAssetValue;

        if (assets.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            // Summary Card
            Container(
              width: double.infinity,
              height: 180, // Fixed height for visual consistency
              decoration: BoxDecoration(
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
                  // Background Cityscape

                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.account_balance_wallet,
                                  color: AppColor.blackText,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Assets',
                                  style: AppTextTheme.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: AppColor.blackText,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const AddAssetScreen()),
                                );
                              },
                              child: Text(
                                'Add +',
                                style: AppTextTheme.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          'Your total wealth so far',
                          style: AppTextTheme.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹ ${totalValue.toStringAsFixed(0)}',
                          style: AppTextTheme.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColor.blackText,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    top: 0,
                    child: SafeBackgroundImage(
                      imagePath: 'assets/images/assetsBOverview.png',
                      fit: BoxFit.contain,
                      fallback: Icon(Icons.location_city_rounded,
                          size: 80, color: Colors.grey.withValues(alpha: 0.2)),
                    ),
                  ),
                ],
              ),
            ),

            // List of Assets
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                itemCount: assets.length > 5 ? 5 : assets.length, // Show max 5
                separatorBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                ),
                itemBuilder: (context, index) {
                  final asset = assets[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            asset.name,
                            style: AppTextTheme.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: HexColor('#525252'),
                            ),
                          ),
                          Text(
                            'Investments', // Or asset.type if mapped
                            style: AppTextTheme.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '₹${asset.currentValue.toStringAsFixed(0)}',
                        style: AppTextTheme.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: HexColor('#525252'),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
