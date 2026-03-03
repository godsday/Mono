import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AppColor {
  static Color mainHexcolor = HexColor("#429690");
  static Color accentHexColor = HexColor('#9FD1CC');
  static Color blueContainer = HexColor('#DCF1F5');
  static Color greenContainer = HexColor('#D9E7E5');
  static Color redContainer = HexColor('#E6E2E6');
  static Color textGrey = HexColor('525252');
  static Color textSecondary = HexColor('666666');
  static Color textPrimary = HexColor('000000');
  static Color white = Colors.white;
  static Color shadowColor = const Color.fromARGB(255, 241, 234, 234);
  static Color grey600 = Colors.grey.shade600;
  static Color grey500 = Colors.grey.shade500;
  static Color grey700 = Colors.grey.shade700;
  static Color blueGrey700 = Colors.blueGrey.shade700;
  static Color grey = Colors.grey;
  static Color greenText = HexColor("#438883");
  static Color darkGreyText = HexColor("#5C5A5A");
  static Color blackText = HexColor("#222222");
  static Color expenseRed = Colors.red;
  static Color incomeGreen = Colors.green;
  static Color transparent = Colors.transparent;
  static Color totalBalanceCardBg = HexColor("#37474F");
  static Color lightGrey = Colors.grey.shade200;

  static LinearGradient mainGradient = const LinearGradient(
    colors: [Color(0xFF429690), Color(0xFF1E4744)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
