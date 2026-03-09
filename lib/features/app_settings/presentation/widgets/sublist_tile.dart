import 'package:flutter/material.dart';
import 'package:mono/core/theme/app_texttheme.dart';
import 'package:mono/core/theme/app_theme.dart';
import 'package:sizer/sizer.dart';

class SubListTile extends StatelessWidget {
  const SubListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.context,
    this.isSettings = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final BuildContext context;
  final bool isSettings;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
          horizontal: isSettings ? 4.sp : 24, vertical: 0.0),
      leading: Icon(icon,
          color: Theme.of(context).extension<AppGradients>()!.textTheme,
          size: 20.sp),
      title: Text(
        title,
        style: AppTextTheme.poppins(
          fontSize: 16.sp,
          fontWeight: isSettings ? FontWeight.w600 : FontWeight.w500,
          color: Theme.of(context).extension<AppGradients>()!.textTheme,
        ),
      ),
      trailing: Icon(Icons.chevron_right,
          color: Theme.of(context).disabledColor, size: 21.sp),
      onTap: onTap,
    );
  }
}
