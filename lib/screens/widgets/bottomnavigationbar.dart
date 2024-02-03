import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mono/constants/app_color.dart';
import 'package:mono/screens/home_screen/home_screen.dart';
import 'package:mono/screens/profile_screen/acheivements_screen.dart';
import 'package:mono/screens/setting_screen/settings_screen.dart';
import 'package:mono/screens/transcation_screen/transcation_screen.dart';

import '../profile_screen/pro_screen.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({Key? key}) : super(key: key);

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  int _selectedIndex = 1;
  List pages = [
    // const ProfileScreen(),
    const TranscationScreen(),
    const HomeScreen(),
    const AcheivemntsScreen(),
    // const SettingsScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.person_2_rounded), label: "Profile"),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.arrow_2_squarepath), label: "More"),
          BottomNavigationBarItem(
              icon: Icon(Icons.auto_awesome_mosaic_outlined), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.grading_outlined), label: "Acheviements"),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.settings), label: "Settings"),
        ],
        backgroundColor: Theme.of(context).primaryColor,
        iconSize: 30,
        showUnselectedLabels: false,
        showSelectedLabels: true,
        currentIndex: _selectedIndex,
        selectedItemColor: mainHexcolor,
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
