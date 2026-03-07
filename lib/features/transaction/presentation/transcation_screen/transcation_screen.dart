import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:mono/core/constants/app_textstyle/app_textstyle.dart';
import 'package:mono/core/constants/colors/app_colors.dart';
import 'package:mono/core/theme/app_theme.dart';
import 'package:mono/features/transaction/data/models/transcation_model.dart';
import 'package:mono/features/transaction/presentation/providers/transaction_provider.dart';
import 'package:mono/features/transaction/presentation/transcation_screen/transcation_widgets/get_category_icon.dart';
import 'package:mono/features/transaction/presentation/transcation_screen/transcation_widgets/transcation_header.dart';
import 'package:mono/features/transaction/presentation/transcation_screen/transcation_widgets/heading_widget.dart';

import 'package:mono/core/widgets/snackbar.dart';
import 'package:mono/routes/route_names.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'transcation_widgets/graph_widget.dart';
import 'package:sizer/sizer.dart';

class TranscationScreen extends StatefulWidget {
  const TranscationScreen({super.key});

  @override
  State<TranscationScreen> createState() => _TranscationScreenState();
}

class _TranscationScreenState extends State<TranscationScreen> {
  late TooltipBehavior _tooltipBehavior;

  var item = ['Income', 'All', 'Expense'];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TranscationDB.instance.refresh();
    Provider.of<TransactionProvider>(context, listen: false).refresh();

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
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(100), child: TranscationHeader()),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                      onTap: () {
                        Provider.of<TransactionProvider>(context, listen: false)
                            .graphView();
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: Provider.of<TransactionProvider>(context,
                                          listen: false)
                                      .visible
                                  ? AppColor.blueContainer
                                  : Colors.amberAccent,
                              borderRadius: BorderRadius.circular(4)),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Text(
                              Provider.of<TransactionProvider>(context,
                                          listen: false)
                                      .visible
                                  ? "Hide"
                                  : "Show",
                              style: AppTextStyles.poppins16w400.copyWith(
                                  fontSize: 13, color: AppColor.blackColor),
                            ),
                          ))),
                ],
              ),
            ),
            AnimatedCrossFade(
              firstCurve: Curves.easeOut,
              crossFadeState:
                  Provider.of<TransactionProvider>(context, listen: false)
                          .visible
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,

              sizeCurve: Curves.easeIn,

              duration: const Duration(
                  milliseconds: 700), // Set the animation duration

              firstChild:
                  Consumer<TransactionProvider>(builder: (context, pro, child) {
                return pro.itemvalue == "All"
                    ? VisibleChart(tooltipBehavior: _tooltipBehavior)
                    : pro.itemvalue == "Income"
                        ? VisibleChart(tooltipBehavior: _tooltipBehavior)
                        : pro.itemvalue == "Expense"
                            ? VisibleChart(tooltipBehavior: _tooltipBehavior)
                            : SizedBox(height: 2.h);
              }),

              secondChild: const SizedBox.shrink(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: SizedBox(
                width: double.infinity,
                height: 40,
                // alignment: Alignment.topCenter,
                child: Consumer<TransactionProvider>(
                  builder: (context, pro, child) {
                    return ListView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: item.length,
                      itemBuilder: (context, index) {
                        final isSelected = pro.itemvalue == item[index];
                        // Scroll to center the selected item
                        if (isSelected) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (_scrollController.hasClients) {
                              double screenWidth =
                                  MediaQuery.of(context).size.width;
                              double itemWidth = 100.0; // Approximate width
                              double scrollTo = index * itemWidth -
                                  (screenWidth / 2) +
                                  (itemWidth / 2);
                              _scrollController.animateTo(
                                scrollTo.clamp(0.0,
                                    _scrollController.position.maxScrollExtent),
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.elasticOut,
                              );
                            }
                          });
                        }

                        return Padding(
                          key: ValueKey(item[index]),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 5),
                          child: InkWell(
                            onTap: () {
                              pro.itemvalue = item[index];
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              // transform: isSelected
                              //     ? Matrix4.identity()
                              //     : Matrix4.rotationZ(index.isEven ? 0 : 0),
                              alignment: Alignment.center,
                              child: RotationTransition(
                                turns: AlwaysStoppedAnimation(
                                    isSelected ? 1.0 : 0.0),
                                child: ScaleTransition(
                                  scale: Tween<double>(
                                          begin: isSelected ? 1.2 : 1.0,
                                          end: 1.0)
                                      .animate(
                                    CurvedAnimation(
                                        parent:
                                            const AlwaysStoppedAnimation(0.0),
                                        curve: Curves.elasticOut),
                                  ),
                                  child: Text(
                                    item[index],
                                    style: TextStyle(
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      fontSize: isSelected ? 17.sp : 14.sp,
                                      color: isSelected
                                          ? Theme.of(context).primaryColor
                                          : AppColor.textGrey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Expanded(
                child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 4.h,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade500,
                            blurRadius: 4,
                            offset: const Offset(0, 0),
                          ),
                        ],
                        //top bar color

                        color: Theme.of(context)
                            .extension<AppGradients>()!
                            .transactionListBg,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildFilterChip('Today', context),
                        _buildFilterChip('Weekly', context),
                        _buildFilterChip('Monthly', context),
                        IconButton(
                          icon: Icon(
                            Icons.calendar_month_outlined,
                            size: 15.sp,
                          ),
                          color: AppColor.textGrey,
                          onPressed: () {
                            _showCustomDatePicker(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  Consumer<TransactionProvider>(
                      builder: (context, provider, child) {
                    return Container(
                        height: 4.h,
                        decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade500,
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ]),
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15.0,
                            ),
                            child: Builder(builder: (context) {
                              final headingData = provider.getHeadingData();
                              return HeadingMethod(
                                headtext: headingData.title,
                                amount: headingData.amount,
                              );
                            })));
                  }),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context)
                              .extension<AppGradients>()!
                              .transactionListBg,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade500,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]),
                      child: ValueListenableBuilder(
                          valueListenable: Provider.of<TransactionProvider>(
                                  context,
                                  listen: true)
                              .listingMethod(),
                          builder: (BuildContext context,
                              List<TranscationModel> newlist, _) {
                            return newlist.isEmpty
                                ? Stack(children: [
                                    Lottie.asset(
                                        'assets/images/animation/paymentshero1.json')
                                  ])
                                : _buildGroupedTransactionList(
                                    Provider.of<TransactionProvider>(context,
                                            listen: false)
                                        .groupedTransactions,
                                    context);
                          }),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class VisibleChart extends StatelessWidget {
  const VisibleChart({
    super.key,
    required TooltipBehavior tooltipBehavior,
  }) : _tooltipBehavior = tooltipBehavior;

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

Widget _buildFilterChip(String filterName, BuildContext context) {
  return Consumer<TransactionProvider>(
    key: ValueKey('filter_$filterName'),
    builder: (context, provider, child) {
      final isSelected = provider.itemvalue == filterName;
      return GestureDetector(
        onTap: () {
          provider.itemvalue = filterName;
          // Refresh the data when filter changes
          provider.refresh();
        },
        child: Text(
          filterName,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: isSelected ? 15.sp : 14.sp,
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
          ),
        ),
      );
    },
  );
}

Widget _buildGroupedTransactionList(
    Map<String, List<TranscationModel>> groupedTransactions,
    BuildContext context) {
  // Create a list of widgets with date headers and transactions
  List<Widget> widgets = [];

  groupedTransactions.forEach((dateDisplay, transactionList) {
    // Add date header
    widgets.add(
      Container(
        key: ValueKey('header_$dateDisplay'),
        // alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(
          left: 15.0,
          top: 10.0,
          bottom: 5.0,
          right: 15.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dateDisplay,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );

    // Add transactions for this date
    for (var transaction in transactionList) {
      widgets.add(
        Slidable(
          key: ValueKey(transaction.id),
          startActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                backgroundColor: Theme.of(context)
                    .extension<AppGradients>()!
                    .transactionListBg,
                foregroundColor: HexColor('#1976D2'),
                icon: Icons.edit,
                label: 'Edit',
                onPressed: ((context) {
                  Navigator.pushNamed(context, RouteNames.addTransaction,
                      arguments: transaction);

                  // Update transaction if needed
                }),
              ),
            ],
          ),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                backgroundColor: Theme.of(context)
                    .extension<AppGradients>()!
                    .transactionListBg,
                foregroundColor: HexColor('#B00020'),
                icon: Icons.delete,
                label: 'Delete',
                onPressed: ((context) {
                  Provider.of<TransactionProvider>(context, listen: false)
                      .deleteTransaction(transaction.id);

                  final snack = customSnak(context, message: "Deleted");
                  ScaffoldMessenger.of(context).showSnackBar(snack);
                }),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Card(
              shadowColor: AppColor.borderGreyWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(
                  color: Colors.white24,
                  width: 1,
                ),
              ),
              child: GestureDetector(
                onTap: () {},
                child: ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .extension<AppGradients>()
                          ?.transactionListBg,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColor.borderGreyWhite,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: GetCategoryIcon(
                          category: transaction.category,
                          type: transaction.type),
                    ),
                  ),
                  title: Text(
                    transaction.category,
                    maxLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                  subtitle: Text(
                    Provider.of<TransactionProvider>(context, listen: false)
                        .parsedate(transaction.date),
                    style: TextStyle(
                      fontSize: 14.sp,
                    ),
                  ),
                  trailing: transaction.type == 'Expense'
                      ? SizedBox(
                          width: 34.w,
                          child: AutoSizeText(
                            "- ${transaction.amount.toStringAsFixed(0)}",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.red,
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.end,
                          ),
                        )
                      : SizedBox(
                          width: 35.w,
                          child: AutoSizeText(
                            "+ ${transaction.amount.toStringAsFixed(0)}",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                            maxLines: 1,
                            textAlign: TextAlign.end,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  });

  return ListView.builder(
    padding: const EdgeInsets.only(top: 3),
    physics: const BouncingScrollPhysics(),
    itemCount: widgets.length,
    itemBuilder: (context, index) {
      return widgets[index];
    },
  );
}

void _showCustomDatePicker(BuildContext context) async {
  final dateRange = await showDateRangePicker(
    context: context,
    firstDate: DateTime(2020),
    lastDate: DateTime.now(),
    initialDateRange: DateTimeRange(
      start: DateTime.now().subtract(const Duration(days: 7)),
      end: DateTime.now(),
    ),
  );

  if (dateRange != null) {
    if (!context.mounted) return;
    // Update the provider with the selected date range
    final provider = Provider.of<TransactionProvider>(context, listen: false);
    provider.itemvalue = 'Custom';
    provider.custompick(dateRange.start, dateRange.end);
    provider.refresh();
  }
}
