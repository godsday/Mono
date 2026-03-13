import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mono/core/constants/app_textstyle/app_textstyle.dart';
import 'package:mono/core/theme/app_theme.dart' show AppGradients;
import 'package:mono/features/financial_overview/budget/presentation/widgets/budget_header_clipper.dart';
import 'package:mono/features/financial_overview/budget/presentation/widgets/categories_spending.dart';
import 'package:mono/core/utils/extension/context_extension.dart';
import 'package:mono/routes/route_names.dart';
import 'package:sizer/sizer.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import '../../../../../core/constants/colors/app_colors.dart';
import '../../../../../core/theme/app_texttheme.dart';
import '../../domain/entities/budget_entity.dart';

// Cached colours – never re-allocated after start-up.
final _iconColor = HexColor('#7D73C2');
final _editTextColor = HexColor('#525252');

class BudgetOverviewCard extends StatefulWidget {
  final BudgetEntity budget;

  const BudgetOverviewCard({
    super.key,
    required this.budget,
  });

  @override
  State<BudgetOverviewCard> createState() => _BudgetOverviewCardState();
}

class _BudgetOverviewCardState extends State<BudgetOverviewCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Compute once per build – not per sub-widget.
    final gradients = Theme.of(context).extension<AppGradients>()!;
    final progress = widget.budget.totalBudget > 0
        ? (widget.budget.spentAmount / widget.budget.totalBudget)
            .clamp(0.0, 1.0)
        : 0.0;
    // DateFormat is inexpensive to construct but format() calls are cheap;
    // still worth caching the locale-dependent string here once per build.
    final monthName = DateFormat.MMMM(
      Localizations.localeOf(context).languageCode,
    ).format(DateTime.now());

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColor.borderGreyWhite),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000), // black 10%
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        gradient: gradients.budgetLinearGradient,
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom Header Row
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // White Tab with Title
                    ClipPath(
                      clipper: const CustomShapeClipper(
                        topLeftRadius: 24.0,
                        topRightRadius: 6.0,
                        bottomSlant: 24.0,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                        ),
                        height: 4.5.h,
                        constraints: BoxConstraints(minWidth: 50.w),
                        child: Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.account_balance_wallet,
                                color: _iconColor,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                context.l10n.budget_overview_title,
                                style: AppTextStyles.roboto16w600Black.copyWith(
                                  color: gradients.textTheme,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Edit Button
                    Padding(
                      padding: const EdgeInsets.only(top: 12, right: 20),
                      child: GestureDetector(
                        onTap: () async {
                          await Navigator.pushNamed(
                            context,
                            RouteNames.addBudget,
                            arguments: widget.budget,
                          );
                        },
                        child: Text(
                          context.l10n.action_edit,
                          style: AppTextTheme.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _editTextColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.budget_set_for(monthName),
                      style: AppTextTheme.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _editTextColor,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Animated Progress Bar – only this subtree re-renders
                    // during the animation thanks to AnimatedBuilder.
                    Stack(
                      children: [
                        Container(
                          height: 8,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        AnimatedBuilder(
                          animation: _animation,
                          builder: (context, _) {
                            final progressColor = progress >= 1.0
                                ? Colors.redAccent
                                : progress >= 0.8
                                    ? Colors.orangeAccent
                                    : Colors.white;
                            final widthFactor =
                                (_animation.value * progress).clamp(0.01, 1.0);

                            return FractionallySizedBox(
                              widthFactor: widthFactor,
                              child: Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: progressColor,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    if (progress >= 1.0)
                      Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded,
                              color: Colors.redAccent, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            context.l10n.budget_limit_exceeded,
                            style: AppTextTheme.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      )
                    else if (progress >= 0.8)
                      Row(
                        children: [
                          Icon(Icons.info_outline,
                              color: Colors.orange.shade700, size: 16),
                          const SizedBox(width: 4),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.74,
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                context.l10n.budget_limit_warning,
                                style: AppTextTheme.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 16),

                    // 3 Columns: Budget, Spending, Remaining
                    Row(
                      children: [
                        Expanded(
                          child: _InfoColumn(
                            label: context.l10n.budget_label_budget,
                            value: context
                                .formatCurrency(widget.budget.totalBudget),
                            gradients: gradients,
                          ),
                        ),
                        Expanded(
                          child: _InfoColumn(
                            label: context.l10n.budget_label_spending,
                            value: context
                                .formatCurrency(widget.budget.spentAmount),
                            isAlert: progress >= 1.0,
                            gradients: gradients,
                          ),
                        ),
                        Expanded(
                          child: _InfoColumn(
                            label: context.l10n.budget_label_remaining,
                            value: context
                                .formatCurrency(widget.budget.remainingAmount),
                            isAlert: progress >= 1.0,
                            gradients: gradients,
                          ),
                        ),
                      ],
                    ),

                    // Categories – only shown when the list is non-empty.
                    if (widget.budget.categories.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      CategoriesSpendingCard(
                        title: context.l10n.categories_title,
                        categories: widget.budget.categories,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Extracted from an inline helper method into a proper [StatelessWidget] so
/// Flutter's element tree can skip rebuilding unchanged columns.
class _InfoColumn extends StatelessWidget {
  final String label;
  final String value;
  final bool isAlert;
  final AppGradients gradients;

  const _InfoColumn({
    required this.label,
    required this.value,
    required this.gradients,
    this.isAlert = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextTheme.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).disabledColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.roboto18w600SemiBoldWhite(context)!.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isAlert ? Colors.redAccent : gradients.textTheme,
          ),
        ),
      ],
    );
  }
}
