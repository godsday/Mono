import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constants/colors/app_colors.dart';
import '../../../../../core/theme/app_texttheme.dart';
import '../../domain/entities/asset_entity.dart';
import '../pages/add_asset_screen.dart';
import '../providers/assets_provider.dart';

class AssetsOverviewCard extends StatelessWidget {
  const AssetsOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AssetsProvider>(
      builder: (context, provider, child) {
        final assets = provider.assets;
        final totalValue = provider.totalAssetValue;

        if (assets.isEmpty) {
          // This should handle the edge case where loadAssets returns empty list,
          // though ideally parent widget checks this first.
          return const SizedBox.shrink();
        }

        return Container(
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
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      color: AppColor.mainHexcolor,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Assets',
                      style: AppTextTheme.montserrart(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColor.mainHexcolor,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddAssetScreen()),
                        );
                      },
                      child: Text(
                        'Add +',
                        style: AppTextTheme.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColor.accentHexColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Total Assets Value',
                  style: AppTextTheme.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '₹${totalValue.toStringAsFixed(0)}',
                  style: AppTextTheme.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColor.mainHexcolor,
                  ),
                ),
                const SizedBox(height: 15),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: assets.length > 3 ? 3 : assets.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final asset = assets[index];
                    return _AssetItem(asset: asset);
                  },
                ),
                if (assets.length > 3) ...[
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      '+ ${assets.length - 3} more',
                      style: AppTextTheme.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  )
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AssetItem extends StatelessWidget {
  final AssetEntity asset;

  const _AssetItem({required this.asset});

  @override
  Widget build(BuildContext context) {
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
                fontWeight: FontWeight.w500,
                color: AppColor.mainHexcolor,
              ),
            ),
            Text(
              asset.type,
              style: AppTextTheme.poppins(
                fontSize: 12,
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
            color: AppColor.mainHexcolor,
          ),
        ),
      ],
    );
  }
}
