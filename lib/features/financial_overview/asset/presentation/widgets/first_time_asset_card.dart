import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:mono/core/constants/app_textstyle/app_textstyle.dart';
import 'package:mono/core/theme/app_theme.dart';
import '../../../../../core/constants/colors/app_colors.dart';
import '../../../../../core/theme/app_texttheme.dart';
import '../../../widgets/safe_background_image.dart';
import 'package:mono/core/utils/extension/context_extension.dart';
import '../../../../../core/analytics/analytics_service.dart';
import '../../../../../core/di/injection_container.dart';

class FirstTimeAssetCard extends StatefulWidget {
  const FirstTimeAssetCard({super.key});

  @override
  State<FirstTimeAssetCard> createState() => _FirstTimeAssetCardState();
}

class _FirstTimeAssetCardState extends State<FirstTimeAssetCard> {
  bool _showCard = true;
  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
        duration: const Duration(milliseconds: 300),
        reverse: !_showCard,
        transitionBuilder: (Widget child, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return SharedAxisTransition(
              fillColor: Colors.transparent,
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child);
        },
        child: _showCard
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    _showCard = !_showCard;
                  });
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .extension<AppGradients>()!
                        .assetCardTheme,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColor.borderGreyWhite),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    // gradient: LinearGradient(
                    //   colors: [
                    //     HexColor('#E6F5F4'),
                    //     HexColor('#F0FDFB'),
                    //   ],
                    //   begin: Alignment.topLeft,
                    //   end: Alignment.bottomRight,
                    // ),
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
                            imagePath:
                                'assets/images/building4x.png', // Placeholder
                            fit: BoxFit.contain,
                            fallback: Icon(Icons.location_city_rounded,
                                size: 80,
                                color: Colors.grey.withValues(alpha: 0.2)),
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
                                    color: Theme.of(context)
                                        .extension<AppGradients>()!
                                        .textTheme,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  context.l10n.first_time_asset_title,
                                  style: AppTextTheme.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context)
                                        .extension<AppGradients>()!
                                        .textTheme,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width:
                                  200, // Limit width to avoid overlapping image
                              child: Text(
                                context.l10n.first_time_asset_subtitle,
                                style: AppTextTheme.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).disabledColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 74),
                            SizedBox(
                              width: 140,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _showCard = !_showCard;
                                  });
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) => const AddAssetScreen()),
                                  // );
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .extension<AppGradients>()!
                                          .disableCardColor,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: Theme.of(context)
                                              .extension<AppGradients>()!
                                              .disableCardColor,
                                          width: 2
                                          // color: HexColor('#21988C'),
                                          ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.05),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    context.l10n.first_time_asset_button,
                                    style: AppTextTheme.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      // color: HexColor('#2D6763'),
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
                ),
              )
            : InkWell(
                onTap: () {
                  setState(() {
                    _showCard = !_showCard;
                  });
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .extension<AppGradients>()!
                        .assetCardTheme,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColor.borderGreyWhite),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    // gradient: LinearGradient(
                    //   colors: [
                    //     HexColor('#E6F5F4'),
                    //     HexColor('#F0FDFB'),
                    //   ],
                    //   begin: Alignment.topLeft,
                    //   end: Alignment.bottomRight,
                    // ),
                  ),
                  child: Stack(
                    children: [
                      //   Background Cityscape (Right side)
                      Positioned(
                        right: 10,
                        top: 20,
                        width: 150,
                        child: Opacity(
                          opacity: 0.8,
                          child: SafeBackgroundImage(
                            imagePath:
                                'assets/images/building4x.png', // Placeholder
                            fit: BoxFit.contain,
                            fallback: Icon(Icons.location_city_rounded,
                                size: 80,
                                color: Colors.grey.withValues(alpha: 0.2)),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.l10n.first_time_asset_title_expanded,
                              style: AppTextTheme.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context)
                                    .extension<AppGradients>()!
                                    .textTheme,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width:
                                  200, // Limit width to avoid overlapping image
                              child: Text(
                                '\u2022 ${context.l10n.first_time_asset_feature_1}',
                                style: AppTextTheme.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).disabledColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '\u2022 ${context.l10n.first_time_asset_feature_2}',
                              style: AppTextTheme.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).disabledColor,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '\u2022 ${context.l10n.first_time_asset_feature_3}',
                              style: AppTextTheme.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).disabledColor,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '\u2022 ${context.l10n.first_time_asset_feature_4}',
                              style: AppTextTheme.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).disabledColor,
                              ),
                            ),
                            const SizedBox(height: 24),
                            /*   GestureDetector(
                              onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AddAssetScreen()),
                            );
                            },
                              child: Padding(
                                padding: EdgeInsets.only(right: 16.w),
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: HexColor('#21988C'),
                                          width: 1.5),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.05),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    'Join early access',
                                    style: AppTextTheme.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: HexColor('#2D6763'),
                                    ),
                                  ),
                                ),
                              ),
                            ),*/

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  sl<AnalyticsService>()
                                      .logAssetNotificationTap();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Done! We'll notify you once assets are launched.",
                                        style: AppTextTheme.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                      backgroundColor: Theme.of(context)
                                          .secondaryHeaderColor,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  "🔔 ${context.l10n.first_time_asset_notification}",
                                  style:
                                      AppTextStyles.roboto18w600SemiBoldWhite(
                                              context)!
                                          .copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ));
  }
}
