import 'package:flutter/material.dart';
import 'package:mono/core/constants/app_textstyle/app_textstyle.dart';
import 'package:mono/features/financial_overview/budget/presentation/widgets/budget_header_clipper.dart';
import 'package:mono/features/financial_overview/budget/presentation/widgets/categories_spending.dart';
import 'package:mono/routes/route_names.dart';
import 'package:sizer/sizer.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:intl/intl.dart';
import '../../../../../core/constants/colors/app_colors.dart';
import '../../../../../core/theme/app_texttheme.dart';
import '../../domain/entities/budget_entity.dart';

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
    // Calculate progress (spending)
    double progress = widget.budget.totalBudget > 0
        ? (widget.budget.spentAmount / widget.budget.totalBudget)
            .clamp(0.0, 1.0)
        : 0.0;

    return Container(
      width: double.infinity,
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
            HexColor('#B2AFE8').withValues(alpha: 0.9),
            HexColor('#D3D0F7'),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
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
                      // clipBehavior: CustomRectClipper,
                      child: Container(
                        color: Colors.white,
                        height: 4.h,
                        width: 50.w,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.account_balance_wallet,
                                color: HexColor('#7D73C2'),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Monthly Budget',
                                style: AppTextStyles.roboto16w600Black.copyWith(
                                    fontWeight: FontWeight.w700, fontSize: 18),
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
                          // final result =
                          await Navigator.pushNamed(
                              context, RouteNames.addBudget,
                              arguments: widget.budget);

                          // if (result == true && context.mounted) {
                          //   context.read<BudgetProvider>().loadBudget();
                          //   context
                          //       .read<AddBudgetProvider>()
                          //       .updateTotalBudget(widget.budget.totalBudget);
                          // }
                        },
                        child: Text(
                          'Edit',
                          style: AppTextTheme.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: HexColor('#525252'),
                          ),
                        ),
                      ),
                    )
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
                      'Budget set for ${DateFormat.MMMM().format(DateTime.now())}',
                      style: AppTextTheme.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: HexColor('#525252'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Progress Bar (Custom)
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
                          builder: (context, child) {
                            Color progressColor = Colors.white;
                            if (progress >= 1.0) {
                              progressColor = Colors.redAccent;
                            } else if (progress >= 0.8) {
                              progressColor = Colors.orangeAccent;
                            }

                            return FractionallySizedBox(
                              widthFactor: _animation.value * progress > 0
                                  ? _animation.value * progress
                                  : 0.01,
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
                            'You have exceeded your monthly budget!',
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
                          const Icon(Icons.info_outline,
                              color: Colors.orangeAccent, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'Warning: You are approaching your budget limit.',
                            style: AppTextTheme.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.orangeAccent,
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 16),

                    // 3 Columns: Budget, Spending, Remaining
                    Row(
                      children: [
                        Expanded(
                            child: _buildInfoColumn('Budget',
                                '₹ ${widget.budget.totalBudget.toStringAsFixed(0)}')),
                        Expanded(
                            child: _buildInfoColumn('Spending',
                                '₹ ${widget.budget.spentAmount.toStringAsFixed(0)}',
                                isAlert: progress >= 1.0)),
                        Expanded(
                            child: _buildInfoColumn('Remaining',
                                '₹ ${widget.budget.remainingAmount.toStringAsFixed(0)}',
                                isAlert: progress >= 1.0)),
                      ],
                    ),
                    if (widget.budget.categories.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      widget.budget.categories.isEmpty
                          ? const SizedBox()
                          : CategoriesSpendingCard(
                              title: 'Categories',
                              categories: widget.budget.categories,
                            )
                      /* Text(
                        'Categories',
                        style: AppTextTheme.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColor.textGrey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: widget.budget.categories.map((cat) {
                          return _CategoryChip(
                            title: cat.name,
                            amount: '₹${cat.amount.toStringAsFixed(0)}',
                          );
                        }).toList(),
                      ),*/
                    ],
                    // const SizedBox(height: 30),

                    // Text(
                    //   _buildCategoryText(),
                    //   style: AppTextTheme.poppins(
                    //     fontSize: 14,
                    //     fontWeight: FontWeight.w500,
                    //     color: AppColor.blackText,
                    //   ),
                    // ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, {bool isAlert = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextTheme.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: HexColor('#525252'),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.roboto18w600SemiBoldWhite(context)!.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isAlert ? Colors.redAccent : AppColor.blackText,
          ),
        ),
      ],
    );
  }
}
