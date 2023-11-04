import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:mono/database/Transctions_DB/transcations_db.dart';
import 'package:mono/screens/edit_screen/edit_screen.dart';
import 'package:mono/screens/widgets/add_clipper.dart';
import 'package:mono/screens/widgets/snackbar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../models/transcation_model/transcation_model.dart';
import 'transcation_widgets/graph_widget.dart';
import 'transcation_widgets/heading_widget.dart';
import 'package:sizer/sizer.dart';

double totalBalance = 0;
double totalIncome = 0;
double totalExpense = 0;
String itemvalue = 'All';

class TranscationScreen extends StatefulWidget {
  const TranscationScreen({Key? key}) : super(key: key);

  @override
  State<TranscationScreen> createState() => _TranscationScreenState();
}

void totalBalanceCheck(List<TranscationModel> data) {
  totalBalance = 0;
  totalIncome = 0;
  totalExpense = 0;
  for (var value in data) {
    if (value.type == "Income") {
      totalIncome = totalIncome + value.amount;
    }
    if (value.type == 'Expense') {
      totalExpense = totalExpense + value.amount;
    }
    totalBalance = totalIncome - totalExpense;
  }
  if (totalBalance < 0) {
    totalBalance = 0;
  }
}

class _TranscationScreenState extends State<TranscationScreen> {
  DateTimeRange? dateRange;
  DateTime start = DateTime.now().subtract(const Duration(days: 3));
  DateTime end = DateTime.now();

  late TooltipBehavior _tooltipBehavior;
  //bool visible = false;

  var item = ['All', 'Income', 'Expense', 'Today', 'Yesterday', 'Custom'];

