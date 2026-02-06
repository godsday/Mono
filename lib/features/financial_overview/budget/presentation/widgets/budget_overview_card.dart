import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import 'package:intl/intl.dart';
import '../../../../../core/constants/colors/app_colors.dart';
import '../../../../../core/theme/app_texttheme.dart';
import '../../../widgets/safe_background_image.dart';
import '../pages/add_budget_screen.dart';
import '../../domain/entities/budget_entity.dart';
import '../providers/financial_overview_provider.dart';

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
          // Background Pattern
          const Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: SafeBackgroundImage(
                imagePath: 'assets/images/onboard_bacground.svg', // Placeholder
                fit: BoxFit.cover,
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // White Tab with Title
                  Container(
                    padding: const EdgeInsets.only(
                        left: 20, right: 30, top: 12, bottom: 12),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        bottomRight: Radius.circular(300), // Slanted effect
                      ),
                    ),
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
                          style: AppTextTheme.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColor.blackText,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Edit Button
                  Padding(
                    padding: const EdgeInsets.only(top: 12, right: 20),
                    child: GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddBudgetScreen()),
                        );
                        if (result == true && context.mounted) {
                          context.read<BudgetProvider>().loadBudget();
                        }
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
                          height: 6,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        AnimatedBuilder(
                          animation: _animation,
                          builder: (context, child) {
                            return FractionallySizedBox(
                              widthFactor: _animation.value * progress > 0
                                  ? _animation.value * progress
                                  : 0.01,
                              child: Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // 3 Columns: Budget, Spending, Remaining
                    Row(
                      children: [
                        Expanded(
                            child: _buildInfoColumn('Budget',
                                '₹${widget.budget.totalBudget.toStringAsFixed(0)}')),
                        Expanded(
                            child: _buildInfoColumn('Spending',
                                '₹${widget.budget.spentAmount.toStringAsFixed(0)}')),
                        Expanded(
                            child: _buildInfoColumn('Remaining',
                                '₹${widget.budget.remainingAmount.toStringAsFixed(0)}')),
                      ],
                    ),

                    const SizedBox(height: 30),

                    Text(
                      _buildCategoryText(),
                      style: AppTextTheme.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColor.blackText,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
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
          style: AppTextTheme.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColor.blackText,
          ),
        ),
      ],
    );
  }

  String _buildCategoryText() {
    final categories = widget.budget.categories;
    if (categories.isEmpty) {
      return 'No category selected';
    } else if (categories.length <= 3) {
      return categories.map((e) => e.name).join(', ');
    } else {
      final firstTwo = categories.take(2).map((e) => e.name).join(', ');
      final remainingCount = categories.length - 2;
      return '$firstTwo, +$remainingCount more';
    }
  }
}
