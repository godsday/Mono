// Method to show dialog for adding custom categories
import 'package:flutter/material.dart';
import 'package:mono/core/constants/app_textstyle/app_textstyle.dart';
import 'package:mono/core/constants/colors/app_colors.dart';
import 'package:mono/core/utils/extension/app_extension.dart';
import 'package:mono/core/widgets/decoration_functions.dart';
import 'package:mono/core/widgets/snackbar.dart';
import 'package:mono/database/categories_DB/category_db.dart';
import 'package:mono/features/transaction/presentation/providers/transaction_provider.dart';
import 'package:mono/models/category_model/category_model.dart';
import 'package:sizer/sizer.dart';

void showAddCategoryDialog(
    BuildContext context, TransactionProvider provider) async {
  final categoryNameController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Add Custom Category',
          style: AppTextStyles.montserrat18w600.copyWith(
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter a name for your new category',
              style: AppTextStyles.poppins16w400.copyWith(
                color: AppColor.grey600,
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 1.h),
            TextField(
              controller: categoryNameController,
              decoration: textfielddecor("Category name"),
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
              'Cancel',
              style: AppTextStyles.poppins16w400.copyWith(
                color: AppColor.grey600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              String categoryName = categoryNameController.text.trim();
              final data = categoryName.capitalizeFirstLetter().toString();
              print(data);
              if (categoryName.isEmpty) {
                // Show error if category name is empty
                ScaffoldMessenger.of(context).showSnackBar(customSnak(context,
                    message: "Category name cannot be empty"));
                return;
              }

              // Check if category already exists
              final allCategories = await CategoryDB.instance.getCategories();

              if (!context.mounted) return;

              bool categoryExists = allCategories.any((category) =>
                  category.name.toLowerCase() == categoryName.toLowerCase() &&
                  ((provider.selectedType == "Income" &&
                          category.type == CategoryType.income) ||
                      (provider.selectedType == "Expense" &&
                          category.type == CategoryType.expense)));

              if (categoryExists) {
                // Show error if category already exists
                ScaffoldMessenger.of(context).showSnackBar(customSnak(context,
                    message: "Category '$categoryName' already exists"));
                return;
              }

              // Add to database
              final newCategory = CategoryModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  type: provider.selectedType == "Income"
                      ? CategoryType.income
                      : CategoryType.expense,
                  name: categoryName.capitalizeFirstLetter());

              await CategoryDB.instance.insertCategory(newCategory);

              if (!context.mounted) return;

              // Select the newly added category
              provider.categorySelected = categoryName.capitalizeFirstLetter();
              await provider.loadCategories();
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
              'Save',
              style: AppTextStyles.poppins16w400.copyWith(
                color: AppColor.white,
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
