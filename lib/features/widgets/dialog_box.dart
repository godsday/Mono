// Method to show dialog for adding custom categories
import 'package:flutter/material.dart';
import 'package:mono/core/constants/app_textstyle/app_textstyle.dart';
import 'package:mono/core/constants/colors/app_colors.dart';
import 'package:mono/core/theme/app_theme.dart';
import 'package:mono/core/utils/extension/app_extension.dart';
import 'package:mono/features/widgets/decoration_widgets/decoration_functions.dart';
import 'package:mono/features/widgets/snackbar.dart';
import 'package:mono/features/add_screen/data/repositories/category_db.dart';
import 'package:mono/features/add_screen/data/models/category_model.dart';
import 'package:mono/features/transaction/presentation/providers/transaction_provider.dart';
import 'package:sizer/sizer.dart';

void showAddCategoryDialog(
  BuildContext context, {
  TransactionProvider? provider,
  bool isAlert = false,
  String? title,
  String? subtitle,
  VoidCallback? onYesPressed,
}) async {
  final categoryNameController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title ?? 'Add Custom Category',
          style: isAlert
              ? AppTextStyles.poppins18w600.copyWith(color: AppColor.expenseRed)
              : AppTextStyles.poppins18w600.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
        ),
        content: isAlert
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    subtitle!,
                    style: AppTextStyles.poppins16w400.copyWith(
                      color: Theme.of(context).disabledColor,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter a name for your new category',
                    style: AppTextStyles.poppins16w400.copyWith(
                      color: Theme.of(context).disabledColor,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  TextField(
                    controller: categoryNameController,
                    decoration: textfielddecor(context, "Category name"),
                    autofocus: true,
                  ),
                ],
              ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              isAlert ? 'No' : 'Cancel',
              style: AppTextStyles.poppins16w400.copyWith(
                color: Theme.of(context).extension<AppGradients>()!.textTheme,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (onYesPressed != null) {
                onYesPressed();
                return;
              }
              String categoryName = categoryNameController.text.trim();
              final data = categoryName.capitalizeFirstLetter().toString();
              debugPrint(data);
              if (categoryName.isEmpty) {
                // Show error if category name is empty
                ScaffoldMessenger.of(context).showSnackBar(customSnack(context,
                    message: "Category name cannot be empty"));
                return;
              }

              // Check if category already exists
              final allCategories = await CategoryDB.instance.getCategories();

              if (!context.mounted) return;

              bool categoryExists = allCategories.any((category) =>
                  category.name.toLowerCase() == categoryName.toLowerCase() &&
                  ((provider?.selectedType == "Income" &&
                          category.type == CategoryType.income) ||
                      (provider?.selectedType == "Expense" &&
                          category.type == CategoryType.expense)));

              if (categoryExists) {
                // Show error if category already exists
                ScaffoldMessenger.of(context).showSnackBar(customSnack(context,
                    message: "Category '$categoryName' already exists"));
                return;
              }

              // Add to database
              final newCategory = CategoryModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  type: provider?.selectedType == "Income"
                      ? CategoryType.income
                      : CategoryType.expense,
                  name: categoryName.capitalizeFirstLetter());

              await CategoryDB.instance.insertCategory(newCategory);

              if (!context.mounted) return;

              // Select the newly added category
              provider?.categorySelected = categoryName.capitalizeFirstLetter();
              await provider?.loadCategories();
              if (!context.mounted) return;
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.mainHexcolor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              isAlert ? 'Yes' : 'Save',
              style: AppTextStyles.poppins16w600.copyWith(
                color: AppColor.whiteColor,
              ),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      );
    },
  );
}

void showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String subtitle,
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        title,
        style: AppTextStyles.poppins18w600.copyWith(
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
      content: Text(
        subtitle,
        style: AppTextStyles.poppins16w400.copyWith(
          color: Theme.of(context).disabledColor,
          fontSize: 14.sp,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'No',
            style: AppTextStyles.poppins16w400.copyWith(
              color: Theme.of(context).extension<AppGradients>()!.textTheme,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.mainHexcolor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Yes',
            style: AppTextStyles.poppins16w600.copyWith(
              color: AppColor.whiteColor,
            ),
          ),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
