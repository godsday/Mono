import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import '../../../../../core/constants/colors/app_colors.dart';
import '../../../../../core/theme/app_texttheme.dart';
import '../../domain/entities/goal_entity.dart';
import '../pages/add_goal_screen.dart';
import '../providers/goals_provider.dart';

class GoalsOverviewCard extends StatelessWidget {
  const GoalsOverviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GoalsProvider>(
      builder: (context, provider, child) {
        final goals = provider.goals;

        if (goals.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            // Summary Card
            Container(
              width: double.infinity,
              height: 120, // Smaller height as per design image
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
                    HexColor('#EBF5FF'),
                    HexColor('#F5FAFF'),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  // Background Illustration
                  Positioned(
                    right: 0,
                    bottom: 0,
                    top: 0,
                    width: 150,
                    child: Opacity(
                      opacity: 0.6,
                      child: Image.asset('assets/images/boat-first.png'
                          // fit: BoxFit.cover,
                          //    Icon(Icons.kayaking,
                          //       size: 80,
                          //       color: Colors.grey.withValues(alpha: 0.2)),
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
                            Icon(Icons.flag_rounded,
                                color: AppColor.blackText, size: 22),
                            const SizedBox(width: 8),
                            Text(
                              'Goals',
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
                                  builder: (context) => const AddGoalScreen()),
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
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Goals List
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
                padding: const EdgeInsets.all(20),
                itemCount: goals.length > 5 ? 5 : goals.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 24),
                itemBuilder: (context, index) {
                  final goal = goals[index];
                  return _GoalItem(goal: goal);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _GoalItem extends StatelessWidget {
  final GoalEntity goal;

  const _GoalItem({required this.goal});

  @override
  Widget build(BuildContext context) {
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
              '${(goal.progress * 100).toStringAsFixed(0)} %',
              style: AppTextTheme.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: HexColor('#C4867C'), // Reddish/Brown text from image
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: goal.progress,
          backgroundColor: HexColor('#E0E0E0'),
          valueColor: AlwaysStoppedAnimation<Color>(
            // Use a teal/blue color mostly
            HexColor('#3C7570'),
          ),
          borderRadius: BorderRadius.circular(4),
          minHeight: 4,
        ),
        const SizedBox(height: 6),
        Text(
          '₹${goal.savedAmount.toStringAsFixed(0)}/₹${goal.targetAmount.toStringAsFixed(0)}',
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
