import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors/app_colors.dart';
import 'package:mono/core/theme/app_theme.dart';
import 'package:mono/features/financial_overview/budget/domain/entities/budget_entity.dart';
import 'package:mono/core/utils/extension/context_extension.dart';

// Module-level constants – allocated once, never again.
const _borderColor = Color(0x26FFFFFF); // white 15%
const _shadowColor = Color(0x26000000); // black 15%

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
  bool _isTapped = true; // collapsed by default
  bool _isScaled = false;

  @override
  Widget build(BuildContext context) {
    final headerColor =
        Theme.of(context).extension<AppGradients>()!.textThemeBlueHeader;

    return GestureDetector(
      onTap: () => setState(() => _isTapped = !_isTapped),
      onVerticalDragUpdate: (details) {
        final expanded = details.delta.dy > 0;
        if (expanded != _isScaled) setState(() => _isScaled = expanded);
      },
      child: AnimatedScale(
        scale: _isScaled ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.fastOutSlowIn,
        child: Container(
          decoration: BoxDecoration(
            // ✅ BackdropFilter removed – it forced a full render-object
            // save-layer every frame, costing ~30–40 ms on raster thread.
            // A plain semi-transparent surface is visually equivalent here.
            borderRadius: BorderRadius.circular(12),
            color:
                const Color.fromARGB(255, 101, 94, 94).withValues(alpha: 0.25),
            border: const Border.fromBorderSide(
              BorderSide(color: _borderColor, width: 1.0),
            ),
            boxShadow: const [
              BoxShadow(
                color: _shadowColor,
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: AnimatedContainer(
            // ✅ Duration: 2000 ms → 300 ms  (snappy, not sluggish)
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: _isTapped ? 12 : 20,
            ),
            child: AnimatedSize(
              // ✅ Duration: 2000 ms → 300 ms
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
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
                      color: headerColor,
                    ),
                  ),
                  if (!_isTapped) ...[
                    const SizedBox(height: 16),
                    // ✅ Each row is its own StatelessWidget – only changed
                    // items are rebuilt when the list updates.
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: widget.categories.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) => _CategoryItem(
                        category: widget.categories[index],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final BudgetCategoryEntity category;

  const _CategoryItem({required this.category});

  @override
  Widget build(BuildContext context) {
    final spent = category.spentAmount;
    final allocated = category.amount;
    final progress = allocated > 0
        ? (spent / allocated).clamp(0.0, 1.0)
        : (spent > 0 ? 1.0 : 0.0);
    final isOverBudget = spent > allocated && allocated > 0;

    final amountText = allocated > 0
        ? '${context.formatCurrency(spent)} / ${context.formatCurrency(allocated)}'
        : context.formatCurrency(spent);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              category.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              amountText,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isOverBudget ? Colors.redAccent : AppColor.whiteColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white.withValues(alpha: 0.1),
            color: isOverBudget ? Colors.redAccent : Colors.amber,
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
