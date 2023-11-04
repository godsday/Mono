import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mono/constants/app_color.dart';
import 'package:mono/screens/home_screen/home_screen.dart';
import 'package:mono/screens/setting_screen/settings_screen.dart';
import 'package:mono/screens/transcation_screen/transcation_screen.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({Key? key}) : super(key: key);

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  int _selectedIndex = 1;
  List pages = [
    const TranscationScreen(),
    const HomeScreen(),
    const SettingsScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.arrow_2_squarepath), label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.auto_awesome_mosaic_outlined), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ""),
        ],
        backgroundColor: Theme.of(context).primaryColor,
        iconSize: 30,
        showUnselectedLabels: false,
        showSelectedLabels: true,
        currentIndex: _selectedIndex,
        selectedItemColor: mainHexcolor,
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
