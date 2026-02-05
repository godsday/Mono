import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mono/core/constants/colors/app_colors.dart';
import 'package:mono/core/constants/app_textstyle/app_textstyle.dart';
import 'package:mono/database/Transctions_DB/transcations_db.dart';
import 'package:mono/features/transaction/data/datasources/transaction_local_data_source.dart';
import 'package:mono/features/transaction/domain/entities/transaction_entity.dart'
    hide TranscationModel;
import 'package:mono/features/transaction/data/models/transcation_model.dart';
import 'package:mono/core/widgets/decoration_functions.dart';
import 'package:mono/core/widgets/snackbar.dart';
import 'package:sizer/sizer.dart';
import 'package:mono/features/widgets/add_clipper.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class EditScreen extends StatefulWidget {
  final TranscationModel value;
  const EditScreen({
    super.key,
    required this.value,
  });

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  List<dynamic> transcationType = [];
  List<dynamic> categorieslist = [];
  List<dynamic> categories = [];

  String? transctiontypeid;
  String? categoryid;

  DateTime selectedDate = DateTime.now();

  final _amountcontrol = TextEditingController();
  final _notescontrol = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    _amountcontrol.text = widget.value.amount.toString();
    _notescontrol.text = widget.value.purpose.toString();
    selectedDate = widget.value.date;

    transcationType.add({"id": "Income", 'name': 'Income'});
    transcationType.add({"id": 'Expense', "name": 'Expense'});

    categorieslist = [
      {
        'Id': 'Shopping',
        'Name': 'Shopping',
        'parentId': 'Expense,',
      },
      {'Id': 'Travel', 'Name': 'Travel', 'parentId': 'Expense'},
      {'Id': 'Food', 'Name': 'Food', 'parentId': 'Expense'},
      {'Id': 'Rental', 'Name': 'Rental', 'parentId': 'Expense'},
      {'Id': 'Medical', 'Name': 'Medical', 'parentId': 'Expense'},
      {'Id': 'Insurance', 'Name': 'Insurance', 'parentId': 'Expense'},
      {'Id': 'Investments', 'Name': 'Investments', 'parentId': 'Expense'},
      {'Id': 'Utilities', 'Name': 'Utilites', 'parentId': 'Expense'},
      {'Id': 'Educations', 'Name': 'Educations', 'parentId': 'Expense'},
      {'Id': 'Entertainment', 'Name': 'Entertainment', 'parentId': 'Expense'},
      {'Id': 'Other', 'Name': 'Other', 'parentId': 'Expense'},
      {'Id': 'Salary', 'Name': 'Salary', 'parentId': 'Income'},
      {'Id': 'Freelance', 'Name': 'Freelance', 'parentId': 'Income'},
      {'Id': 'Commission', 'Name': 'Commission', 'parentId': 'Income'},
      {'Id': 'Investments', 'Name': 'Investments', 'parentId': 'Income'},
      {'Id': 'Rental', 'Name': 'Rental', 'parentId': 'Income'},
      {'Id': 'Other', 'Name': 'Other', 'parentId': 'Income'},
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: 90.h,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipPath(
                  clipper: CurveClipper(),
                  child: Container(
                    color: Theme.of(context).dividerColor,
                    height: 40.h,
                  ),
                ),
                Positioned(
                  top: 5.h,
                  left: 30.w,
                  child: Text(
                    "Edit Transcation",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
                Positioned(
                  top: 12.h,
                  left: 5.w,
                  child: Container(
                    width: 90.0.w,
                    height: 82.h,
                    decoration: BoxDecoration(
                        color: Theme.of(context).dialogTheme.backgroundColor ??
                            Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withValues(alpha: 1),
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
                              'transcation type',
                              style: AppTextStyles.poppins16w400,
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            FormHelper.dropDownWidget(
                              context,
                              widget.value.type,
                              transctiontypeid,
                              transcationType,
                              (onchangeval) {
                                categoryid = null;
                                setState(() {});
                                transctiontypeid = onchangeval;

                                setState(() {
                                  categories = categorieslist
                                      .where((categoryItem) =>
                                          categoryItem["parentId"].toString() ==
                                          onchangeval.toString())
                                      .toList();
                                });
                              },
                              (onValidate) {
                                final snack = customSnak(context,
                                    message: "Select transcation type ");
                                if (transctiontypeid == null) {
                                  return ScaffoldMessenger.of(context)
                                      .showSnackBar(snack);
                                } else {
                                  return null;
                                }
                              },
                              borderColor: Colors.grey,
                              borderRadius: 10,
                              borderFocusColor: AppColor.mainHexcolor,
                              paddingLeft: 1,
                              paddingRight: 1,
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Text(
                              'Amount',
                              style: AppTextStyles.poppins16w400,
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return;
                                }
                                return null;
                              },
                              controller: _amountcontrol,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(12),
                              ],
                              keyboardType: TextInputType.number,
                              decoration: textfielddecor("Enter Amount"),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Text(
                              'Date',
                              style: AppTextStyles.poppins16w400,
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            ElevatedButton.icon(
                              onPressed: () async {
                                final date = await pickDate(context);
                                if (date == null) return;
                                setState(() {
                                  selectedDate = date;
                                });
                              },
                              icon: const Icon(
                                Icons.calendar_month,
                                color: Colors.grey,
                              ),
                              label: Padding(
                                padding: const EdgeInsets.only(right: 150.0),
                                child: Text(
                                  '${selectedDate.day} / ${selectedDate.month} / ${selectedDate.year}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Theme.of(context)
                                        .dialogTheme
                                        .backgroundColor ??
                                    Theme.of(context).cardColor,
                                side: const BorderSide(color: Colors.grey),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                minimumSize: const Size(400, 50),
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Text(
                              'Categories',
                              style: AppTextStyles.poppins16w400,
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            FormHelper.dropDownWidget(
                              context,
                              widget.value.category,
                              categoryid,
                              categories,
                              (onchangeval) {
                                setState(() {});
                                categoryid = onchangeval;
                              },
                              (onValidate) {
                                final snack = customSnak(context,
                                    message: "Please select category");
                                if (categoryid == null) {
                                  return ScaffoldMessenger.of(context)
                                      .showSnackBar(snack);
                                } else {
                                  return null;
                                }
                              },
                              borderColor: Colors.grey,
                              borderRadius: 10,
                              borderFocusColor: AppColor.mainHexcolor,
                              optionValue: "Id",
                              optionLabel: "Name",
                              paddingLeft: 1,
                              paddingRight: 1,
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            Text(
                              'Notes',
                              style: AppTextStyles.poppins16w400,
                            ),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(8)
                              ],
                              controller: _notescontrol,
                              keyboardType: TextInputType.text,
                              decoration: textfielddecor('Enter Notes'),
                            ),
                            SizedBox(
                              height: 3.5.h,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                updatetranscation();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).primaryColorLight,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                minimumSize: const Size(400, 55),
                              ),
                              child: const Text(
                                'Update',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 246, 243, 243)),
                              ),
                            ),
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

  Future<DateTime?> pickDate(context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
    return null;
  }

  Future updatetranscation() async {
    final amountval = _amountcontrol.text;
    final purposeval = _notescontrol.text;

    final parseamount = double.tryParse(amountval);
    if (parseamount == null || parseamount.isNegative || parseamount == 0) {
      final snack = customSnak(context, message: "Enter valid number");
      return ScaffoldMessenger.of(context).showSnackBar(snack);
    }
    if (categoryid == null) {
      final snack = customSnak(context, message: "Please select category");
      return ScaffoldMessenger.of(context).showSnackBar(snack);
    }
    final model = TranscationModel(
        type: transctiontypeid!,
        amount: parseamount,
        date: selectedDate,
        category: categoryid!,
        purpose: purposeval,
        id: widget.value.id);

    TransactionLocalDataSourceImpl.instance.updateTransaction(model);

    Navigator.of(context).pop(model);
  }
}
