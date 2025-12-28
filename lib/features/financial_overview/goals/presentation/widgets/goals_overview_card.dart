import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
                      Icons.star_outline_rounded,
                      color: AppColor.mainHexcolor,
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Dreams / Goals',
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
                              builder: (context) => const AddGoalScreen()),
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

                // Overall Progress logic
                // Maybe show a big progress bar for overall, or just list the goals?
                // The requirements said: "Show goal cards, Show progress bars"
                // Let's show individual goals as mini-cards or list items with progress bars.

                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: goals.length > 3 ? 3 : goals.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    final goal = goals[index];
                    return _GoalItem(goal: goal);
                  },
                ),
                if (goals.length > 3) ...[
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      '+ ${goals.length - 3} more',
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
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColor.mainHexcolor,
              ),
            ),
            Text(
              '${(goal.progress * 100).toStringAsFixed(0)}%',
              style: AppTextTheme.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColor.accentHexColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: goal.progress,
          backgroundColor: AppColor.accentHexColor.withValues(alpha: 0.2),
          valueColor: AlwaysStoppedAnimation<Color>(
            goal.isCompleted ? const Color(0xFF4CAF50) : AppColor.mainHexcolor,
          ),
          borderRadius: BorderRadius.circular(4),
          minHeight: 6,
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '₹${goal.savedAmount.toStringAsFixed(0)} / ₹${goal.targetAmount.toStringAsFixed(0)}',
              style: AppTextTheme.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.grey,
              ),
            ),
            if (goal.isCompleted)
              Text(
                'Completed',
                style: AppTextTheme.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF4CAF50),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
