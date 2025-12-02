import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mono/constants/colors/app_color.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      primaryColor:
          isDarkTheme ? const Color.fromARGB(255, 20, 20, 20) : Colors.white,
      scaffoldBackgroundColor:
          isDarkTheme ? const Color.fromARGB(255, 24, 23, 28) : Colors.white,

// //const Color.fromARGB(255, 20, 20, 20)
      dividerColor: isDarkTheme
          ? const Color.fromARGB(255, 39, 33, 40)
          : HexColor("#429690"),
      cardColor: isDarkTheme
          ? const Color.fromARGB(255, 70, 67, 70)
          : Colors.white, //clip container
//clip container
      indicatorColor: isDarkTheme
          ? const Color.fromARGB(66, 63, 68, 78)
          : HexColor('#D9E7E5'), //income container

      hoverColor: isDarkTheme
          ? const Color.fromARGB(235, 45, 41, 48)
          : HexColor('#E6E2E6'), //expense
      //highlightColor: isDarkTheme ? const Color(0xff372901) : const Color(0xffFCE192),

      focusColor: isDarkTheme
          ? const Color.fromARGB(255, 253, 253, 250)
          : Colors.blueGrey.shade700, //calender text income expense

      dialogBackgroundColor:
          isDarkTheme ? const Color.fromARGB(234, 102, 82, 110) : Colors.white,
      // ignore: deprecated_member_use
      // errorColor: isDarkTheme

      primaryColorLight: isDarkTheme
          ? const Color.fromARGB(255, 74, 73, 71)
          : HexColor("#429690"),
      // disabledColor: Colors.grey,
      //  textSelectionColor: isDarkTheme ? Colors.white : Colors.black,
      canvasColor: isDarkTheme
          ? const Color.fromARGB(255, 110, 109, 109)
          : Colors.grey[50],
      primaryColorDark: isDarkTheme
          ? const Color.fromARGB(225, 61, 46, 75)
          : HexColor("#429690"),
      // ignore: deprecated_member_use
      shadowColor: isDarkTheme ? Colors.blueGrey : AppColor.accentHexColor,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme
              ? const ColorScheme.dark()
              : const ColorScheme.light()),
      appBarTheme: const AppBarTheme(
        elevation: 0.0,
      ),
    );
  }
}
