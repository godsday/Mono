import 'package:flutter/material.dart';
import '../screens/IntroPages/splash_screen.dart';
import '../screens/widgets/bottomnavigationbar.dart';
import '../screens/add_screen/add_screen.dart';
import '../screens/setting_screen/settings_screen.dart';
import '../screens/IntroPages/onbording_screen.dart';
import 'route_names.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case RouteNames.home:
        return _buildPageRoute(const BottomNavigator(index: 1), settings);

      case RouteNames.onboarding:
        return MaterialPageRoute(builder: (_) => OnboardScreen());

      case RouteNames.addTransaction:
        return _buildPageRoute(const AddScreen(), settings, isVertical: true);

      case RouteNames.settings:
        return _buildPageRoute(const SettingsScreen(), settings);

      case RouteNames.transactionList:
        return _buildPageRoute(
            const BottomNavigator(
              index: 0,
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
      {bool isVertical = false}) {
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

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
