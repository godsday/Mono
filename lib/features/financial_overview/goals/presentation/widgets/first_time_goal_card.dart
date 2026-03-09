import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:mono/core/constants/app_textstyle/app_textstyle.dart';
import 'package:mono/core/theme/app_theme.dart';
import '../../../../../core/constants/colors/app_colors.dart';
import '../../../../../core/theme/app_texttheme.dart';
import '../../../widgets/safe_background_image.dart';
import 'package:mono/core/utils/extension/context_extension.dart';

class FirstTimeGoalCard extends StatefulWidget {
  const FirstTimeGoalCard({super.key});

  @override
  State<FirstTimeGoalCard> createState() => _FirstTimeGoalCardState();
}

class _FirstTimeGoalCardState extends State<FirstTimeGoalCard> {
  bool _showCard = true;
  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      duration: const Duration(milliseconds: 300),
      reverse: !_showCard,
      transitionBuilder: (Widget child, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return SharedAxisTransition(
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
                      .goalCardTheme,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColor.borderGreyWhite
                          : AppColor.borderBlueColor,
                      width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Background Illustration (Right side)
                    Positioned(
                      right: 0,
                      top: 0,
                      width: 200,
                      child: Opacity(
                        opacity: 1,
                        child: SafeBackgroundImage(
                          imagePath: 'assets/images/boat4x.png',
                          fit: BoxFit.contain,
                          fallback: Icon(Icons.kayaking,
                              size: 80,
                              color: Colors.grey.withValues(alpha: 0.2)),
                        ),
                      ),
                    ),

                    Theme.of(context).brightness == Brightness.light
                        ? Positioned(
                            bottom: 0,
                            left: 10,
                            width: 170,
                            child: Opacity(
                              opacity: 1,
                              child: SafeBackgroundImage(
                                imagePath: 'assets/images/arrow4x.png',
                                fit: BoxFit.contain,
                                fallback: Icon(Icons.kayaking,
                                    size: 80,
                                    color: Colors.grey.withValues(alpha: 0.2)),
                              ),
                            ),
                          )
                        : const SizedBox(),

                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.first_time_goal_title,
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
                            width: 200,
                            child: Text(
                              context.l10n.first_time_goal_subtitle,
                              style: AppTextTheme.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Theme.of(context).disabledColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 80),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _showCard = !_showCard;
                                  });
                                  /*   Navigator.push(
                                   context,
                                    MaterialPageRoute(
                                       builder: (context) =>
                                           const AddGoalScreen()),
                                  );*/
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .extension<AppGradients>()!
                                          .disableCardColor,
                                      borderRadius: BorderRadius.circular(12),
                                      // gradient: LinearGradient(
                                      //   end: Alignment.bottomRight,
                                      //   begin: Alignment.topLeft,
                                      // colors: [
                                      //   HexColor('#429690'),
                                      //   HexColor('#1E4744').withValues(alpha: 0.8),
                                      // ],
                                      // ),
                                      border: Border.all(
                                          width: 2,
                                          color: Theme.of(context)
                                              .extension<AppGradients>()!
                                              .disableCardColor),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context)
                                              .extension<AppGradients>()!
                                              .disableCardColor,
                                          // color: HexColor('#3C7570')
                                          //     .withValues(alpha: 0.3),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ]),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 24),
                                  child: Text(
                                    context.l10n.first_time_goal_button,
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
                      .goalCardTheme,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColor.borderGreyWhite
                          : AppColor.borderBlueColor,
                      width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Background Illustration (Right side)
                    Positioned(
                      right: 0,
                      top: 0,
                      width: 200,
                      child: Opacity(
                        opacity: 1,
                        child: SafeBackgroundImage(
                          imagePath: 'assets/images/boat4x.png',
                          fit: BoxFit.contain,
                          fallback: Icon(Icons.kayaking,
                              size: 80,
                              color: Colors.grey.withValues(alpha: 0.2)),
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 0,
                      left: 10,
                      width: 170,
                      child: Opacity(
                        opacity: 1,
                        child: SafeBackgroundImage(
                          imagePath: 'assets/images/arrow4x.png',
                          fit: BoxFit.contain,
                          fallback: Icon(Icons.kayaking,
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
                          Text(
                            "🎯 ${context.l10n.first_time_goal_title_expanded}",
                            style: AppTextTheme.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context)
                                  .extension<AppGradients>()!
                                  .textTheme,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            '\u2022 ${context.l10n.first_time_goal_feature_1}',
                            style: AppTextTheme.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '\u2022 ${context.l10n.first_time_goal_feature_2}',
                            style: AppTextTheme.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '\u2022 ${context.l10n.first_time_goal_feature_3}',
                            style: AppTextTheme.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '\u2022 ${context.l10n.first_time_goal_feature_4}',
                            style: AppTextTheme.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                context.l10n.first_time_goal_coming_soon,
                                style: AppTextStyles.roboto18w600SemiBoldWhite(
                                        context)!
                                    .copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).primaryColor,
                                ),

                                //  Container(
                                //   decoration: BoxDecoration(
                                //       color: Colors.blueGrey.shade100,
                                //       borderRadius: BorderRadius.circular(12),
                                // gradient: LinearGradient(
                                //   end: Alignment.bottomRight,
                                //   begin: Alignment.topLeft,
                                // colors: [
                                //   HexColor('#429690'),
                                //   HexColor('#1E4744').withValues(alpha: 0.8),
                                // ],
                                // ),
                                //     border: Border.all(
                                //         width: 2,
                                //         color: Colors.blueGrey.shade100),
                                //     boxShadow: [
                                //       BoxShadow(
                                //         color: Colors.blueGrey.shade100,
                                //         // color: HexColor('#3C7570')
                                //         //     .withValues(alpha: 0.3),
                                //         blurRadius: 6,
                                //         offset: const Offset(0, 3),
                                //       ),
                                //     ]),
                                // padding: const EdgeInsets.symmetric(
                                //     vertical: 12, horizontal: 24),
                                // child: Text(
                                //   'Start Dreaming',
                                //   style: AppTextTheme.poppins(
                                //     fontSize: 16,
                                //     fontWeight: FontWeight.w600,
                                //     color: Colors.white,
                                //   ),
                                // ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
