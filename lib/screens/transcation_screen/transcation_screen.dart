import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:mono/core/constants/colors/app_colors.dart';
import 'package:mono/database/Transctions_DB/transcations_db.dart';
import 'package:mono/providers/app_state.dart';
import 'package:mono/screens/edit_screen/edit_screen.dart';
import 'package:mono/screens/widgets/add_clipper.dart';
import 'package:mono/core/widgets/snackbar.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../models/transcation_model/transcation_model.dart';
import 'transcation_widgets/graph_widget.dart';
import 'package:sizer/sizer.dart';

class TranscationScreen extends StatefulWidget {
  const TranscationScreen({Key? key}) : super(key: key);

  @override
  State<TranscationScreen> createState() => _TranscationScreenState();
}

class _TranscationScreenState extends State<TranscationScreen> {
  late TooltipBehavior _tooltipBehavior;
  //bool visible = false;

  var item = ['Income', 'All', 'Expense'];
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

  Widget _getCategoryIcon(String category, String type) {
    // Define icon mappings based on category
    switch (category.toLowerCase()) {
      case 'salary':
        return Icon(Icons.account_balance_wallet, color: Colors.blue);
      case 'shopping':
        return Icon(Icons.shopping_cart, color: Colors.purple);
      case 'food':
        return Icon(Icons.fastfood, color: Colors.orange);
      case 'travel':
        return Icon(Icons.flight, color: Colors.blueAccent);
      case 'medical':
        return Icon(Icons.local_hospital, color: Colors.red);
      case 'utilities':
        return Icon(Icons.lightbulb, color: Colors.yellow);
      case 'education':
      case 'educations':
        return Icon(Icons.school, color: Colors.green);
      case 'entertainment':
        return Icon(Icons.movie, color: Colors.pink);
      case 'insurance':
        return Icon(Icons.security, color: Colors.indigo);
      case 'rental':
        return Icon(Icons.home, color: Colors.brown);
      case 'gift':
        return Icon(Icons.card_giftcard, color: Colors.purpleAccent);
      case 'freelance':
        return Icon(Icons.work, color: Colors.teal);
      case 'commission':
        return Icon(Icons.business, color: Colors.deepOrange);

      case 'investments':
        return Icon(Icons.trending_up, color: Colors.greenAccent);
      case 'credit':
        return Icon(Icons.credit_card, color: Colors.blueGrey);
      case 'debit':
        return Icon(Icons.account_balance, color: Colors.redAccent);
      case 'other':
        return Icon(
          type == 'Income' ? Icons.attach_money : Icons.money_off,
          color: type == 'Income' ? Colors.green : Colors.red,
        );
      default:
        return Icon(
          type == 'Income' ? Icons.arrow_downward : Icons.arrow_upward,
          color: type == 'Income' ? Colors.green : Colors.red,
        );
    }
  }

