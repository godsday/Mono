import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_image_view.dart';
import '../../widgets/custom_text_button.dart';
import './provider/spending_dashboard_provider.dart';
import './widgets/transaction_item_widget.dart';

class SpendingDashboardScreen extends StatefulWidget {
  const SpendingDashboardScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return ChangeNotifierProvider<SpendingDashboardProvider>(
      create: (context) => SpendingDashboardProvider()..initialize(),
      child: const SpendingDashboardScreen(),
    );
  }

  @override
  State<SpendingDashboardScreen> createState() =>
      _SpendingDashboardScreenState();
}

class _SpendingDashboardScreenState extends State<SpendingDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SpendingDashboardProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // _buildHeader(),
                SingleChildScrollView(
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        _buildTabNavigation(provider),
                        // _buildChartSection(),
                        _buildTransactionListSection(provider),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      // bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF14B8A6), appTheme.colorFF0D94],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.h),
          bottomRight: Radius.circular(24.h),
        ),
      ),
      child: Stack(
        children: [
          CustomImageView(
            imagePath: ImageConstant.imgRectangle9,
            height: 80.h,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 0,
            right: 0,
            child: CustomImageView(
              imagePath: ImageConstant.imgGroup6,
              height: 80.h,
              width: 160.h,
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 30.h),
              child: Text(
                'My Spendings',
                style: TextStyleHelper.instance.title18SemiBold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabNavigation(SpendingDashboardProvider provider) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomTextButton(
          text: 'Expense',
          textColor: provider.selectedExpenseTab == 0
              ? appTheme.blackCustom
              : appTheme.colorFF6B72,
          fontSize: provider.selectedExpenseTab == 0 ? 6.sp : 4.sp,
          fontWeight: provider.selectedExpenseTab == 0
              ? FontWeight.w500
              : FontWeight.w400,
          onPressed: () => provider.selectExpenseTab(0),
        ),
        SizedBox(width: 2.h),
        CustomTextButton(
          text: 'All',
          textColor: provider.selectedExpenseTab == 1
              ? appTheme.blackCustom
              : appTheme.colorFF6B72,
          fontSize: provider.selectedExpenseTab == 1 ? 6.sp : 4.sp,
          fontWeight: provider.selectedExpenseTab == 1
              ? FontWeight.w500
              : FontWeight.w400,
          onPressed: () => provider.selectExpenseTab(1),
        ),
        SizedBox(width: 2.h),
        CustomTextButton(
          text: 'Income',
          textColor: provider.selectedExpenseTab == 2
              ? appTheme.blackCustom
              : appTheme.colorFF6B72,
          fontSize: provider.selectedExpenseTab == 2 ? 6.sp : 4.sp,
          fontWeight: provider.selectedExpenseTab == 2
              ? FontWeight.w500
              : FontWeight.w400,
          onPressed: () => provider.selectExpenseTab(2),
        ),
      ],
    );
  }

  Widget _buildChartSection() {
    return Container(
      color: appTheme.colorFFDCF0,
      padding: EdgeInsets.symmetric(horizontal: 6.h, vertical: 4.h),
      child: Column(
        children: [
          Container(
            height: 20.h,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomImageView(
                  imagePath: ImageConstant.imgGroup3,
                  height: 92.h,
                  width: 92.h,
                ),
                Positioned(
                  top: 4.h,
                  left: 8.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Transport', style: TextStyleHelper.instance.body12),
                      Text('10%', style: TextStyleHelper.instance.body12),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 64.h,
                  left: 32.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Restaurant',
                        style: TextStyleHelper.instance.body12,
                      ),
                      Text('40%', style: TextStyleHelper.instance.body12),
                    ],
                  ),
                ),
                Positioned(
                  top: 80.h,
                  right: 32.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Shopping', style: TextStyleHelper.instance.body12),
                      Text('50%', style: TextStyleHelper.instance.body12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionListSection(SpendingDashboardProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: appTheme.colorFFF3F4,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4.h),
          topRight: Radius.circular(4.h),
        ),
      ),
      padding: EdgeInsets.all(3.h),
      child: Column(
        children: [
          _buildTimePeriodSelector(provider),
          SizedBox(height: 1.h),
          _buildSpendingHeader(),
          SizedBox(height: 1.h),
          _buildTodaySection(provider),
          SizedBox(height: 4.h),
          _buildYesterdaySection(provider),
          SizedBox(height: 14.h),
          _buildMay13Section(provider),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildTimePeriodSelector(SpendingDashboardProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: appTheme.whiteCustom,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(2.h),
          topRight: Radius.circular(2.h),
        ),
      ),
      padding: EdgeInsets.all(2.h),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomTextButton(
            text: 'Today',
            textColor: provider.selectedTimePeriod == 0
                ? appTheme.blackCustom
                : appTheme.colorFF6B72,
            fontSize: provider.selectedTimePeriod == 0 ? 6.sp : 4.sp,
            fontWeight: provider.selectedTimePeriod == 0
                ? FontWeight.w500
                : FontWeight.w400,
            onPressed: () => provider.selectTimePeriod(0),
          ),
          CustomTextButton(
            text: 'weeky',
            textColor: provider.selectedTimePeriod == 1
                ? appTheme.blackCustom
                : appTheme.colorFF6B72,
            fontSize: provider.selectedTimePeriod == 1 ? 6.sp : 4.sp,
            fontWeight: provider.selectedTimePeriod == 1
                ? FontWeight.w500
                : FontWeight.w400,
            onPressed: () => provider.selectTimePeriod(1),
          ),
          CustomTextButton(
            text: 'Monthy',
            textColor: provider.selectedTimePeriod == 2
                ? appTheme.blackCustom
                : appTheme.colorFF6B72,
            fontSize: provider.selectedTimePeriod == 2 ? 16.sp : 14.sp,
            fontWeight: provider.selectedTimePeriod == 2
                ? FontWeight.w500
                : FontWeight.w400,
            onPressed: () => provider.selectTimePeriod(2),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgIconCalendar,
            height: 2.h,
            width: 2.h,
          ),
        ],
      ),
    );
  }

  Widget _buildSpendingHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Spending',
          style: TextStyleHelper.instance.title18SemiBold.copyWith(
            color: appTheme.colorFF1F29,
          ),
        ),
        Text(
          '₹1000.0',
          style: TextStyleHelper.instance.title18SemiBold.copyWith(
            color: appTheme.blackCustom,
          ),
        ),
      ],
    );
  }

  Widget _buildTodaySection(SpendingDashboardProvider provider) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Today', style: TextStyleHelper.instance.body14Medium),
            Text('May 16, 2025', style: TextStyleHelper.instance.body12),
          ],
        ),
        // SizedBox(height: 1.h),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: provider.todayTransactions.length,
          separatorBuilder: (context, index) => SizedBox(height: 2.h),
          itemBuilder: (context, index) {
            return TransactionItemWidget(
              transaction: provider.todayTransactions[index],
            );
          },
        ),
      ],
    );
  }

  Widget _buildYesterdaySection(SpendingDashboardProvider provider) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Yesterday', style: TextStyleHelper.instance.body14Medium),
            Text('May 14, 2025', style: TextStyleHelper.instance.body12),
          ],
        ),
        SizedBox(height: 12.h),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: provider.yesterdayTransactions.length,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            return TransactionItemWidget(
              transaction: provider.yesterdayTransactions[index],
            );
          },
        ),
      ],
    );
  }

  Widget _buildMay13Section(SpendingDashboardProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('May 13, 2025', style: TextStyleHelper.instance.body14Medium),
        SizedBox(height: 12.h),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: provider.may13Transactions.length,
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            return TransactionItemWidget(
              transaction: provider.may13Transactions[index],
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
      decoration: BoxDecoration(
        color: appTheme.whiteCustom,
        border: Border(
          top: BorderSide(color: appTheme.colorFFE5E7, width: 1.h),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgIconlyLightOutlineCategory,
                height: 5.h,
                width: 10.h,
              ),
              SizedBox(height: 1.h),
              Text(
                'Home',
                style: TextStyleHelper.instance.body14Medium.copyWith(
                  color: appTheme.colorFF3741,
                ),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgIconlyLightOutlineSwap,
                height: 32.h,
                width: 32.h,
              ),
              SizedBox(height: 4.h),
              Text(
                'Transactions',
                style: TextStyleHelper.instance.title16SemiBold,
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomImageView(
                imagePath: ImageConstant.imgSetting,
                height: 24.h,
                width: 32.h,
              ),
              SizedBox(height: 4.h),
              Text('Settings', style: TextStyleHelper.instance.body14SemiBold),
            ],
          ),
        ],
      ),
    );
  }
}
