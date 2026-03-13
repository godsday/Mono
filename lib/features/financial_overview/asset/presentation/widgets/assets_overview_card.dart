import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import '../../../../../core/constants/colors/app_colors.dart';
import '../../../../../core/theme/app_texttheme.dart';
import 'package:mono/core/utils/extension/context_extension.dart';
import '../pages/add_asset_screen.dart';
import '../../../widgets/safe_background_image.dart';
import '../../../asset/domain/entities/asset_entity.dart';

// Module-level cached values – constructed once on first import.
final _textColor = HexColor('#525252');
final _cardGradient = LinearGradient(
  colors: [HexColor('#E6F5F4'), HexColor('#F0FDFB')],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

/// Accepts [assets] and [totalValue] directly from the parent Consumer so a
/// second Consumer<AssetsProvider> is not needed inside this widget.
class AssetsOverviewCard extends StatelessWidget {
  final List<AssetEntity> assets;
  final double totalValue;

  const AssetsOverviewCard({
    super.key,
    required this.assets,
    required this.totalValue,
  });

  @override
  Widget build(BuildContext context) {
    final displayCount = assets.length > 5 ? 5 : assets.length;

    return Column(
      children: [
        // Summary Card
        Container(
          width: double.infinity,
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000), // black 10%
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
            gradient: _cardGradient,
          ),
          child: Stack(
            children: [
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
                            Icon(Icons.account_balance_wallet,
                                color: AppColor.blackText, size: 20),
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
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const AddAssetScreen()),
                          ),
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
                      context.formatCurrency(totalValue),
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

        const SizedBox(height: 16),

        // Asset list
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Color(0x0D000000), // black 5%
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.all(16),
            itemCount: displayCount,
            separatorBuilder: (_, __) => const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Divider(height: 1, color: Color(0xFFEEEEEE)),
            ),
            itemBuilder: (_, index) => _AssetItem(asset: assets[index]),
          ),
        ),
      ],
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
                fontWeight: FontWeight.w600,
                color: _textColor,
              ),
            ),
            Text(
              'Investments',
              style: AppTextTheme.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        Text(
          context.formatCurrency(asset.currentValue),
          style: AppTextTheme.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _textColor,
          ),
        ),
      ],
    );
  }
}
