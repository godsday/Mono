import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/hex_color.dart';
import '../../../../../core/constants/colors/app_colors.dart';
import '../../../../../core/theme/app_texttheme.dart';
import '../../../widgets/safe_background_image.dart';
import '../pages/add_goal_screen.dart';

class FirstTimeGoalCard extends StatelessWidget {
  const FirstTimeGoalCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: HexColor('#EBF5FF'),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: LinearGradient(
          colors: [
            HexColor('#EBF5FF'),
            HexColor('#F5FAFF'),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Background Illustration (Right side)
          Positioned(
            right: 0,
            bottom: 20,
            top: 20,
            width: 150,
            child: Opacity(
              opacity: 0.8,
              child: SafeBackgroundImage(
                imagePath: 'assets/images/boat.svg',
                fit: BoxFit.contain,
                fallback: Icon(Icons.kayaking,
                    size: 80, color: Colors.grey.withValues(alpha: 0.2)),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "What You're Working For",
                  style: AppTextTheme.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColor.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 200,
                  child: Text(
                    'Turn your dreams into achievable goals',
                    style: AppTextTheme.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColor.textGrey,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddGoalScreen()),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: HexColor('#3C7570'), // Dark teal
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    HexColor('#3C7570').withValues(alpha: 0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ]),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
                        child: Text(
                          'Start Dreaming',
                          style: AppTextTheme.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
