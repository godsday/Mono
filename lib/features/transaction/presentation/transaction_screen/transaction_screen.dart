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
import 'package:mono/core/utils/extension/context_extension.dart';
import 'package:mono/features/transaction/presentation/transaction_screen/transaction_widgets/get_category_icon.dart';
import 'package:mono/features/transaction/presentation/transaction_screen/transaction_widgets/transaction_header.dart';
import 'package:mono/features/transaction/presentation/transaction_screen/transaction_widgets/heading_widget.dart';
import 'package:mono/core/widgets/snackbar.dart';
import 'package:mono/routes/route_names.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'transaction_widgets/graph_widget.dart';
import 'package:sizer/sizer.dart';

class TranscationScreen extends StatefulWidget {
  const TranscationScreen({super.key});

  @override
  State<TranscationScreen> createState() => _TranscationScreenState();
}

class _TranscationScreenState extends State<TranscationScreen> {
  @override
  void initState() {
    context.read<TransactionProvider>().refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('TranscationScreen is called');
    return const Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(100), child: TranscationHeader()),
      body: SafeArea(
        child: Column(
          children: [
            _GraphToggleSection(),
            _ChartSection(),
            _CategoryFilterSection(),
            Expanded(
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _TimeFilterSection(),
                  _HeadingSection(),
                  _TransactionListSection(),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class _GraphToggleSection extends StatelessWidget {
  const _GraphToggleSection();

  @override
  Widget build(BuildContext context) {
    final isVisible =
        context.select<TransactionProvider, bool>((p) => p.visible);
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () => context.read<TransactionProvider>().graphView(),
            child: Container(
              decoration: BoxDecoration(
                color: isVisible ? AppColor.blueContainer : Colors.amberAccent,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  isVisible
                      ? context.l10n.hide_button
                      : context.l10n.show_button,
                  style: AppTextStyles.poppins16w400.copyWith(
                    fontSize: 13,
                    color: AppColor.blackColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartSection extends StatelessWidget {
  const _ChartSection();

  @override
  Widget build(BuildContext context) {
    final isVisible =
        context.select<TransactionProvider, bool>((p) => p.visible);
    final itemValue =
        context.select<TransactionProvider, String>((p) => p.itemvalue);

    return AnimatedCrossFade(
      firstCurve: Curves.easeOut,
      crossFadeState:
          isVisible ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      sizeCurve: Curves.easeIn,
      duration: const Duration(milliseconds: 700),
      firstChild:
          itemValue == "All" || itemValue == "Income" || itemValue == "Expense"
              ? const _VisibleChartWrapper()
              : SizedBox(height: 2.h),
      secondChild: const SizedBox.shrink(),
    );
  }
}

class _VisibleChartWrapper extends StatefulWidget {
  const _VisibleChartWrapper();

  @override
  State<_VisibleChartWrapper> createState() => _VisibleChartWrapperState();
}

class _VisibleChartWrapperState extends State<_VisibleChartWrapper> {
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .3,
      width: MediaQuery.of(context).size.width,
      child: GraphWidget(tooltipBehavior: _tooltipBehavior),
    );
  }
}

class _CategoryFilterSection extends StatefulWidget {
  const _CategoryFilterSection();

  @override
  State<_CategoryFilterSection> createState() => _CategoryFilterSectionState();
}

class _CategoryFilterSectionState extends State<_CategoryFilterSection> {
  final ScrollController _scrollController = ScrollController();
  final List<String> items = ['Income', 'All', 'Expense'];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedItem =
        context.select<TransactionProvider, String>((p) => p.itemvalue);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: SizedBox(
        width: double.infinity,
        height: 40,
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          itemBuilder: (context, index) {
            final filter = items[index];
            final isSelected = selectedItem == filter;

            if (isSelected) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_scrollController.hasClients) {
                  double screenWidth = MediaQuery.of(context).size.width;
                  double itemWidth = 100.0;
                  double scrollTo =
                      index * itemWidth - (screenWidth / 2) + (itemWidth / 2);
                  _scrollController.animateTo(
                    scrollTo.clamp(
                        0.0, _scrollController.position.maxScrollExtent),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.elasticOut,
                  );
                }
              });
            }

            return _CategoryItem(
              filter: filter,
              isSelected: isSelected,
              onTap: () =>
                  context.read<TransactionProvider>().itemvalue = filter,
            );
          },
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final String filter;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.filter,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          alignment: Alignment.center,
          child: Text(
            _getTranslatedName(context, filter),
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: isSelected ? 17.sp : 14.sp,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : AppColor.textGrey,
            ),
          ),
        ),
      ),
    );
  }

