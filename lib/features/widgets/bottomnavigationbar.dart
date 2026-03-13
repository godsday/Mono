import 'package:flutter/material.dart';
import 'package:mono/core/theme/app_texttheme.dart';
import 'package:mono/features/home/presentation/pages/home_page.dart';
import 'package:mono/features/financial_overview/financial_overview_page.dart';
import 'package:mono/features/app_settings/presentation/pages/settings_screen.dart';
import 'package:mono/features/transaction/presentation/transaction_screen/transaction_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:mono/core/utils/extension/context_extension.dart';

class BottomNavigator extends StatefulWidget {
  final int index;
  const BottomNavigator({super.key, required this.index});

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  late int _selectedIndex;
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index;
  }

  final List<Widget> pages = const [
    TranscationScreen(),
    HomePage(),
    FinancialOverviewPage(),
    SettingsScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: IndexedStack(
        index: _selectedIndex,
        children: pages,
      )),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 1,
        selectedLabelStyle: AppTextTheme.poppins().copyWith(
            fontSize: 14.sp,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w700),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.history),
            label: context.l10n.transactions_title,
          ),
          BottomNavigationBarItem(
              icon: const Icon(Icons.auto_awesome_mosaic_outlined),
              label: context.l10n.home_title),
          BottomNavigationBarItem(
              icon: const Icon(Icons.bar_chart_outlined),
              label: context.l10n.budget_title),
          BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: context.l10n.settings_title),
        ],
        backgroundColor:
            Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        iconSize: 30,
        showUnselectedLabels: false,
        showSelectedLabels: true,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).primaryColorDark,
        onTap: _onitemtap,
      ),
    );
  }

  void _onitemtap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
