import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mono/constants/app_color.dart';
import 'package:mono/database/Transctions_DB/transcations_db.dart';
import 'package:mono/models/transcation_model/transcation_model.dart';
import 'package:mono/providers/app_state.dart';
import 'package:mono/screens/add_screen/decoration_functions.dart';
import 'package:mono/screens/transcation_screen/transcation_screen.dart';
import 'package:mono/screens/widgets/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:mono/screens/widgets/add_clipper.dart';
import 'package:mono/screens/widgets/bottomnavigationbar.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({Key? key}) : super(key: key);

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  List<dynamic> transcationType = [];
  List<dynamic> categorieslist = [];
  List<dynamic> categories = [];
  String? selectedValue;
  String? transctiontypeid;
  String? categoryid;

  DateTime selectedDate = DateTime.now();

  final _amountcontrol = TextEditingController();
  final _notescontrol = TextEditingController();

  final _formkey = GlobalKey<FormState>();
  List<String> incomeList = [
    "Salary",
    "commision",
    "Gift",
    "Rental",
    "Credit",
    "Other"
  ];
  List<String> expenseList = [
    "Shopping",
    "Travel",
    "Food",
    "Medical",
    "Insurence",
    "Utilities",
    "Education",
    "Entertaiment",
    "Debit,",
    "Other"
  ];

  @override
  void initState() {
    super.initState();

    transcationType.add({"id": "Income", 'name': 'Income'});
    transcationType.add({
      "id": 'Expense',
      "name": 'Expense',
    });

    // categorieslist = [
    //   {
    //     'Id': 'Shopping',
    //     'Name': 'Shopping',
    //     'parentId': 'Expense,',
    //   },
    //   {'Id': 'Travel', 'Name': 'Travel', 'parentId': 'Expense'},
    //   {'Id': 'Food', 'Name': 'Food', 'parentId': 'Expense'},
    //   {'Id': 'Rental', 'Name': 'Rental', 'parentId': 'Expense'},
    //   {'Id': 'Medical', 'Name': 'Medical', 'parentId': 'Expense'},
    //   {'Id': 'Insurance', 'Name': 'Insurance', 'parentId': 'Expense'},
    //   {'Id': 'Investments', 'Name': 'Investments', 'parentId': 'Expense'},
    //   {'Id': 'Utilities', 'Name': 'Utilites', 'parentId': 'Expense'},
    //   {'Id': 'Educations', 'Name': 'Educations', 'parentId': 'Expense'},
    //   {'Id': 'Entertainment', 'Name': 'Entertainment', 'parentId': 'Expense'},
    //   {'Id': 'Other', 'Name': 'Other', 'parentId': 'Expense'},
    //   {'Id': 'Salary', 'Name': 'Salary', 'parentId': 'Income'},
    //   {'Id': 'Freelance', 'Name': 'Freelance', 'parentId': 'Income'},
    //   {'Id': 'Commission', 'Name': 'Commission', 'parentId': 'Income'},
    //   {'Id': 'Investments', 'Name': 'Investments', 'parentId': 'Income'},
    //   {'Id': 'Rental', 'Name': 'Rental', 'parentId': 'Income'},
    //   {'Id': 'Other', 'Name': 'Other', 'parentId': 'Income'},
    // ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
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
                    "Add Transcation",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
                Positioned(
                  top: 12.h,
                  left: 5.0.w,
                  child: Container(
                    width: 90.0.w,
                    height: 82.0.h,
                    decoration: BoxDecoration(
                        color: Theme.of(context).dialogBackgroundColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                              color: const Color.fromARGB(255, 241, 234, 234)
                                  .withOpacity(1),
                              blurRadius: 5)
                        ]),
                    child: Form(
                      key: _formkey,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            textstyle("Transcation type"),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Consumer<AppState>(
                                builder: (context, provider, child) => Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Radio.adaptive(
                                          groupValue: provider.selectedValue,
                                          value: "Expense",
                                          onChanged: (String? value) {
                                            provider.selectedValue = value!;
                                            provider.categorySelected =
                                                expenseList.first;
                                          }),
                                      textstyle("Expense"),
                                      SizedBox(
                                        width: 20.sp,
                                      ),
                                      Radio.adaptive(
                                          groupValue: provider.selectedValue,
                                          value: "Income",
                                          onChanged: (String? value) {
                                            provider.selectedValue = value!;
                                            provider.categorySelected =
                                                incomeList.first;
                                            print("checking ${selectedValue}");
                                          }),
                                      textstyle("Income"),
                                    ]),
                              ),
                            ),

                            // FormHelper.dropDownWidget(
                            //     context,
                            //     "Select Transcation Type",
                            //     transctiontypeid,
                            //     transcationType, (onchangeval) {
                            //   categoryid = null;
                            //   setState(() {});
                            //   transctiontypeid = onchangeval;
                            //   categories = categorieslist
                            //       .where((categoryItem) =>
                            //           categoryItem["parentId"].toString() ==
                            //           onchangeval.toString())
                            //       .toList();
                            // }, (onValidate) {
                            //   final snack = customSnak(context,
                            //       message: "Select transcation type ");
                            //   if (transctiontypeid == null) {
                            //     return ScaffoldMessenger.of(context)
                            //         .showSnackBar(snack);
                            //   } else {
                            //     return null;
                            //   }
                            // },
                            //     borderColor: Colors.grey,
                            //     borderRadius: 10,
                            //     borderFocusColor: mainHexcolor,
                            //     paddingLeft: 1,
                            //     paddingRight: 1,
                            //     textColor: Colors.white),

                            SizedBox(
                              height: 2.h,
                            ),
                            textstyle('Amount'),
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
                            textstyle("Date"),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            Consumer<AppState>(
                              builder: (context, provider, child) =>
                                  ElevatedButton.icon(
                                onPressed: () async {
                                  final date = await pickDate(context);
                                  if (date == null) return;

                                  provider.selectedDate = date;
                                },
                                icon: const Icon(
                                  Icons.calendar_month,
                                  color: Colors.grey,
                                ),
                                label: Padding(
                                  padding: const EdgeInsets.only(right: 150.0),
                                  child: Text(
                                    '${selectedDate.day} / ${selectedDate.month} / ${selectedDate.year}',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor:
                                      Theme.of(context).dialogBackgroundColor,
                                  side: const BorderSide(color: Colors.grey),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  minimumSize: const Size(400, 50),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 2.h,
                            ),
                            textstyle("Categories"),
                            SizedBox(
                              height: 1.5.h,
                            ),
                            Consumer<AppState>(
                              builder: (context, provider, child) =>
                                  DropdownButton(
                                isExpanded: true,
                                hint: textstyle("Select Category"),
                                onChanged: (String? value) {
                                  print(
                                      "checking ${provider.categorySelected}");
                                  provider.categorySelected!.isNotEmpty;
                                  provider.categorySelected = value;
                                },
                                items: provider.selectedValue == "Income"
                                    ? incomeList.map<DropdownMenuItem<String>>(
                                        (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList()
                                    : expenseList.map<DropdownMenuItem<String>>(
                                        (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                value: provider.categorySelected,
                              ),
                            ),

                            // FormHelper.dropDownWidget(
                            //   context,
                            //   "Select categories",
                            //   categoryid,
                            //   categories,
                            //   (onchangeval) {
                            //     setState(() {});
                            //     categoryid = onchangeval;
                            //   },
                            //   (onValidate) {
                            //     final snack = customSnak(context,
                            //         message: "Please select category");
                            //     if (categoryid == null) {
                            //       return ScaffoldMessenger.of(context)
                            //           .showSnackBar(snack);
                            //     } else {
                            //       return null;
                            //     }
                            //   },
                            //   borderColor: Colors.grey,
                            //   borderRadius: 10,
                            //   borderFocusColor: mainHexcolor,
                            //   optionValue: "Id",
                            //   optionLabel: "Name",
                            //   paddingLeft: 1,
                            //   paddingRight: 1,
                            // ),
                            // AddTodoButton(
                            //     selectedindex:
                            //         selecteddropdownindexnotifier.value),

                            //                    ElevatedButton(onPressed: (){
                            //                         Navigator.of(context).push(HeroDialogRoute(builder: (context) {
                            //   return const _AddTodoPopupCard();
                            // }));
                            //                    }, child:const Text("add categories")),///////////////////////////////////////
                            SizedBox(
                              height: 2.h,
                            ),
                            textstyle("Notes"),
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
                            SizedBox(height: 3.5.h),
                            ElevatedButton(
                              onPressed: () {
                                if (_formkey.currentState!.validate()) {
                                  addtransbutton();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 2,
                                backgroundColor:
                                    Theme.of(context).primaryColorLight,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                minimumSize: const Size(400, 55),
                              ),
                              child: const Text(
                                'Add',
                                style: TextStyle(color: Colors.white),
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

  Future addtransbutton() async {
    final amountval = _amountcontrol.text;
    final purposeval = _notescontrol.text;

    final parseamount = double.tryParse(amountval);
    if (parseamount == null || parseamount == 0 || parseamount.isNegative) {
      final snack = customSnak(context, message: "Enter valid number");
      return ScaffoldMessenger.of(context).showSnackBar(snack);
    }
    // if (categoryid == null) {
    //   return;
    // }

    final model = TranscationModel(
        type: transctiontypeid!,
        amount: parseamount,
        date: selectedDate,
        category: categoryid!,
        purpose: purposeval,
        id: DateTime.now().millisecondsSinceEpoch.toString());
    TranscationDB.instance.addtranscation(model);
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const BottomNavigator()));
  }
}