  @override
  void initState() {
    TranscationDB.instance.refresh();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TranscationDB.instance.refresh();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipPath(
                clipper: CurveClipper(),
                child: Container(
                  color: Theme.of(context).dividerColor,
                  height: 15.0.h,
                  child: Center(
                    child: Text(
                      " All Transctions",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.blueGrey),
                          borderRadius: BorderRadius.circular(10)),
                      width: 35.0.w,
                      height: 4.5.h,
                      child: DropdownButtonFormField(
                          iconSize: 24.sp,
                          decoration:
                              const InputDecoration.collapsed(hintText: ''),
                          value: itemvalue,
                          items: item.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  value,
                                  style: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newvalue) {
                            itemvalue = newvalue!;

                            setState(() {});
                          }),
                    ),
                    itemvalue == "Custom"
                        ? TextButton.icon(
                            onPressed: () {
                              showdatepicker();
                            },
                            icon: Icon(
                              Icons.calendar_month_outlined,
                              color: Theme.of(context).colorScheme.background,
                              size: 15.sp,
                            ),
                            label: Text(
                              "Pick Date",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.background,
                              ),
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
              ),
              itemvalue == "All"
                  ? VisibleChart(tooltipBehavior: _tooltipBehavior)
                  : itemvalue == "Income"
                      ? VisibleChart(tooltipBehavior: _tooltipBehavior)
                      : itemvalue == "Expense"
                          ? VisibleChart(tooltipBehavior: _tooltipBehavior)
                          : SizedBox(height: 2.h),
              Container(
                  height: 6.h,
                  decoration: BoxDecoration(
                      color: Theme.of(context).hoverColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child: headinginnermethod()),
              Container(
                color: Theme.of(context).hoverColor,
                height: 77.0.h,
                margin: const EdgeInsets.only(bottom: 10.0),
                child: ValueListenableBuilder(
                    valueListenable: listingmethod(),
                    builder: (BuildContext context,
                        List<TranscationModel> newlist, _) {
                      return newlist.isEmpty
                          ? Stack(children: [
                              Lottie.asset(
                                  'assets/images/animation/paymentshero1.json')
                            ])
                          : ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                TranscationModel value = newlist[index];

                                return Slidable(
                                  key: const ValueKey(1),
                                  startActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                            backgroundColor:
                                                Theme.of(context).hoverColor,
                                            foregroundColor:
                                                HexColor('#1976D2'),
                                            icon: Icons.edit,
                                            label: 'Edit',
                                            onPressed: ((context) async {
                                              final newvalue =
                                                  await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              EditScreen(
                                                                  value:
                                                                      value)));

                                              setState(() {
                                                value = newvalue;
                                              });
                                            })),
                                      ]),
                                  endActionPane: ActionPane(
                                      motion: const ScrollMotion(),
                                      children: [
                                        SlidableAction(
                                            backgroundColor:
                                                Theme.of(context).hoverColor,
                                            foregroundColor:
                                                HexColor('#B00020'),
                                            icon: Icons.delete,
                                            label: 'Delete',
                                            onPressed: ((context) {
                                              TranscationDB.instance
                                                  .deletetranscation(value.id);
                                              TranscationDB.instance.refresh();
                                              setState(() {});

                                              final snack = customSnak(context,
                                                  message: "Deleted");

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snack);
                                            })),
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: InkWell(
                                        onTap: (() {}),
                                        focusColor: Colors.black38,
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor:
                                                HexColor('#efefef'),
                                            radius: 26,
                                            child: Text(
                                              parsedate(value.date),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10.sp),
                                            ),
                                          ),
                                          title: Text(value.category,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.sp)),
                                          subtitle: Text(
                                            "${value.purpose}",
                                            maxLines: 1,
                                          ),
                                          trailing: value.type == 'Expense'
                                              ? SizedBox(
                                                  width: 34.w,
                                                  child: AutoSizeText(
                                                    "- ₹${value.amount}",
                                                    style: TextStyle(
                                                        fontSize: 13.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.red),
                                                    minFontSize: 12,
                                                    maxLines: 1,
                                                    textAlign: TextAlign.end,
                                                  ),
                                                )
                                              : SizedBox(
                                                  width: 35.w,
                                                  child: AutoSizeText(
                                                    "+ ₹${value.amount}",
                                                    style: TextStyle(
                                                        fontSize: 13.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.green),
                                                    minFontSize: 12,
                                                    maxLines: 1,
                                                    textAlign: TextAlign.end,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              itemCount: newlist.length,
                            );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  headinginnermethod() {
    if (itemvalue == "Income") {
      return HeadingMethod(
          headtext: 'My savings', amount: totalIncome.toStringAsFixed(1));
    } else if (itemvalue == 'Expense') {
      return HeadingMethod(
          headtext: ' My spendings', amount: totalExpense.toStringAsFixed(1));
    } else if (itemvalue == 'Today') {
      return HeadingMethod(headtext: 'Today');
    } else if (itemvalue == 'Yesterday') {
      return HeadingMethod(headtext: 'Yesterday');
    } else if (itemvalue == 'Custom') {
      return HeadingMethod(headtext: 'Custom');
    } else {
      return HeadingMethod(
          headtext: 'All Transcations',
          amount: totalBalance.toStringAsFixed(1));
    }
  }

  listingmethod() {
    if (itemvalue == "Income") {
      return TranscationDB.instance.incomelistnotifier;
    } else if (itemvalue == "Expense") {
      return TranscationDB.instance.expenselistnotifier;
    } else if (itemvalue == "Today") {
      return TranscationDB.instance.todaylistnotifier;
    } else if (itemvalue == "Yesterday") {
      return TranscationDB.instance.yesterdaylistnotifier;
    } else if (itemvalue == "Custom") {
      return TranscationDB.instance.customlistnotifier;
    } else {
      return TranscationDB.instance.transcationNotifier;
    }
  }

  String parsedate(DateTime date) {
    final date0 = DateFormat().add_MMMd().format(date);
    final splitdate = date0.split(" ");
    return '${splitdate.last}\n${splitdate.first}';
  }

  showdatepicker() async {
    final newdateRange = await showDateRangePicker(
      context: context,
      initialDateRange: dateRange,
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );
    if (newdateRange == null) return;
    setState(() {
      dateRange = newdateRange;
      start = dateRange!.start;
      end = dateRange!.end;
    });
    TranscationDB.instance.custompick(start, end);
  }
}

class VisibleChart extends StatelessWidget {
  const VisibleChart({
    Key? key,
    required TooltipBehavior tooltipBehavior,
  })  : _tooltipBehavior = tooltipBehavior,
        super(key: key);

  final TooltipBehavior _tooltipBehavior;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .3,
      width: MediaQuery.of(context).size.width,
      child: GraphWidget(
        tooltipBehavior: _tooltipBehavior,
      ),
    );
  }
}
