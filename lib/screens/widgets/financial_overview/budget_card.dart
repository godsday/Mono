import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors/app_colors.dart';
import 'package:mono/core/theme/app_texttheme.dart';

class BudgetCard extends StatefulWidget {
  const BudgetCard({super.key});

  @override
  State<BudgetCard> createState() => _BudgetCardState();
}

class _BudgetCardState extends State<BudgetCard>
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
                    onPressed: () {
                      // Set budget action
                    },
                    child: Text(
                      'Set Budget',
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
                    value: _animation.value * 0.65,
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
                  _buildBudgetInfo('Budget', '₹45,000'),
                  _buildBudgetInfo('Spent', '₹29,250'),
                  _buildBudgetInfo('Remaining', '₹15,750'),
                ],
              ),
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
              const Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _CategoryChip(title: 'Food', amount: '₹8,400'),
                  _CategoryChip(title: 'Travel', amount: '₹4,200'),
                  _CategoryChip(title: 'Rent', amount: '₹12,000'),
                  _CategoryChip(title: 'Shopping', amount: '₹3,150'),
                  _CategoryChip(title: 'Entertainment', amount: '₹1,500'),
                ],
              ),
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