  String _getTranslatedName(BuildContext context, String filter) {
    switch (filter) {
      case 'Income':
        return context.l10n.transaction_type_income;
      case 'Expense':
        return context.l10n.transaction_type_expense;
      case 'All':
        return context.l10n.filter_all;
      default:
        return filter;
    }
  }
}

class _TimeFilterSection extends StatelessWidget {
  const _TimeFilterSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4.h,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
            blurRadius: 4,
            offset: const Offset(0, 0),
          ),
        ],
        color: Theme.of(context).extension<AppGradients>()!.transactionListBg,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildFilterChip(context.l10n.filter_today, context),
          _buildFilterChip(context.l10n.filter_weekly, context),
          _buildFilterChip(context.l10n.filter_monthly, context),
          IconButton(
            icon: Icon(Icons.calendar_month_outlined, size: 15.sp),
            color: AppColor.textGrey,
            onPressed: () => _showCustomDatePicker(context),
          ),
        ],
      ),
    );
  }
}

class _HeadingSection extends StatelessWidget {
  const _HeadingSection();

  @override
  Widget build(BuildContext context) {
    final headingData =
        context.select<TransactionProvider, ({String title, double amount})>(
      (p) => p.getHeadingData(),
    );

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
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: HeadingMethod(
          headtext: headingData.title,
          amount: headingData.amount,
        ),
      ),
    );
  }
}

class _TransactionListSection extends StatelessWidget {
  const _TransactionListSection();

  @override
  Widget build(BuildContext context) {
    // Select the specific notifier based on the current filter
    final notifier = context
        .select<TransactionProvider, ValueNotifier<List<TranscationModel>>>(
      (p) => p.listingMethod(),
    );
    final provider = context.read<TransactionProvider>();

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).extension<AppGradients>()!.transactionListBg,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade500,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ValueListenableBuilder<List<TranscationModel>>(
          valueListenable: notifier,
          builder: (context, newList, _) {
            if (newList.isEmpty) {
              return Stack(children: [
                Lottie.asset('assets/images/animation/paymentshero1.json'),
              ]);
            }
            return _buildGroupedTransactionList(
                provider.groupedTransactions, context);
          },
        ),
      ),
    );
  }
}

Widget _buildFilterChip(String displayTitle, BuildContext context) {
  return Selector<TransactionProvider, String>(
    selector: (context, provider) => provider.itemvalue,
    builder: (context, itemvalue, child) {
      final isSelected = itemvalue == displayTitle;
      return GestureDetector(
        onTap: () {
          final provider = context.read<TransactionProvider>();
          provider.itemvalue = displayTitle;
          // Refresh the data when filter changes
          provider.refresh();
        },
        child: Text(
          displayTitle,
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
                label: context.l10n.action_edit,
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
                label: context.l10n.action_delete,
                onPressed: ((context) {
                  context
                      .read<TransactionProvider>()
                      .deleteTransaction(transaction.id);
                  final snack = customSnack(context,
                      message: context.l10n.message_deleted);
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
                        category: transaction.category, type: transaction.type),
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
                  context
                      .read<TransactionProvider>()
                      .parsedate(transaction.date),
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                ),
                trailing: SizedBox(
                  width: 35.w,
                  child: AutoSizeText(
                    "${transaction.type == 'Expense' ? '- ' : '+ '}${context.formatCurrency(transaction.amount)}",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: transaction.type == 'Expense'
                          ? FontWeight.w600
                          : FontWeight.bold,
                      color: transaction.type == 'Expense'
                          ? Colors.red
                          : Colors.green,
                    ),
                    maxLines: 1,
                    textAlign: TextAlign.end,
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
    final provider = context.read<TransactionProvider>();
    provider.itemvalue = 'Custom';
    provider.custompick(dateRange.start, dateRange.end);
    provider.refresh();
  }
}
