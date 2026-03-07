import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors/app_colors.dart';
import 'package:mono/core/theme/app_texttheme.dart';
import 'package:mono/core/theme/app_theme.dart';
import 'package:mono/routes/route_names.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  double _fontSize = 2;
  double _textOpacity = 0.0;
  double _containerOpacity = 0.0;

  late AnimationController _controller;
  late Animation<double> animation1;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    animation1 = Tween<double>(begin: 40, end: 20).animate(
      CurvedAnimation(
          parent: _controller, curve: Curves.fastLinearToSlowEaseIn),
    )..addListener(() {
        setState(() {
          _textOpacity = 1.0;
        });
      });

    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      startSplash();
    });
  }

  Future<void> startSplash() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _fontSize = 1.1);

    await Future.delayed(const Duration(seconds: 1));
    setState(() => _containerOpacity = 1.0);

    await Future.delayed(const Duration(seconds: 2));
    await checkdata();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            gradient:
                Theme.of(context).extension<AppGradients>()?.primaryGradient),
        child: Stack(
          children: [
            Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 2000),
                  curve: Curves.fastLinearToSlowEaseIn,
                  height: height / _fontSize,
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 2000),
                  opacity: _textOpacity,
                  child: Text(
                    'mono',
                    style: AppTextTheme.inter.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 28.sp,
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 5000),
                curve: Curves.fastLinearToSlowEaseIn,
                opacity: _containerOpacity,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.fastLinearToSlowEaseIn,
                  height: 15.h,
                  width: 15.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Image.asset('assets/images/OrginalIcon.png'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> checkdata() async {
    final sharedprefer = await SharedPreferences.getInstance();
    final nameIsThere = sharedprefer.getString('namekey');

    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      nameIsThere == null ? RouteNames.onboarding : RouteNames.home,
    );
  }
}
