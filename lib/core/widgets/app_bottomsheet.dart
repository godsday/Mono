import 'package:flutter/material.dart';
import 'package:mono/core/constants/app_textstyle/app_textstyle.dart';
import 'package:mono/core/constants/colors/app_colors.dart';
import 'package:mono/core/storage/backup/backup_service.dart';
import 'package:sizer/sizer.dart';

void showAppBottomSheet({
  required BuildContext context,
}) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        height: 190,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () async {
                await BackupService.instance.exportData();
                if (!context.mounted) return;
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.outbond, size: 45, color: AppColor.incomeGreen),
                  const SizedBox(height: 10),
                  Text(
                    "Export",
                    style: AppTextStyles.poppins16w600.copyWith(
                      color: AppColor.textGrey,
                      fontSize: 18.sp,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.file_open, size: 45, color: AppColor.expenseRed),
                const SizedBox(height: 10),
                Text(
                  "Import",
                  style: AppTextStyles.poppins16w600.copyWith(
                    fontSize: 18.sp,
                    color: AppColor.textGrey,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
