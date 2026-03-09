import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors/app_colors.dart';
import 'package:mono/core/theme/app_theme.dart';
import 'package:mono/features/financial_overview/budget/domain/entities/budget_entity.dart';
import 'package:mono/core/utils/extension/context_extension.dart';

class CategoriesSpendingCard extends StatefulWidget {
  final String title;
  final List<BudgetCategoryEntity> categories;
  final IconData icon;

  const CategoriesSpendingCard({
    super.key,
    required this.title,
    required this.categories,
    this.icon = Icons.lightbulb_outline,
  });

  @override
  State<CategoriesSpendingCard> createState() => _CategoriesSpendingCardState();
}

class _CategoriesSpendingCardState extends State<CategoriesSpendingCard> {
  bool isTapped = true;
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        // highlightColor: Colors.transparent,
        // splashColor: Colors.transparent,
        onTap: () {
          setState(() {
            isTapped = !isTapped;
          });
        },
        onVerticalDragUpdate: (details) {
          setState(() {
            isExpanded = details.delta.dy > 0;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
                12), // Slightly larger to hug the inner content
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
              width: 1.0, // Slightly thicker for visibility
              strokeAlign:
                  BorderSide.strokeAlignOutside, // Explicitly set to outside
            ),
          ),
          child: AnimatedScale(
            scale: isExpanded ? .5 : 1.0,
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            child: ClipRRect(
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 2000),
                  curve: Curves.fastLinearToSlowEaseIn,
                  width: double.infinity,
                  padding: EdgeInsets.only(
                      top: isTapped ? 12 : 20,
                      bottom: isTapped ? 12 : 20,
                      left: 12,
                      right: 12),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: AnimatedSize(
                    clipBehavior: Clip.antiAlias,
                    duration: const Duration(milliseconds: 2000),
                    curve: Curves.fastLinearToSlowEaseIn,
                    alignment: Alignment.topCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Theme.of(context)
                                  .extension<AppGradients>()!
                                  .textThemeBlueHeader),
                        ),
                        if (!isTapped) ...[
                          const SizedBox(height: 16),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            itemCount: widget.categories.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final cat = widget.categories[index];
                              final spent = cat.spentAmount;
                              final allocated = cat.amount;
                              final progress = allocated > 0
                                  ? (spent / allocated).clamp(0.0, 1.0)
                                  : (spent > 0 ? 1.0 : 0.0);
                              final isOverBudget =
                                  spent > allocated && allocated > 0;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        cat.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        allocated > 0
                                            ? '${context.formatCurrency(spent)} / ${context.formatCurrency(allocated)}'
                                            : context.formatCurrency(spent),
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: isOverBudget
                                              ? Colors.redAccent
                                              : AppColor.textGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: progress,
                                      backgroundColor:
                                          Colors.white.withValues(alpha: 0.1),
                                      color: isOverBudget
                                          ? Colors.redAccent
                                          : Colors.amber,
                                      minHeight: 6,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
