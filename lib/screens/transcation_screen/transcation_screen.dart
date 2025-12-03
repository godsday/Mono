import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:mono/constants/colors/app_color.dart';
import 'package:mono/database/Transctions_DB/transcations_db.dart';
import 'package:mono/providers/app_state.dart';
import 'package:mono/screens/edit_screen/edit_screen.dart';
import 'package:mono/screens/widgets/add_clipper.dart';
import 'package:mono/screens/widgets/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../models/transcation_model/transcation_model.dart';
import 'transcation_widgets/graph_widget.dart';
import 'transcation_widgets/heading_widget.dart';
import 'package:sizer/sizer.dart';

class TranscationScreen extends StatefulWidget {
  const TranscationScreen({Key? key}) : super(key: key);

  @override
  State<TranscationScreen> createState() => _TranscationScreenState();
}

class _TranscationScreenState extends State<TranscationScreen> {
  late TooltipBehavior _tooltipBehavior;
  //bool visible = false;

  var item = [ 'Income','All', 'Expense'];
  bool _onFirstPage = true;
  final ScrollController _scrollController = ScrollController();
  
  @override
  void initState() {
    // TranscationDB.instance.refresh();
    Provider.of<AppState>(context, listen: false).refresh();

    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TranscationDB.instance.refresh();
    return Scaffold(
      body: Column(
      // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipPath(
            clipper: CurveClipper(),
            child: Container(
              color: Theme.of(context).dividerColor,
              height: 15.0.h,
              child: Center(
                child: Text(
                  "Recent Transactions",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 40,
            alignment: Alignment.center,
            child: Consumer<AppState>(
              builder: (context, pro, child) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0.w),
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      final isSelected = pro.itemvalue == item[index];
                      
                      // Scroll to center the selected item
                      if (isSelected) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (_scrollController.hasClients) {
                            double screenWidth = MediaQuery.of(context).size.width;
                            double itemWidth = 100.0; // Approximate width
                            double scrollTo = index * itemWidth - (screenWidth / 2) + (itemWidth / 2);
                            _scrollController.animateTo(
                              scrollTo.clamp(0.0, _scrollController.position.maxScrollExtent),
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.elasticOut,
                            );
                          }
                        });
                      }
                      
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: InkWell(
                          onTap: () {
                            pro.itemvalue = item[index];                       
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            transform: isSelected
                                ? Matrix4.identity()
                                : Matrix4.rotationZ(index.isEven ? 0.1 : -0.1),
                            alignment: Alignment.center,
                            child: RotationTransition(
                              turns: AlwaysStoppedAnimation(isSelected ? 1.0 : 0.0),
                              child: ScaleTransition(
                                scale: Tween<double>(begin: isSelected ? 1.2 : 1.0, end: 1.0).animate(
                                  CurvedAnimation(parent: const AlwaysStoppedAnimation(0.0), curve: Curves.elasticOut),
                                ),
                                child: Text(
                                  item[index],
                                  style: TextStyle(
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    fontSize: isSelected ? 16.sp : 12.sp,
                                    color: isSelected ? Colors.blue : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(right: 10, left: 10),
          //   child: Consumer<AppState>(builder: (context, pro, child) {
          //     return Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Container(
          //           decoration: BoxDecoration(
          //               border:
          //                   Border.all(width: 1, color: Colors.blueGrey),
          //               borderRadius: BorderRadius.circular(10)),
          //           width: 35.0.w,
          //           height: 4.5.h,
          //           child: DropdownButtonFormField(
          //               iconSize: 24.sp,
          //               decoration:
          //                   const InputDecoration.collapsed(hintText: ''),
          //               value: pro.itemvalue,
          //               items: item.map((String value) {
          //                 return DropdownMenuItem<String>(
          //                   value: value,
          //                   child: Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: Text(
          //                       value,
          //                       style: TextStyle(
          //                           fontSize: 10.sp,
          //                           fontWeight: FontWeight.w400),
          //                     ),
          //                   ),
          //                 );
          //               }).toList(),
          //               onChanged: (String? newvalue) {
          //                 pro.itemvalue = newvalue!;
          //               }),
          //         ),
          //         pro.itemvalue == "Custom"
          //             ? TextButton.icon(
          //                 onPressed: () {
          //                   Provider.of<AppState>(context, listen: false)
          //                       .showdatepicker(context);
          //                 },
          //                 icon: Icon(
          //                   Icons.calendar_month_outlined,
          //                   color: Theme.of(context).colorScheme.background,
          //                   size: 15.sp,
          //                 ),
          //                 label: Text(
          //                   "Pick Date",
          //                   style: TextStyle(
          //                     color:
          //                         Theme.of(context).colorScheme.background,
          //                   ),
          //                 ),
          //               )
          //             : const SizedBox()
          //       ],
          //     );
          //   }),
          // ),
      
          Expanded(
            child: Container(
              width: double.infinity,
             
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                color: AppColor.blueContainer,
              ),
              child: Column(
                children: [
                  Consumer<AppState>(builder: (context, pro, child) {
                    return pro.itemvalue == "All"
                        ? VisibleChart(tooltipBehavior: _tooltipBehavior)
                        : pro.itemvalue == "Income"
                            ? VisibleChart(tooltipBehavior: _tooltipBehavior)
                            : pro.itemvalue == "Expense"
                                ? VisibleChart(
                                    tooltipBehavior: _tooltipBehavior)
                                : SizedBox(height: 2.h);
                  }),
                  
                  
    Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 0),
              child: Column(
                children: [
                  Consumer<AppState>(builder: (context, provider, child) {
                    return Container(
                        height: 6.h,
                        decoration: BoxDecoration(
                            color: Theme.of(context).hoverColor,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10))),
                        child: provider.headinginnermethod());
                  }),
                  Expanded(
                    child: Container(
                      color: const Color.fromARGB(255, 215, 215, 214),
                      //  Theme.of(context).hoverColor,
                      // margin: const EdgeInsets.only(bottom: 10.0),
                      child: ValueListenableBuilder(
                          valueListenable:
                              Provider.of<AppState>(context, listen: true)
                                  .listingMethod(),
                          builder: (BuildContext context,
                              List<TranscationModel> newlist, _) {
                            return newlist.isEmpty
                                ? Stack(children: [
                                    Lottie.asset(
                                        'assets/images/animation/paymentshero1.json')
                                  ])
                                : ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      TranscationModel value = newlist[index];
                                      print("newlist ${newlist[index].type}");
                        
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
                                                        .deletetranscation(
                                                            value.id);
                                                    // TranscationDB.instance.refresh();
                                                    Provider.of<AppState>(context,
                                                            listen: false)
                                                        .refresh();
                        
                                                    setState(() {});
                        
                                                    final snack = customSnak(
                                                        context,
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
                                                    Provider.of<AppState>(context,
                                                            listen: false)
                                                        .parsedate(value.date),
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
                                                              fontSize: 15.sp,
                                                              fontWeight:
                                                                  FontWeight.w600,
                                                              color: Colors.red),
                                                          // minFontSize: 12,
                                                          maxLines: 1,
                                                          textAlign: TextAlign.end,
                                                        ),
                                                      )
                                                    : SizedBox(
                                                        width: 35.w,
                                                        child: AutoSizeText(
                                                          "+ ₹${value.amount}",
                                                          style: TextStyle(
                                                              fontSize: 15.sp,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              color: Colors.green),
                                                          // minFontSize: 12,
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
                    ),
                  ),
                ],
              ),
            ),
          ),                ],
                
              ),
            )
          ),
      
        ],
      ),
    
    );
    
  }
}

class VisibleChart extends StatelessWidget {
  const VisibleChart({
    super.key,
    required TooltipBehavior tooltipBehavior,
  })  : _tooltipBehavior = tooltipBehavior;

  final TooltipBehavior _tooltipBehavior;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .3,
      width: MediaQuery.of(context).size.width,
      child: GraphWidget(tooltipBehavior: _tooltipBehavior,
      ),
    );
  }
}
