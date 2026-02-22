import 'package:flutter/material.dart';
import 'package:mono/features/financial_overview/budget/domain/entities/budget_entity.dart';
import 'package:mono/routes/route_names.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constants/colors/app_colors.dart';
import '../../../../../core/theme/app_texttheme.dart';
import '../../../../../models/category_model/category_model.dart';
import '../../data/repositories/budget_repository_impl.dart';
import '../../domain/usecases/save_monthly_budget_usecase.dart';
import '../providers/add_budget_provider.dart';

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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColor.blackText),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            budget?.totalBudget != null
                ? 'Edit Monthly Budget'
                : 'Set Monthly Budget',
            style: AppTextTheme.montserrart(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColor.blackText,
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

  // @override
  // void didUpdateWidget(covariant _AddBudgetBody oldWidget) {
  //   if (oldWidget.isBudgetExist != widget.isBudgetExist) {
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       final provider = context.watch<AddBudgetProvider>();
  //       if (widget.isBudgetExist != null) {
  //         provider.updateTotalBudget(widget.isBudgetExist!.totalBudget);
  //       }
  //     });
  //   }
  //   super.didUpdateWidget(oldWidget);
  // }

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
            'Plan your spending for this month',
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
            'Allocate by Category',
            style: AppTextTheme.montserrart(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColor.mainHexcolor,
            ),
          ),
          const SizedBox(height: 16),
          if (provider.availableCategories.isEmpty && provider.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (provider.availableCategories.isEmpty)
            const Text("No expense categories found.")
          // else if (widget.isBudgetExist?.categories != null)
          //   ...widget.isBudgetExist!.categories
          //       .map((category) => _CategoryBudgetInput(category: category))
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
        color: AppColor.blueContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.blueContainer),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Monthly Budget',
            style: AppTextTheme.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColor.mainHexcolor,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: totalController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: AppTextTheme.montserrart(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: AppColor.blackText,
            ),
            decoration: InputDecoration(
              prefixText: '₹ ',
              prefixStyle: AppTextTheme.montserrart(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: AppColor.textSecondary,
              ),
              border: InputBorder.none,
              hintText: '0',
              hintStyle: TextStyle(
                  color: AppColor.textSecondary.withValues(alpha: 0.3)),
            ),
            onChanged: (value) {
              if (value.isEmpty) {
                provider.updateTotalBudget(0);
                return;
              }
              final amount = double.tryParse(value);
              if (amount != null) {
                provider.updateTotalBudget(amount);
              }
            },
          ),
          const SizedBox(height: 8),
          Text(
            'Recommended: 70–80% of income',
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
              isOverBudget ? 'Over Budget' : 'Remaining to Allocate',
              style: AppTextTheme.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color:
                    isOverBudget ? AppColor.expenseRed : AppColor.incomeGreen,
              ),
            ),
            Text(
              '₹${remaining.abs().toStringAsFixed(0)}',
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
              color: AppColor.lightGrey,
              shape: BoxShape.circle,
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
                color: AppColor.blackText,
              ),
            ),
          ),
          Container(
            width: 100,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColor.grey.withValues(alpha: 0.3)),
            ),
            child: TextFormField(
              controller: _controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.end,
              style: AppTextTheme.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColor.blackText,
              ),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                prefixText: '₹',
                prefixStyle: TextStyle(color: Colors.grey, fontSize: 14),
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
      color: Colors.white,
      child: SafeArea(
        child: ElevatedButton(
          onPressed: provider.isValid && !provider.isLoading
              ? () async {
                  final success = await provider.saveBudget();
                  if (success && context.mounted) {
                    Navigator.of(context).pushNamed(RouteNames.budgetOverview);
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.mainHexcolor,
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
                  budget?.totalBudget != null ? 'Update Budget' : 'Save Budget',
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
