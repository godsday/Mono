import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../presentation/providers/goals_provider.dart';
import 'goal_filter.dart';

/// Segmented toggle for switching between In Progress / Completed goals.
///
/// Filter state lives in [GoalsProvider] so every Consumer (including the
/// goals list in [GoalsOverviewCard]) rebuilds automatically.
class GoalsSection extends StatelessWidget {
  const GoalsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GoalsProvider>(
      builder: (context, provider, _) {
        // Hide the toggle entirely when there are no completed goals.
        if (provider.completedCount == 0) {
          // Auto-reset to inProgress in case user was on Completed tab
          // when the last completed goal was removed.
          if (provider.selectedFilter == GoalFilter.completed) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              provider.setGoalFilter(GoalFilter.inProgress);
            });
          }
          return const SizedBox.shrink();
        }

        return SegmentedButton<GoalFilter>(
          segments: const [
            ButtonSegment(
                value: GoalFilter.inProgress, label: Text('In Progress')),
            ButtonSegment(
                value: GoalFilter.completed, label: Text('Completed')),
          ],
          selected: <GoalFilter>{provider.selectedFilter},
          onSelectionChanged: (newSelection) {
            provider.setGoalFilter(newSelection.first);
          },
          style: SegmentedButton.styleFrom(
            backgroundColor: Colors.transparent,
            side: const BorderSide(color: Colors.transparent),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
          ),
        );
      },
    );
  }
}
