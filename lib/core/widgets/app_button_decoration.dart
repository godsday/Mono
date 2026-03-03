import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors/app_colors.dart';
import 'package:mono/core/theme/app_texttheme.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class AppElevetedButton extends StatelessWidget {
  final String appButtonText;
  final double? width;
  final double? height;
  final VoidCallback onPressed;

  const AppElevetedButton(
      {super.key,
      required this.appButtonText,
      this.width,
      this.height,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero, // Important: remove default padding
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            end: Alignment.bottomRight,
            begin: Alignment.topLeft,
            colors: [
              HexColor('#429690'),
              HexColor('#1E4744').withValues(alpha: 0.8),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: HexColor('#3C7570').withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          width: width,
          height: height,
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Text(
              appButtonText,
              style: AppTextTheme.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColor.white,
              ),
            ),
          ),
          // Text(appButtonText, style: const TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
