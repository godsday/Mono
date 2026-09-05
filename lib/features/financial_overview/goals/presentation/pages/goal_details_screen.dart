import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mono/core/theme/app_theme.dart';
import 'package:mono/features/widgets/decoration_widgets/app_button_decoration.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../../core/constants/colors/app_colors.dart';
import '../../../../../core/theme/app_texttheme.dart';
import '../../../../../core/utils/extension/context_extension.dart';
import '../../../../../routes/route_names.dart';
import '../../domain/entities/goal_entity.dart';
import '../providers/goals_provider.dart';

class GoalDetailsScreen extends StatefulWidget {
  final GoalEntity goal;

  const GoalDetailsScreen({super.key, required this.goal});

  @override
  State<GoalDetailsScreen> createState() => _GoalDetailsScreenState();
}

class _GoalDetailsScreenState extends State<GoalDetailsScreen> {
  void _openAddMoneyBottomSheet(GoalEntity activeGoal) {
    final amountController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.add_money_title,
                    style: AppTextTheme.montserrart(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColor.blackText,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${context.l10n.remaining_label}: ${context.formatCurrency(activeGoal.remainingAmount)}',
                    style: AppTextTheme.poppins(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: amountController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: context.l10n.transaction_amount_hint,
                      prefixIcon:
                          const Icon(Icons.account_balance_wallet_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide:
                            BorderSide(color: AppColor.mainHexcolor, width: 2),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return context.l10n.amount_required_error;
                      }
                      final parsed = double.tryParse(val.trim());
                      if (parsed == null || parsed <= 0) {
                        return context.l10n.amount_greater_than_zero_error;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) return;
                        final amount =
                            double.parse(amountController.text.trim());
                        Navigator.pop(bottomSheetContext);

                        await context
                            .read<GoalsProvider>()
                            .addContribution(activeGoal.id, amount);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.mainHexcolor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        context.l10n.add_money_title,
                        style: AppTextTheme.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _confirmDeleteGoal(GoalEntity activeGoal) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            context.l10n.delete_goal_title,
            style: AppTextTheme.montserrart(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            context.l10n.delete_goal_confirmation,
            style: AppTextTheme.poppins(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Cancel',
                style: AppTextTheme.poppins(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogContext);
                await context.read<GoalsProvider>().deleteGoal(activeGoal.id);
                if (mounted) {
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                context.l10n.action_delete,
                style: AppTextTheme.poppins(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatContributionDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final itemDate = DateTime(date.year, date.month, date.day);

    if (itemDate == today) {
      return 'Today';
    } else if (itemDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    }
    return DateFormat('dd MMM yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GoalsProvider>(
      builder: (context, provider, _) {
        final activeGoal = provider.goals.firstWhere(
          (g) => g.id == widget.goal.id,
          orElse: () => widget.goal,
        );

        final targetDateStr =
            DateFormat('dd MMM yyyy').format(activeGoal.deadline);
        final pctStr = '${(activeGoal.progress * 100).toStringAsFixed(0)}%';

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            bottom: false,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _buildHeader(activeGoal),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(20.0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProgressCard(activeGoal, pctStr, targetDateStr),
                        const SizedBox(height: 20),
                        _buildMetricsGrid(activeGoal),
                        const SizedBox(height: 24),
                        _buildAddMoneyButton(activeGoal),
                        if (!activeGoal.isCompleted) const SizedBox(height: 28),
                        _buildContributionHistory(activeGoal),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(GoalEntity activeGoal) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 20, bottom: 28, left: 16, right: 16),
      decoration: BoxDecoration(
        gradient: Theme.of(context).brightness == Brightness.dark
            ? AppColor.darkThemeGradient
            : AppColor.mainGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.mainHexcolor.withValues(alpha: 0.25),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon:
                          const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: .5.w),
                    Text(
                      activeGoal.title,
                      style: AppTextTheme.montserrart(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Row(
                  children: [
                    if (!activeGoal.isCompleted) ...[
                      IconButton(
                        icon: const Icon(Icons.edit_outlined,
                            color: Colors.white),
                        tooltip: context.l10n.edit_goal_title,
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            RouteNames.addGoal,
                            arguments: activeGoal,
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            color: Colors.white),
                        tooltip: context.l10n.delete_goal_title,
                        onPressed: () => _confirmDeleteGoal(activeGoal),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                activeGoal.isCompleted
                    ? '🎉 ${context.l10n.first_time_goal_title}'
                    : '🎯 In Progress',
                style: AppTextTheme.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(
      GoalEntity activeGoal, String pctStr, String targetDateStr) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColor.borderGreyWhite),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                activeGoal.isCompleted
                    ? "Congrats 🎉"
                    : context.l10n.progress_label,
                style: AppTextTheme.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).extension<AppGradients>()!.textTheme,
                ),
              ),
              Text(
                pctStr,
                style: AppTextTheme.montserrart(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: activeGoal.progress,
              minHeight: 10,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.blue
                      : AppColor.mainHexcolor),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${context.l10n.target_date_label}:',
                style: AppTextTheme.poppins(
                  fontSize: 13,
                  color: Theme.of(context).disabledColor,
                ),
              ),
              Text(
                targetDateStr,
                style: AppTextTheme.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).disabledColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(GoalEntity activeGoal) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildMetricTile(
                title: context.l10n.target_amount_label,
                value: context.formatCurrency(activeGoal.targetAmount),
                icon: Icons.flag_outlined,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildMetricTile(
                title: context.l10n.saved_label,
                value: context.formatCurrency(activeGoal.savedAmount),
                icon: Icons.account_balance_wallet_outlined,
                color: Colors.green,
              ),
            ),
          ],
        ),
        if (!activeGoal.isCompleted) const SizedBox(height: 14),
        if (!activeGoal.isCompleted)
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  title: context.l10n.remaining_label,
                  value: context.formatCurrency(activeGoal.remainingAmount),
                  icon: Icons.hourglass_bottom_outlined,
                  color: Colors.orangeAccent,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildMetricTile({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(color: AppColor.borderGreyWhite),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: AppTextTheme.poppins(
                    fontSize: 12,
                    color: Theme.of(context).disabledColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTextTheme.montserrart(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).extension<AppGradients>()!.textTheme,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAddMoneyButton(GoalEntity activeGoal) {
    if (activeGoal.isCompleted) {
      return const SizedBox.shrink();
    }
    return AppElevetedButton(
      height: 6.h,
      onPressed: () => _openAddMoneyBottomSheet(activeGoal),
      // icon: const Icon(Icons.add_circle_outline, color: Colors.white),
      appButtonText: context.l10n.add_money_button,
      // style: AppTextTheme.poppins(
      //   fontSize: 16,
      //   fontWeight: FontWeight.w600,
      //   color: Theme.of(context).scaffoldBackgroundColor,
    );

    // style: ElevatedButton.styleFrom(
    //   backgroundColor: Theme.of(context).extension<AppGradients>()!.primaryGradient,

    //   padding: const EdgeInsets.symmetric(vertical: 16),
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(18),
    //   ),
    //   elevation: 0,
    // ),
    //   ),
    // ),
  }

  Widget _buildContributionHistory(GoalEntity activeGoal) {
    final contributions = activeGoal.contributions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.contribution_history_title,
          style: AppTextTheme.montserrart(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).extension<AppGradients>()!.textTheme,
          ),
        ),
        const SizedBox(height: 14),
        if (contributions.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColor.borderGreyWhite),
            ),
            child: Column(
              children: [
                Icon(Icons.history, size: 40, color: Colors.grey[300]),
                const SizedBox(height: 8),
                Text(
                  context.l10n.no_contributions_yet,
                  style: AppTextTheme.poppins(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.all(16),
              itemCount: contributions.length,
              separatorBuilder: (_, __) => Divider(color: Colors.grey[200]),
              itemBuilder: (context, index) {
                final item = contributions[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_upward_rounded,
                              color: Colors.green,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '+ ${context.formatCurrency(item.amount)}',
                                style: AppTextTheme.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.blackText,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        _formatContributionDate(item.date),
                        style: AppTextTheme.poppins(
                          fontSize: 13,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
