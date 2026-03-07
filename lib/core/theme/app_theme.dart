import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors/app_colors.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDarkTheme ? AppColor.blackColor : Colors.white,
        selectedItemColor: Theme.of(context).primaryColor,
      ),
      extensions: [
        AppGradients(
          assetCardTheme:
              isDarkTheme ? AppColor.blackColor : AppColor.assetCardFirstbg,
          goalCardTheme:
              isDarkTheme ? AppColor.blackColor : AppColor.goalCardFirstBg,
          // assetCardGradient: isDarkTheme ? AppColor.blackColor : AppColor.assetCardGradient,
          budgetCardTheme:
              isDarkTheme ? AppColor.blackColor : AppColor.budgetCardFirstBg,
          // goalCardGradient: isDarkTheme ? AppColor.blackColor : AppColor.,
          //text theme blue header
          textThemeBlueHeader:
              isDarkTheme ? AppColor.whiteColor : const Color(0xFF21435D),
          textTheme: isDarkTheme ? AppColor.whiteColor : AppColor.blackText,
          //L - shape card
          incomeHeader:
              isDarkTheme ? AppColor.incomeHeaderDark : const Color(0xFFF7F6F6),
          expenseHeader: isDarkTheme
              ? AppColor.expenseHeaderDark
              : const Color(0xFFF7F6F6),

          // home screen - transcation card- income and expense container
          incomeContainer:
              isDarkTheme ? AppColor.blackColor : AppColor.mainHexcolor,
          expenseContainer:
              isDarkTheme ? AppColor.blackColor : AppColor.expenseContainerDark,
          // grey container
          transactionListBg: isDarkTheme
              ? AppColor.blackColor
              : AppColor.transactionListBgLight,
          // main gradient for app

          primaryGradient:
              isDarkTheme ? AppColor.darkThemeGradient : AppColor.mainGradient,

          // gradient for text

          cardGradient: isDarkTheme
              ? AppColor.textDarkThemeGradient
              : AppColor.mainGradient,
        ),
      ],
// main hex color vs light dark of the app
      primaryColor:
          isDarkTheme ? AppColor.secondaryDarkHexcolor : AppColor.mainHexcolor,

// background color of the app
      scaffoldBackgroundColor: isDarkTheme ? AppColor.blackColor : Colors.white,

      // main hex color vs main dark of the app
      secondaryHeaderColor:
          isDarkTheme ? AppColor.mainDarkHexcolor : AppColor.mainHexcolor,

// bottom nav bar bg color
      canvasColor: isDarkTheme ? AppColor.blackColor : Colors.grey[50],

// bottom nav bar item color
      primaryColorDark: isDarkTheme
          ? AppColor.bottomNavDarkThemeColor
          : AppColor.bottomNavBlack45,

// total balance card bg color
      cardColor: isDarkTheme
          ? AppColor.totalBalanceCardBgDark
          : AppColor.totalBalanceCardBg,

      dividerColor: isDarkTheme
          ? AppColor.totalBalanceCardBgDark
          : AppColor.greenContainer, // income container

      hoverColor: isDarkTheme
          ? AppColor.totalBalanceCardBgDark
          : AppColor.redContainer, //expense container

      cardTheme: CardThemeData(
        color: isDarkTheme ? AppColor.blackColor : AppColor.whiteColor,
      ),
      primaryColorLight: isDarkTheme ? Colors.black54 : Colors.grey[200],

      //Text grey
      disabledColor: isDarkTheme ? AppColor.lightGrey : AppColor.textGrey,

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

class AppGradients extends ThemeExtension<AppGradients> {
  final LinearGradient primaryGradient;
  final LinearGradient cardGradient;
  final Color incomeHeader;
  final Color expenseHeader;
  final Color incomeContainer;
  final Color expenseContainer;
  final Color transactionListBg;
  final Color textTheme;
  final Color textThemeBlueHeader;

