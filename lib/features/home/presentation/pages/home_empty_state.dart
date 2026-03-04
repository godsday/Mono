import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mono/core/constants/app_textstyle/app_textstyle.dart';
import 'package:mono/core/constants/colors/app_colors.dart';
import 'package:mono/core/widgets/app_button_decoration.dart';
import 'package:mono/features/add_screen/add_screen.dart';
import 'package:mono/core/widgets/navigator_animation.dart';
import 'package:sizer/sizer.dart';

class HomeEmptyState extends StatefulWidget {
  const HomeEmptyState({super.key});

  @override
  State<HomeEmptyState> createState() => _HomeEmptyStateState();
}

class _HomeEmptyStateState extends State<HomeEmptyState>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _illustrationAnimation;
  late Animation<double> _textAnimation;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Staggered animations
    _illustrationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _textAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 1.0, curve: Curves.easeOut),
      ),
    );

    _buttonAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 1.0, curve: Curves.easeOut),
      ),
    );

    // Start animation after frame
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration with glow effect and animation
          FadeTransition(
            opacity: _illustrationAnimation,
            child: Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(64, 138, 234, 226), // 25% opacity glow
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(64, 22, 162, 232),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/piggybank.png',
                    width: 40.w,
                    height: 80.w,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Title with gradient text and animation
          FadeTransition(
            opacity: _textAnimation,
            child: ShaderMask(
              shaderCallback: (bounds) {
                return const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 7, 70, 91),
                    Color.fromARGB(255, 45, 105, 113),
                  ],
                ).createShader(bounds);
              },
              child: Text(
                "Start Your Financial Journey",
                style: AppTextStyles.poppins16w400.copyWith(
                  fontSize: 19.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors
                      .white, // This color will be ignored due to ShaderMask
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Subtitle with animation
          FadeTransition(
            opacity: _textAnimation,
            child: SizedBox(
              width: 80.w,
              child: Text(
                "Add your first transaction to begin tracking your money.",
                style: AppTextStyles.poppins15w400(context)!.copyWith(
                  fontWeight: FontWeight.normal,
                  color: Colors.black54, // 70% opacity
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Primary Button with animation
          FadeTransition(
            opacity: _buttonAnimation,
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: AppElevetedButton(
                appButtonText: "Add Transaction",
                onPressed: () {
                  Navigator.push(
                    context,
                    CustomPageRoute(child: const AddScreen()),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 28),

          // Footer text
          const Text(
            "Your data is safely encrypted.",
            style: TextStyle(
              fontSize: 12,
              color: Colors.black26, // 40% opacity
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
