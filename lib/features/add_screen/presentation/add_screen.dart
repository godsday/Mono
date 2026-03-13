import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mono/core/constants/colors/app_colors.dart';
import 'package:mono/core/constants/app_textstyle/app_textstyle.dart';
import 'package:mono/core/theme/app_theme.dart';
import 'package:mono/core/utils/extension/app_extension.dart';
import 'package:mono/core/widgets/app_button_decoration.dart';
import 'package:mono/core/widgets/dialog_box.dart';
import 'package:mono/core/widgets/decoration_functions.dart';
import 'package:mono/core/widgets/snackbar.dart';
import 'package:mono/features/add_screen/data/models/category_model.dart';
import 'package:mono/features/add_screen/presentation/widgets/curve_clipper.dart';
import 'package:mono/features/transaction/data/models/transcation_model.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../transaction/presentation/providers/transaction_provider.dart';
import 'package:mono/core/utils/extension/context_extension.dart';

class AddScreen extends StatefulWidget {
  final TranscationModel? isDataExist;
  const AddScreen({super.key, this.isDataExist});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final amountController = TextEditingController();
  final notesController = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<TransactionProvider>(context, listen: false);

      if (widget.isDataExist != null) {
        amountController.text = widget.isDataExist!.amount.toStringAsFixed(0);
        notesController.text = widget.isDataExist!.purpose.toString();
        provider.selectedDate = widget.isDataExist!.date;
        provider.categorySelected = widget.isDataExist!.category;
        provider.selectedType = widget.isDataExist!.type;
      } else {
        provider.selectedDate = DateTime.now();
        provider.categorySelected = null;
        provider.selectedType = "Expense";
      }

