import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mono/core/constants/app_textstyle/app_textstyle.dart';
import 'package:mono/core/utils/extension/context_extension.dart';
import 'package:mono/features/financial_overview/widgets/safe_background_image.dart';
import 'package:sizer/sizer.dart';
import '../../../../../core/constants/colors/app_colors.dart';
import '../../../../../core/theme/app_texttheme.dart';
import '../../domain/entities/goal_entity.dart';
import '../pages/add_goal_screen.dart';

// Module-level cached colours – allocated once, never again.
final _borderColor = const Color(0xffA5C9FF);
final _shadowColor = const Color(0xffA5C9FF).withValues(alpha: 0.2);
final _headerGradient = LinearGradient(
  colors: [HexColor('#EBF5FF'), HexColor('#F5FAFF')],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
final _progressBgColor = HexColor('#E0E0E0');
final _progressBarColor = HexColor('#3C7570');
final _percentColor = HexColor('#C4867C');

/// Accepts [goals] directly from the parent Consumer so a second
/// Consumer [GoalsProvider] is not needed inside this widget.
class GoalsOverviewCard extends StatelessWidget {
  final List<GoalEntity> goals;

  const GoalsOverviewCard({super.key, required this.goals});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _borderColor, width: 1.5),
        boxShadow: [
          BoxShadow(
              color: _shadowColor, blurRadius: 20, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 9.h,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33000000), // black 20%
                  blurRadius: 20,
                  offset: Offset(0, 4),
                ),
              ],
              gradient: _headerGradient,
            ),
            child: Stack(
              children: [
                // Positioned(
                //   left: 9.w,
                //   child: SafeBackgroundImage(
                //     imagePath: 'assets/images/arrow-first.png',
                //     fit: BoxFit.contain,
                //     fallback: Icon(Icons.kayaking,
                //         size: 80, color: Colors.grey.withValues(alpha: 0.2)),
                //   ),
                // ),
                Positioned(
                  right: 0,
                  top: 0,
                  height: 15.h,
                  child: Opacity(
                    opacity: 0.9,
                    child: SafeBackgroundImage(
                      imagePath: 'assets/images/boat4x.png',
                      fit: BoxFit.contain,
                      fallback: Icon(Icons.kayaking,
                          size: 50, color: Colors.grey.withValues(alpha: 0.2)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.flag_rounded,
                              color: Colors.blue, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            'Goals',
                            style: AppTextStyles.roboto18w600SemiBoldWhite(
                                    context)!
                                .copyWith(
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
                              builder: (_) => const AddGoalScreen()),
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
                ),
              ],
            ),
          ),
          SizedBox(height: .5.h),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
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
              padding: const EdgeInsets.all(20),
              itemCount: goals.length > 5 ? 5 : goals.length,
              separatorBuilder: (_, __) => const SizedBox(height: 24),
              itemBuilder: (_, index) => _GoalItem(goal: goals[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalItem extends StatelessWidget {
  final GoalEntity goal;

  const _GoalItem({required this.goal});

  @override
  Widget build(BuildContext context) {
    // Pre-compute the percentage string once instead of in multiple Text nodes.
    final pct = '${(goal.progress * 100).toStringAsFixed(0)} %';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              goal.title,
              style: AppTextTheme.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColor.blackText,
              ),
            ),
            Text(
              pct,
              style: AppTextTheme.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _percentColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: goal.progress,
          backgroundColor: _progressBgColor,
          // AlwaysStoppedAnimation is cached per item here via final field.
          valueColor: AlwaysStoppedAnimation<Color>(_progressBarColor),
          borderRadius: BorderRadius.circular(4),
          minHeight: 4,
        ),
        const SizedBox(height: 6),
        Text(
          '${context.formatCurrency(goal.savedAmount)} / ${context.formatCurrency(goal.targetAmount)}',
          style: AppTextTheme.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
