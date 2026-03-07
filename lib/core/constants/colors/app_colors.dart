import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AppColor {
  static Color mainHexcolor = HexColor("#429690");
  static Color secondaryDarkHexcolor = HexColor("#DCDCFF");
  static Color mainDarkHexcolor = HexColor("#210B35");
  static Color bottomNavBlack45 = Colors.black45;
  static Color bottomNavDarkThemeColor = const Color(0xDF3D2E4B);
  static Color totalBalanceCardBg = HexColor("#37474F");

  static Color totalBalanceCardBgDark = HexColor("#010C10");
  static Color incomeHeaderDark = HexColor("#2B2C3B");
  static Color expenseHeaderDark = HexColor("#280101");
  static Color expenseContainerDark = HexColor("#693737");

  static Color transactionListBgLight = HexColor("#EEEEEE");

  //Financial Hub
  static Color goalCardFirstBg = HexColor('#EFF7F9');
  static Color budgetCardFirstBg = HexColor('#EBEEFF');
  static Color assetCardFirstbg = HexColor('#E6F5F4');

  static Color borderGreyWhite = Colors.white30;

  //Text COLOR
  static Color lightGrey = Colors.grey.shade200;
  static Color textGrey = HexColor('525252');
  static Color blackText = HexColor("#222222");

  static Color accentHexColor = HexColor('#9FD1CC');
  static Color blueContainer = HexColor('#DCF1F5');
  static Color greenContainer = HexColor('#D9E7E5');
  static Color redContainer = HexColor('#E6E2E6');

  static Color textSecondary = HexColor('666666');

  static Color whiteColor = Colors.white;
  static Color shadowColor = const Color.fromARGB(255, 241, 234, 234);
  static Color grey600 = Colors.grey.shade600;
  static Color grey500 = Colors.grey.shade500;
  static Color grey700 = Colors.grey.shade700;
  static Color blueGrey700 = Colors.blueGrey.shade700;
  static Color grey = Colors.grey;
  static Color greenText = HexColor("#438883");
  static Color darkGreyText = HexColor("#5C5A5A");

  static Color expenseRed = Colors.red;
  static Color incomeGreen = Colors.green;
  static Color transparent = Colors.transparent;

  static Color blackColor = Colors.black;

  static LinearGradient mainGradient = const LinearGradient(
    colors: [Color(0xFF429690), Color(0xFF1E4744)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient darkThemeGradient = const LinearGradient(
    colors: [Color(0xFF3D2E4B), Color(0xFF210B35)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static LinearGradient textDarkThemeGradient = const LinearGradient(
    colors: [Color.fromARGB(255, 200, 141, 101), Color(0xFFDCDCFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient goalCardGradient = LinearGradient(
    colors: [
      HexColor('#B2AFE8').withValues(alpha: 0.9),
      HexColor('#D3D0F7'),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static LinearGradient assetCardGradient = LinearGradient(
    colors: [
      HexColor('#E6F5F4'),
      HexColor('#F0FDFB'),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