  final Color budgetCardTheme;
  final Color goalCardTheme;
  final Color assetCardTheme;
  // final LinearGradient goalCardGradient;
// final LinearGradient assetCardGradient;
  const AppGradients({
    required this.primaryGradient,
    required this.cardGradient,
    required this.incomeHeader, // Changed to required for consistency
    required this.expenseHeader,
    required this.incomeContainer,
    required this.expenseContainer,
    required this.transactionListBg,
    required this.textTheme,
    required this.textThemeBlueHeader,
    // required this.assetCardGradient,
    required this.budgetCardTheme,
    required this.goalCardTheme,
    required this.assetCardTheme,
    // required this.goalCardGradient,
  });

  @override
  AppGradients copyWith({
    LinearGradient? primaryGradient,
    LinearGradient? cardGradient,
    Color? incomeHeader,
    Color? expenseHeader,
    Color? incomeContainer,
    Color? expenseContainer,
    Color? transactionListBg,
    Color? textTheme,
    Color? textThemeBlueHeader,
    LinearGradient? assetCardGradient,
    Color? budgetCardTheme,
    Color? goalCardTheme,
    LinearGradient? goalCardGradient,
    Color? assetCardTheme,
  }) {
    return AppGradients(
      primaryGradient: primaryGradient ?? this.primaryGradient,
      cardGradient: cardGradient ?? this.cardGradient,
      incomeHeader: incomeHeader ?? this.incomeHeader,
      expenseHeader: expenseHeader ?? this.expenseHeader,
      incomeContainer: incomeContainer ?? this.incomeContainer,
      expenseContainer: expenseContainer ?? this.expenseContainer,
      transactionListBg: transactionListBg ?? this.transactionListBg,
      textTheme: textTheme ?? this.textTheme,
      textThemeBlueHeader: textThemeBlueHeader ?? this.textThemeBlueHeader,
      // assetCardGradient: assetCardGradient ?? this.assetCardGradient,
      budgetCardTheme: budgetCardTheme ?? this.budgetCardTheme,
      goalCardTheme: goalCardTheme ?? this.goalCardTheme,

      assetCardTheme: assetCardTheme ?? this.assetCardTheme,
      // goalCardGradient: goalCardGradient ?? this.goalCardGradient,
    );
  }

  @override
  AppGradients lerp(ThemeExtension<AppGradients>? other, double t) {
    if (other is! AppGradients) return this;

    return AppGradients(
      primaryGradient:
          LinearGradient.lerp(primaryGradient, other.primaryGradient, t)!,
      cardGradient: LinearGradient.lerp(cardGradient, other.cardGradient, t)!,
      incomeHeader: Color.lerp(incomeHeader, other.incomeHeader, t)!,
      expenseHeader: Color.lerp(expenseHeader, other.expenseHeader, t)!,
      incomeContainer: Color.lerp(incomeContainer, other.incomeContainer, t)!,
      expenseContainer:
          Color.lerp(expenseContainer, other.expenseContainer, t)!,
      transactionListBg:
          Color.lerp(transactionListBg, other.transactionListBg, t)!,
      textTheme: Color.lerp(textTheme, other.textTheme, t)!,
      textThemeBlueHeader:
          Color.lerp(textThemeBlueHeader, other.textThemeBlueHeader, t)!,
      // assetCardGradient:
      //     LinearGradient.lerp(assetCardGradient, other.assetCardGradient, t)!,
      budgetCardTheme: Color.lerp(budgetCardTheme, other.budgetCardTheme, t)!,
      goalCardTheme: Color.lerp(goalCardTheme, other.goalCardTheme, t)!,
      assetCardTheme: Color.lerp(assetCardTheme, other.assetCardTheme, t)!,
      // goalCardGradient:
      //     LinearGradient.lerp(goalCardGradient, other.goalCardGradient, t)!,
    );
  }
}
