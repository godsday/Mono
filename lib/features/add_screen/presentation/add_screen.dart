import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mono/core/constants/colors/app_colors.dart';
import 'package:mono/core/constants/app_textstyle/app_textstyle.dart';
import 'package:mono/core/theme/app_texttheme.dart';
import 'package:mono/core/widgets/app_button_decoration.dart';
import 'package:mono/core/widgets/dialog_box.dart';
import 'package:mono/core/widgets/decoration_functions.dart';
import 'package:mono/core/widgets/snackbar.dart';
import 'package:mono/features/add_screen/data/models/category_model.dart';
import 'package:mono/features/transaction/data/models/transcation_model.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:mono/features/widgets/add_clipper.dart';
import '../../transaction/presentation/providers/transaction_provider.dart';

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

  // Helper method to get a valid category for the dropdown
  String? _getValidCategory(TransactionProvider provider) {
    // If no category is selected, return null to show the hint
    if (provider.categorySelected == null ||
        provider.categorySelected!.isEmpty) {
      return null;
    }

    return provider.categorySelected;
  }

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
      }

      provider.loadCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(height: 90.h),
                ClipPath(
                  clipper: CurveClipper(),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF429690), Color(0xFF1E4744)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    height: 40.h,
                  ),
                ),
                Positioned(
                  top: 5.h,
                  left: 26.w,
                  child: Text(
                    widget.isDataExist == null
                        ? "Add Transcation"
                        : "Edit Transcation",
                    style: AppTextTheme.montserrart(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColor.white,
                    ),
                  ),
                ),
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
                        color: Theme.of(context).dialogTheme.backgroundColor ??
                            Theme.of(context).cardColor,
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
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Transcation type',
                                style: AppTextStyles.poppins16w400,
                              ),
                              SizedBox(
                                height: .5.h,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Consumer<TransactionProvider>(
                                  builder: (context, provider, child) => Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        RadioGroup<String>(
                                            groupValue: provider.selectedType,
                                            onChanged: (String? value) {
                                              provider.selectedType = value!;
                                              // Clear category selection when switching type
                                              provider.categorySelected = null;
                                            },
                                            child: Row(
                                              children: [
                                                Radio.adaptive(
                                                  value: "Expense",
                                                  activeColor:
                                                      AppColor.mainHexcolor,
                                                ),
                                                Text(
                                                  "Expense",
                                                  style: AppTextStyles
                                                      .poppins16w400
                                                      .copyWith(
                                                          color: AppColor
                                                              .blueGrey700,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 16.sp),
                                                ),
                                                SizedBox(
                                                  width: 20.sp,
                                                ),
                                                Radio.adaptive(
                                                  value: "Income",
                                                  activeColor:
                                                      AppColor.mainHexcolor,
                                                ),
                                                Text(
                                                  "Income",
                                                  style: AppTextStyles
                                                      .poppins16w400
                                                      .copyWith(
                                                          color: AppColor
                                                              .blueGrey700,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 16.sp),
                                                ),
                                              ],
                                            )),
                                      ]),
                                ),
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              Text(
                                'Amount',
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
                                    return 'Please enter an amount';
                                  }
                                  final amount = double.tryParse(value);
                                  if (amount == null || amount <= 0) {
                                    return ' Enter a valid number';
                                  }
                                  return null;
                                },
                                style: AppTextStyles.poppins16w600,
                                controller: amountController,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(8),
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9.]')),
                                ],
                                keyboardType: TextInputType.number,
                                decoration: textfielddecor("Enter Amount"),
                              ),
                              SizedBox(
                                height: 1.5.h,
                              ),
                              Text(
                                'Date',
                                style: AppTextStyles.poppins16w400,
                              ),
                              SizedBox(
                                height: .5.h,
                              ),
                              Consumer<TransactionProvider>(
                                  builder: (context, provider, child) =>
                                      InkWell(
                                        onTap: () async {
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
                                                    .dialogTheme
                                                    .backgroundColor ??
                                                Theme.of(context).cardColor,
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
                                                  '${provider.selectedDate.day} / ${provider.selectedDate.month} / ${provider.selectedDate.year}',
                                                  style: AppTextStyles
                                                      .poppins16w600,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )),
                              SizedBox(
                                height: 1.5.h,
                              ),
                              Text(
                                'Categories',
                                style: AppTextStyles.poppins16w400,
                              ),
                              SizedBox(
                                height: .5.h,
                              ),
                              Consumer<TransactionProvider>(
                                builder: (context, provider, child) {
                                  // Filter categories based on selected transaction type
                                  final categories = provider.allCategories
                                      .where((category) =>
                                          (provider.selectedType == "Income" &&
                                              category.type ==
                                                  CategoryType.income) ||
                                          (provider.selectedType == "Expense" &&
                                              category.type ==
                                                  CategoryType.expense))
                                      .toList();

                                  if (categories.isEmpty) {
                                    return const Text(
                                        'No categories available');
                                  }

                                  return Container(
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: AppColor.grey),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Theme(
                                            data: Theme.of(context).copyWith(
                                              splashColor: AppColor.lightGrey,
                                              highlightColor:
                                                  AppColor.lightGrey,
                                              hoverColor: AppColor.lightGrey,
                                              focusColor: AppColor.lightGrey,
                                            ),
                                            child: DropdownButton<String>(
                                              value:
                                                  _getValidCategory(provider),
                                              icon: Icon(
                                                Icons
                                                    .keyboard_arrow_down_rounded,
                                                size: 24.sp,
                                              ),
                                              elevation: 2,
                                              dropdownColor: AppColor.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              underline: const SizedBox(),
                                              menuMaxHeight: 300.sp,
                                              iconEnabledColor:
                                                  AppColor.mainHexcolor,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0),
                                              isExpanded: true,
                                              hint: Text(
                                                'Select Category',
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
                                              items: categories.map<
                                                      DropdownMenuItem<String>>(
                                                  (CategoryModel category) {
                                                return DropdownMenuItem<String>(
                                                  value: category.name,
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 8.0),
                                                    child: Text(
                                                      category.name,
                                                      style: AppTextStyles
                                                          .poppins16w600,
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          style: ButtonStyle(
                                            elevation:
                                                WidgetStateProperty.all(3),
                                            backgroundColor:
                                                WidgetStateProperty.all(
                                                    AppColor.mainHexcolor),
                                          ),
                                          icon: Icon(
                                            Icons.add,
                                            color: AppColor.white,
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
                                'Notes',
                                style: AppTextStyles.poppins16w400,
                              ),
                              SizedBox(
                                height: .5.h,
                              ),
                              TextFormField(
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10)
                                ],
                                style: AppTextStyles.poppins16w600,
                                controller: notesController,
                                keyboardType: TextInputType.text,
                                decoration: textfielddecor('Enter Notes'),
                                maxLines: 2,
                              ),
                              SizedBox(height: 3.5.h),
                              SizedBox(
                                width: double.infinity,
                                child: AppElevetedButton(
                                  onPressed: () async {
                                    // Validate form before submitting
                                    if (_formkey.currentState!.validate()) {
                                      // Check if category is selected
                                      final provider =
                                          Provider.of<TransactionProvider>(
                                              context,
                                              listen: false);
                                      if (provider.categorySelected == null ||
                                          provider.categorySelected!.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(customSnak(context,
                                                message:
                                                    "Please select a category"));
                                        return;
                                      }

                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();

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
                                      ? 'Record'
                                      : 'Update',
                                ),
                              ),
                              SizedBox(height: 1.h)
                            ],
                          ),
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
