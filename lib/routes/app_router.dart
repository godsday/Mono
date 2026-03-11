import 'package:flutter/material.dart';
import 'package:mono/features/app_settings/presentation/pages/support_screen.dart';
import 'package:mono/features/financial_overview/analytics/presentation/pages/analytics_screen.dart';
import 'package:mono/features/financial_overview/budget/domain/entities/budget_entity.dart';
import 'package:mono/features/financial_overview/budget/presentation/pages/add_budget_screen.dart';
import 'package:mono/features/app_settings/presentation/pages/about_screen.dart';
import 'package:mono/features/financial_overview/financial_overview_page.dart';
import 'package:mono/features/home/presentation/pages/home_page.dart';
import 'package:mono/features/transaction/data/models/transcation_model.dart';
import 'package:mono/features/transaction/presentation/transcation_screen/transcation_screen.dart';
import '../features/IntroPages/splash_screen.dart';
import '../features/widgets/bottomnavigationbar.dart';
import '../features/add_screen/presentation/add_screen.dart';
import '../features/app_settings/presentation/pages/settings_screen.dart';
import '../features/IntroPages/onbording_screen.dart';
import 'route_names.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );

      case RouteNames.home:
        return _buildPageRoute(const HomePage(), settings);

      case RouteNames.onboarding:
        return MaterialPageRoute(builder: (_) => OnboardScreen());

      case RouteNames.addTransaction:
        final args = settings.arguments;
        final transaction = args is TranscationModel ? args : null;
        return _buildPageRoute(
          AddScreen(
            isDataExist: transaction,
          ),
          settings,
        );

      case RouteNames.settings:
        return _buildPageRoute(const SettingsScreen(), settings);

      case RouteNames.budgetOverview:
        return _buildPageRoute(const FinancialOverviewPage(), settings);

      case RouteNames.addBudget:
        final args = settings.arguments;
        final budget = args is BudgetEntity ? args : null;
        return _buildPageRoute(
            AddBudgetScreen(
              budget: budget,
            ),
            settings);

      case RouteNames.transactionList:
        return _buildPageRoute(const TranscationScreen(), settings);
      case RouteNames.analytics:
        return _buildPageRoute(const AnalyticsScreen(), settings);

      case RouteNames.about:
        return _buildPageRoute(const AboutScreen(), settings);

      case RouteNames.support:
        return _buildPageRoute(const SupportScreen(), settings);

      case RouteNames.bottomNav:
        return _buildPageRoute(
            const BottomNavigator(
              index: 1,
            ),
            settings);

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }

  static PageRouteBuilder _buildPageRoute(Widget page, RouteSettings settings,
      {bool isVertical = false, bool isFade = true}) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin =
            isVertical ? const Offset(0.0, 1.0) : const Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return isFade
            ? FadeTransition(
                opacity: animation,
                child: page,
              )
            : SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