      provider.loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  height: 90.h,
                ),
                const CurveClipperAddScreen(),
                Positioned(
                    top: 2.h,
                    left: 13.w,
                    child: Image(
                      width: 47.w,
                      image: const AssetImage(
                        'assets/images/rings.png',
                      ),
                    )),
                Positioned(
                  top: 16.h,
                  left: 5.0.w,
                  child: Container(
                    width: 90.0.w,
                    height: 75.h,
                    decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: AppColor.shadowColor.withValues(alpha: 1),
                              blurRadius: 5)
                        ]),
                    child: Form(
                      key: _formkey,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.l10n.transaction_type,
                              style: AppTextStyles.poppins16w400,
                            ),
                            SizedBox(
                              height: .5.h,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Builder(
                                builder: (context) {
                                  final selectedType = context.select((TransactionProvider p) => p.selectedType);
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      RadioGroup<String>(
                                          groupValue: selectedType,
                                          onChanged: (String? value) {
                                            final provider = context.read<TransactionProvider>();
                                            provider.selectedType = value!;
                                            // Clear category selection when switching type
                                            provider.categorySelected = null;
                                          },
                                          child: Row(
                                            children: [
                                              Radio.adaptive(
                                                value: "Expense",
                                                activeColor: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              Text(
                                                context.l10n
                                                    .transaction_type_expense,
                                                style: AppTextStyles
                                                    .poppins16w400
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .extension<
                                                                AppGradients>()!
                                                            .textThemeBlueHeader,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16.sp),
                                              ),
                                              SizedBox(
                                                width: 20.sp,
                                              ),
                                              Radio.adaptive(
                                                value: "Income",
                                                activeColor: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              Text(
                                                context.l10n
                                                    .transaction_type_income,
                                                style: AppTextStyles
                                                    .poppins16w400
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .extension<
                                                                AppGradients>()!
                                                            .textThemeBlueHeader,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 16.sp),
                                              ),
                                            ],
                                          )),
                                    ]);
                                  }),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Text(
                              context.l10n.transaction_amount,
                              style: AppTextStyles.poppins16w400,
                            ),
                            SizedBox(
                              height: .5.h,
                            ),
                            TextFormField(
                              autovalidateMode: AutovalidateMode.onUnfocus,
                              autofocus: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return context.l10n.error_enter_amount;
                                }
                                final amount = double.tryParse(value);
                                if (amount == null || amount <= 0) {
                                  return context.l10n.error_valid_number;
                                }
                                return null;
                              },
                              style: AppTextStyles.poppins16w600.copyWith(
                                color: Theme.of(context)
                                    .extension<AppGradients>()!
                                    .textTheme,
                              ),
                              controller: amountController,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(8),
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9.]')),
                              ],
                              keyboardType: TextInputType.number,
                              decoration: textfielddecor(context,
                                      context.l10n.transaction_amount_hint)
                                  .copyWith(
                                prefixText: '${context.currencySymbol} ',
                                prefixStyle:
                                    AppTextStyles.roboto16w600Black.copyWith(
                                  color: Theme.of(context)
                                      .extension<AppGradients>()!
                                      .textTheme,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            Text(
                              context.l10n.transaction_date,
                              style: AppTextStyles.poppins16w400,
                            ),
                            SizedBox(
                              height: .5.h,
                            ),
                            Builder(
                                builder: (context) {
                                  final selectedDate = context.select((TransactionProvider p) => p.selectedDate);
                                  return InkWell(
                                      onTap: () async {
                                        final provider = context.read<TransactionProvider>();
                                        final date =
                                            await provider.pickDate(context);
                                        if (date == null) return;

                                        provider.selectedDate = date;
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: AppColor.grey, width: 1),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 8.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.calendar_month,
                                                color: AppColor.grey500,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                '${selectedDate.day} / ${selectedDate.month} / ${selectedDate.year}',
                                                style: AppTextStyles
                                                    .poppins16w600
                                                    .copyWith(
                                                  color: Theme.of(context)
                                                      .extension<
                                                          AppGradients>()!
                                                      .textTheme,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            Text(
                              context.l10n.transaction_categories,
                              style: AppTextStyles.poppins16w400,
                            ),
                            SizedBox(
                              height: .5.h,
                            ),
                            Builder(
                              builder: (context) {
                                final selectedType = context.select((TransactionProvider p) => p.selectedType);
                                final allCategories = context.select((TransactionProvider p) => p.allCategories);
                                final categorySelected = context.select((TransactionProvider p) => p.categorySelected);
                                final provider = context.read<TransactionProvider>();

                                // Filter categories based on selected transaction type
                                final categories = allCategories
                                    .where((category) =>
                                        (selectedType == "Income" &&
                                            category.type ==
                                                CategoryType.income) ||
                                        (selectedType == "Expense" &&
                                            category.type ==
                                                CategoryType.expense))
                                    .toList();

                                if (categories.isEmpty) {
                                  return Text(
                                      context.l10n.transaction_no_categories);
                                }

                                String? validCategory;
                                if (categorySelected != null &&
                                    categorySelected.isNotEmpty) {
                                  if (categories.any((c) => c.name == categorySelected)) {
                                    validCategory = categorySelected;
                                  }
                                }

                                return Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: AppColor.grey),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Theme(
                                          data: Theme.of(context).copyWith(
                                            splashColor: AppColor.lightGrey,
                                            highlightColor: AppColor.lightGrey,
                                            hoverColor: AppColor.lightGrey,
                                          ),
                                          child: DropdownButton<String>(
                                            value: validCategory,
                                            icon: Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              size: 24.sp,
                                            ),
                                            elevation: 2,
                                            dropdownColor: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            underline: const SizedBox(),
                                            menuMaxHeight: 300.sp,
                                            iconEnabledColor:
                                                Theme.of(context).primaryColor,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            isExpanded: true,
                                            hint: Text(
                                              context.l10n
                                                  .transaction_category_hint,
                                              style: AppTextStyles
                                                  .montserrat18w600
                                                  .copyWith(
                                                color: AppColor.textGrey
                                                    .withValues(alpha: 0.7),
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            onChanged: (String? value) {
                                              if (value != null) {
                                                provider.categorySelected =
                                                    value;
                                              }
                                            },
                                            items: categories
                                                .map<DropdownMenuItem<String>>(
                                                    (CategoryModel category) {
                                              return DropdownMenuItem<String>(
                                                value: category.name,
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 8.0),
                                                  child: Text(
                                                    category.name,
                                                    style: AppTextStyles
                                                        .poppins16w600
                                                        .copyWith(
                                                      color: Theme.of(context)
                                                          .disabledColor,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        style: ButtonStyle(
                                          elevation: WidgetStateProperty.all(3),
                                          backgroundColor:
                                              WidgetStateProperty.all(
                                                  Theme.of(context)
                                                      .secondaryHeaderColor),
                                        ),
                                        icon: Icon(
                                          Icons.add,
                                          color: AppColor.whiteColor,
                                        ),
                                        onPressed: () {
                                          showAddCategoryDialog(
                                            context,
                                            provider: provider,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            Text(
                              context.l10n.transaction_notes,
                              style: AppTextStyles.poppins16w400,
                            ),
                            SizedBox(
                              height: .5.h,
                            ),
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10)
                              ],
                              style: AppTextStyles.poppins16w600.copyWith(
                                color: Theme.of(context)
                                    .extension<AppGradients>()!
                                    .textTheme,
                              ),
                              controller: notesController,
                              keyboardType: TextInputType.text,
                              decoration: textfielddecor(
                                  context, context.l10n.transaction_notes_hint),
                              maxLines: 2,
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  notesController.text =
                                      value.capitalizeFirstLetter();
                                }
                              },
                            ),
                            SizedBox(height: 3.5.h),
                            SizedBox(
                              width: double.infinity,
                              child: AppElevetedButton(
                                onPressed: () async {
                                  final provider =
                                      Provider.of<TransactionProvider>(context,
                                          listen: false);
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  await Future.delayed(
                                      const Duration(milliseconds: 200));
                                  if (!context.mounted) return;
                                  // Validate form before submitting
                                  if (_formkey.currentState!.validate()) {
                                    // Check if category is selected

                                    if (provider.categorySelected == null ||
                                        provider.categorySelected!.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(customSnack(context,
                                              message: context
                                                  .l10n.error_select_category));
                                      return;
                                    }

                                    final amount =
                                        double.parse(amountController.text);
                                    final entity = TranscationModel(
                                      id: widget.isDataExist?.id ??
                                          DateTime.now()
                                              .millisecondsSinceEpoch
                                              .toString(),
                                      type: provider.selectedType,
                                      amount: amount,
                                      date: provider.selectedDate,
                                      category: provider.categorySelected!,
                                      purpose: notesController.text,
                                    );

                                    widget.isDataExist != null
                                        ? provider.updateTransaction(entity)
                                        : provider.addTransaction(entity);

                                    if (context.mounted) {
                                      Navigator.of(context).pop();
                                    }
                                  }
                                },
                                height: 56,
                                appButtonText: widget.isDataExist == null
                                    ? context.l10n.transaction_record_button
                                    : context.l10n.transaction_update_button,
                              ),
                            ),
                            SizedBox(height: 1.h)
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers

    amountController.dispose();
    notesController.dispose();

    super.dispose();
  }
}
