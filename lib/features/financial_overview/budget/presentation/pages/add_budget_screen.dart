import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mono/core/theme/app_theme.dart';
import 'package:mono/features/add_screen/data/models/category_model.dart';
import 'package:mono/features/financial_overview/budget/domain/entities/budget_entity.dart';
import 'package:mono/routes/route_names.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constants/colors/app_colors.dart';
import '../../../../../core/theme/app_texttheme.dart';
import '../../data/repositories/budget_repository_impl.dart';
import '../../domain/usecases/save_monthly_budget_usecase.dart';
import '../providers/add_budget_provider.dart';
import 'package:mono/core/utils/extension/context_extension.dart';

class AddBudgetScreen extends StatelessWidget {
  final BudgetEntity? budget;

  const AddBudgetScreen({super.key, this.budget});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = AddBudgetProvider(
          saveBudgetUseCase: SaveMonthlyBudgetUseCase(BudgetRepositoryImpl()),
        );
        if (budget != null) {
          provider.initBudget(budget!);
        }
        return provider;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            budget?.totalBudget != null
                ? context.l10n.edit_budget_title
                : context.l10n.set_budget_title,
            style: AppTextTheme.montserrart(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).extension<AppGradients>()!.textTheme,
            ),
          ),
          centerTitle: true,
        ),
        body: _AddBudgetBody(isBudgetExist: budget),
        bottomNavigationBar: _SaveBudgetButton(budget: budget),
      ),
    );
  }
}

class _AddBudgetBody extends StatefulWidget {
  final BudgetEntity? isBudgetExist;
  const _AddBudgetBody({this.isBudgetExist});

  @override
  State<_AddBudgetBody> createState() => _AddBudgetBodyState();
}

class _AddBudgetBodyState extends State<_AddBudgetBody> {
  final TextEditingController totalController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.isBudgetExist != null) {
      final amount = widget.isBudgetExist!.totalBudget;
      totalController.text = amount == amount.toInt()
          ? amount.toInt().toString()
          : amount.toString();
    }
  }

  @override
  void dispose() {
    totalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AddBudgetProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.plan_spending_subtitle,
            style: AppTextTheme.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColor.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          _buildTotalBudgetInput(context, provider),
          const SizedBox(height: 32),
          _buildRemainingIndicator(context, provider, widget.isBudgetExist),
          const SizedBox(height: 32),
          Text(
            context.l10n.allocate_by_category,
            style: AppTextTheme.montserrart(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).primaryColor),
          ),
          const SizedBox(height: 16),
          if (provider.availableCategories.isEmpty && provider.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (provider.availableCategories.isEmpty)
            Text(context.l10n.no_expense_categories)
          else
            ...provider.availableCategories.map(
              (category) => _CategoryBudgetInput(category: category),
            ),
        ],
      ),
    );
  }

  Widget _buildTotalBudgetInput(
      BuildContext context, AddBudgetProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.blueContainer),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.total_monthly_budget_label,
            style: AppTextTheme.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$')),
              LengthLimitingTextInputFormatter(10)
            ],
            controller: totalController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: AppTextTheme.montserrart(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).extension<AppGradients>()!.textTheme,
            ),
            decoration: InputDecoration(
              prefixText: '${context.currencySymbol} ',
              prefixStyle: AppTextTheme.montserrart(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).disabledColor,
              ),
              border: InputBorder.none,
              hintText: '0',
              hintStyle: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColor.lightGrey
                      : AppColor.textSecondary.withValues(alpha: 0.3)),
            ),
            onChanged: (value) {
              if (value.isNotEmpty && RegExp(r'^[0-9]*$').hasMatch(value)) {
                final amount = double.tryParse(value);
                provider.updateTotalBudget(amount!);
              } else {
                provider.updateTotalBudget(0);
              }
            },
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.recommended_budget_hint,
            style: AppTextTheme.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColor.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemainingIndicator(
      BuildContext context, AddBudgetProvider provider, BudgetEntity? budget) {
    // final remaining = budget?.totalBudget ?? provider.remainingAmount;
    // final isOverBudget = remaining < 0;

    return Consumer<AddBudgetProvider>(builder: (context, provider, child) {
      final remaining = provider.remainingAmount;
      final isOverBudget = remaining < 0;
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isOverBudget
              ? AppColor.expenseRed.withValues(alpha: 0.1)
              : AppColor.incomeGreen.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isOverBudget
                  ? context.l10n.over_budget_label
                  : context.l10n.remaining_to_allocate_label,
              style: AppTextTheme.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color:
                    isOverBudget ? AppColor.expenseRed : AppColor.incomeGreen,
              ),
            ),
            Text(
              context.formatCurrency(remaining.abs()),
              style: AppTextTheme.montserrart(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color:
                    isOverBudget ? AppColor.expenseRed : AppColor.incomeGreen,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _CategoryBudgetInput extends StatefulWidget {
  final CategoryModel category;

  const _CategoryBudgetInput({required this.category});

  @override
  State<_CategoryBudgetInput> createState() => _CategoryBudgetInputState();
}

class _CategoryBudgetInputState extends State<_CategoryBudgetInput> {
  // Use a controller to keep state
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = context.read<AddBudgetProvider>();
    final amount = provider.categoryBudgets[widget.category.id];
    if (amount != null && amount > 0) {
      _controller.text = amount == amount.toInt()
          ? amount.toInt().toString()
          : amount.toString();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AddBudgetProvider>();
    // We don't watch here to avoid rebuilding every row on every keystroke of other rows
    // But we need to know if we should update initial value? No, local state is fine.

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
              shape: BoxShape.circle,
              border: Border.all(color: AppColor.borderGreyWhite),
            ),
            child: Icon(Icons.category_outlined,
                color: AppColor.grey700, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.category.name,
              style: AppTextTheme.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).extension<AppGradients>()!.textTheme,
              ),
            ),
          ),
          Container(
            width: 100,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColor.grey.withValues(alpha: 0.3)),
            ),
            child: TextFormField(
              controller: _controller,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$')),
                LengthLimitingTextInputFormatter(10)
              ],
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.end,
              style: AppTextTheme.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).extension<AppGradients>()!.textTheme,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                prefixText: context.currencySymbol,
                prefixStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                hintText: '0',
              ),
              onChanged: (value) {
                final amount = double.tryParse(value) ?? 0;
                provider.updateCategoryBudget(widget.category.id, amount);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SaveBudgetButton extends StatelessWidget {
  final BudgetEntity? budget;
  const _SaveBudgetButton({this.budget});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AddBudgetProvider>();

    return Container(
      padding: const EdgeInsets.all(20),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: ElevatedButton(
          onPressed: provider.isValid && !provider.isLoading
              ? () async {
                  final success = await provider.saveBudget();
                  if (success && context.mounted) {
                    Navigator.of(context).pushReplacementNamed(
                      RouteNames.bottomNav,
                      arguments: 2,
                    );
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            disabledBackgroundColor: AppColor.grey.withValues(alpha: 0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            elevation: 0,
          ),
          child: provider.isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2),
                )
              : Text(
                  budget?.totalBudget != null
                      ? context.l10n.update_budget_button
                      : context.l10n.save_budget_button,
                  style: AppTextTheme.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
