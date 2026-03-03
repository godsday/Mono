import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constants/colors/app_colors.dart';
import '../../../../../core/theme/app_texttheme.dart';
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
    // Calculate progress
    double progress = widget.budget.totalBudget > 0
        ? (widget.budget.spentAmount / widget.budget.totalBudget)
            .clamp(0.0, 1.0)
        : 0.0;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: const LinearGradient(
          colors: [Color(0xFF521F66), Color(0xFF84509B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: InkWell(
        onTap: () {
          // Handle tap
        },
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    color: AppColor.mainHexcolor,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Monthly Budget',
                    style: AppTextTheme.montserrart(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColor.mainHexcolor,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      // Navigate to edit budget
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddBudgetScreen()),
                      );

                      // If saved/updated successfully, reload the overview
                      if (result == true && context.mounted) {
                        context.read<FinancialOverviewProvider>().loadBudget();
                      }
                    },
                    child: Text(
                      'Edit', // Changed to Edit since budget exists
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
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return LinearProgressIndicator(
                    value:
                        _animation.value * progress, // Use calculated progress
                    backgroundColor:
                        AppColor.accentHexColor.withValues(alpha: 0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColor.mainHexcolor,
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBudgetInfo('Budget',
                      '₹${widget.budget.totalBudget.toStringAsFixed(0)}'),
                  _buildBudgetInfo('Spent',
                      '₹${widget.budget.spentAmount.toStringAsFixed(0)}'),
                  _buildBudgetInfo('Remaining',
                      '₹${widget.budget.remainingAmount.toStringAsFixed(0)}'),
                ],
              ),
              if (widget.budget.categories.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(
                  'Categories',
                  style: AppTextTheme.montserrart(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColor.mainHexcolor,
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
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBudgetInfo(String title, String amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextTheme.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          amount,
          style: AppTextTheme.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColor.mainHexcolor,
          ),
        ),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String title;
  final String amount;

  const _CategoryChip({
    required this.title,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColor.accentHexColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$title: $amount',
        style: AppTextTheme.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColor.mainHexcolor,
        ),
      ),
    );
  }
}