  Widget _buildFilterChip(String filterName, BuildContext context) {
    return Consumer<AppState>(
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
              fontSize: isSelected ? 14.sp : 12.sp,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
          ),
        );
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
      // Update the provider with the selected date range
      final provider = Provider.of<AppState>(context, listen: false);
      provider.itemvalue = 'Custom';
      provider.custompick(dateRange.start, dateRange.end);
      provider.refresh();
    }
  }

  Widget _buildGroupedTransactionList(List<TranscationModel> transactions) {
    // Group transactions by date
    Map<String, List<TranscationModel>> groupedTransactions = {};
    DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    DateFormat displayFormat = DateFormat('MMM d, yyyy');

    for (var transaction in transactions) {
      String dateKey = dateFormat.format(transaction.date);
      if (!groupedTransactions.containsKey(dateKey)) {
        groupedTransactions[dateKey] = [];
      }
      groupedTransactions[dateKey]!.add(transaction);
    }

    // Create a list of widgets with date headers and transactions
    List<Widget> widgets = [];

    groupedTransactions.forEach((dateKey, transactionList) {
      // Add date header
      DateTime date = dateFormat.parse(dateKey);
      String dateDisplay = displayFormat.format(date);

      // Check if it's today or yesterday
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = DateTime(now.year, now.month, now.day - 1);
      final transactionDate = DateTime(date.year, date.month, date.day);

      String dayLabel = '';
      if (transactionDate.isAtSameMomentAs(today)) {
        dayLabel = 'Today';
      } else if (transactionDate.isAtSameMomentAs(yesterday)) {
        dayLabel = 'Yesterday';
      }

      widgets.add(
        Container(
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
              if (dayLabel.isNotEmpty)
                Text(
                  '$dayLabel ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    color: Colors.grey[700],
                  ),
                ),
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
                  backgroundColor: Theme.of(context).hoverColor,
                  foregroundColor: HexColor('#1976D2'),
                  icon: Icons.edit,
                  label: 'Edit',
                  onPressed: ((context) async {
                    final newvalue = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EditScreen(value: transaction)));

                    setState(() {
                      // Update transaction if needed
                    });
                  }),
                ),
              ],
            ),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  backgroundColor: Theme.of(context).hoverColor,
                  foregroundColor: HexColor('#B00020'),
                  icon: Icons.delete,
                  label: 'Delete',
                  onPressed: ((context) {
                    TranscationDB.instance.deletetranscation(transaction.id);
                    Provider.of<AppState>(context, listen: false).refresh();

                    setState(() {});

                    final snack = customSnak(context, message: "Deleted");
                    ScaffoldMessenger.of(context).showSnackBar(snack);
                  }),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: (() {}),
                  focusColor: Colors.black38,
                  child: ListTile(
                    leading: Container(
                      decoration: BoxDecoration(
                        color: HexColor('#efefef'),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: _getCategoryIcon(
                            transaction.category, transaction.type),
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
                      Provider.of<AppState>(context, listen: false)
                          .parsedate(transaction.date),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.sp,
                      ),
                    ),
                    trailing: transaction.type == 'Expense'
                        ? SizedBox(
                            width: 34.w,
                            child: AutoSizeText(
                              "- ₹${transaction.amount}",
                              style: TextStyle(
                                fontSize: 15.sp,
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
                              "+ ₹${transaction.amount}",
                              style: TextStyle(
                                fontSize: 15.sp,
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

    return ListView(
      padding: EdgeInsets.only(top: 3),
      physics: const BouncingScrollPhysics(),
      children: widgets,
    );
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
                              turns: AlwaysStoppedAnimation(
                                  isSelected ? 1.0 : 0.0),
                              child: ScaleTransition(
                                scale: Tween<double>(
                                        begin: isSelected ? 1.2 : 1.0, end: 1.0)
                                    .animate(
                                  CurvedAnimation(
                                      parent: const AlwaysStoppedAnimation(0.0),
                                      curve: Curves.elasticOut),
                                ),
                                child: Text(
                                  item[index],
                                  style: TextStyle(
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: isSelected ? 16.sp : 12.sp,
                                    color:
                                        isSelected ? Colors.blue : Colors.grey,
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
          Expanded(
              child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24), topRight: Radius.circular(24)),
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
                              ? VisibleChart(tooltipBehavior: _tooltipBehavior)
                              : SizedBox(height: 2.h);
                }),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 4.h,
                          decoration: BoxDecoration(
                              color: Theme.of(context).hoverColor,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10))),
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
                                color: Colors.blueGrey,
                                onPressed: () {
                                  _showCustomDatePicker(context);
                                },
                              ),
                            ],
                          ),
                        ),
                        Consumer<AppState>(builder: (context, provider, child) {
                          return Container(
                              height: 4.h,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 215, 215, 214),
                              ),
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 15.0,
                                  ),
                                  child: provider.headinginnermethod()));
                        }),
                        Expanded(
                          child: Container(
                            color: const Color.fromARGB(255, 215, 215, 214),
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
                                      : _buildGroupedTransactionList(newlist);
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
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
