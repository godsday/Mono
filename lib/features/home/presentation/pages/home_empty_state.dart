import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mono/core/constants/app_textstyle/app_textstyle.dart';
import 'package:mono/core/constants/colors/app_colors.dart';
import 'package:mono/core/theme/app_theme.dart';
import 'package:mono/core/widgets/app_button_decoration.dart';
import 'package:mono/core/utils/extension/context_extension.dart';

import 'package:mono/routes/route_names.dart';
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Illustration with glow effect and animation
          SizedBox(height: 2.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0),
            child: FadeTransition(
              opacity: _illustrationAnimation,
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(12),
                  color: const Color.fromARGB(
                      255, 252, 246, 188), // 25% opacity glow
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 248, 238, 162),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/images/piggybank.png',
                  width: 40.w,
                  height: 80.w,
                ),
              ),
            ),
          ),
          // const SizedBox(height: 24),

          // Title with gradient text and animation
          FadeTransition(
            opacity: _textAnimation,
            child: ShaderMask(
              shaderCallback: (bounds) {
                return Theme.of(context)
                    .extension<AppGradients>()!
                    .cardGradient
                    .createShader(bounds);
              },
              child: Text(
                context.l10n.home_empty_state_title,
                style: AppTextStyles.roboto16w600Black.copyWith(
                  fontSize: 19.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors
                      .white, // This color will be ignored due to ShaderMask
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Subtitle with animation
          FadeTransition(
            opacity: _textAnimation,
            child: SizedBox(
              width: 80.w,
              child: Text(
                context.l10n.home_empty_state_subtitle,
                style: AppTextStyles.poppins15w400(context)!.copyWith(
                  fontWeight: FontWeight.normal,
                  fontSize: 15.sp,
                  color: Colors.black54, // 70% opacity
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
          ),
          const SizedBox(height: 32),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color.fromARGB(255, 41, 41, 41),
                  border: Border.all(
                      color: const Color.fromARGB(255, 151, 151, 151))),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    VerifiedMessage(
                        context: context,
                        message: context.l10n.home_empty_verified_info),
                    const SizedBox(height: 10),
                    VerifiedMessage(
                        context: context,
                        message: context.l10n.home_empty_privacy_info1),
                    const SizedBox(
                      height: 10,
                    ),
                    VerifiedMessage(
                        context: context,
                        message: context.l10n.home_empty_privacy_info2),
                    const SizedBox(
                      height: 10,
                    ),
                    VerifiedMessage(
                        context: context,
                        message: context.l10n.home_empty_privacy_info3),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Primary Button with animation
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FadeTransition(
              opacity: _buttonAnimation,
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: AppElevetedButton(
                  appButtonText: context.l10n.add_first_expense,
                  onPressed: () {
                    Navigator.pushNamed(context, RouteNames.addTransaction);
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),

          // Footer text

          SizedBox(height: 2.h),

          Text(
            context.l10n.home_empty_info_text,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black26, // 40% opacity
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 2.h),

          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColor.greenContainer.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColor.greenContainer.withValues(alpha: 0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Text(
              context.l10n.home_empty_state_footer,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black26, // 40% opacity
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class VerifiedMessage extends StatelessWidget {
  const VerifiedMessage({
    super.key,
    required this.context,
    required this.message,
  });

  final BuildContext context;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Icon(Icons.check_circle_outline, color: Colors.green[400])),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            message,
            maxLines: 2,
            overflow: TextOverflow.visible,
            softWrap: true,
            style: AppTextStyles.poppins16w400.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: const Color.fromARGB(255, 255, 255,
                  255), // This color will be ignored due to ShaderMask
            ),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}
