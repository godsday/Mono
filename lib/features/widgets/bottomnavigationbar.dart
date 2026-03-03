import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors/app_colors.dart';
// import 'package:mono/screens/home_screen/home_screen.dart'; // Deprecated
import 'package:mono/features/home/presentation/pages/home_page.dart';
import 'package:mono/features/financial_overview/financial_overview_page.dart';
import 'package:mono/features/setting_screen/settings_screen.dart';
import 'package:mono/features/transaction/presentation/transcation_screen/transcation_screen.dart';

class BottomNavigator extends StatefulWidget {
  final int index;
  const BottomNavigator({super.key, required this.index});

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  int? _selectedIndex;
  List pages = [
    // const ProfileScreen(),
    const TranscationScreen(),
    const HomePage(),
    const FinancialOverviewPage(),
    const SettingsScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex ?? widget.index],
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: TextStyle(
            color: AppColor.mainHexcolor, fontWeight: FontWeight.w700),
        items: const [
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.person_2_rounded), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "More"),
          BottomNavigationBarItem(
              icon: Icon(Icons.auto_awesome_mosaic_outlined), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined), label: "Finance"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
        backgroundColor: Theme.of(context).primaryColor,
        iconSize: 30,
        showUnselectedLabels: false,
        showSelectedLabels: true,
        currentIndex: _selectedIndex ?? widget.index,
        selectedItemColor: AppColor.mainHexcolor,
        unselectedItemColor: Colors.black45,
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
