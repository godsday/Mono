import 'package:flutter/material.dart';
import 'package:mono/core/constants/app_textstyle/app_textstyle.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mono/core/constants/app_string/app_strings.dart';
import 'package:mono/core/constants/colors/app_colors.dart';
import 'package:mono/core/storage/backup/backup_service.dart';
import 'package:mono/features/widgets/dialog_box.dart';
import 'package:mono/features/widgets/snackbar.dart';
import 'package:mono/features/transaction/data/models/transcation_model.dart';
import 'package:mono/routes/route_names.dart';
import 'package:sizer/sizer.dart';

void showAppBottomSheet({
  required BuildContext context,
}) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        height: 190,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () async {
                final transactionsBox =
                    Hive.box<TranscationModel>(AppStrings.transactionBoxName);
                if (transactionsBox.isEmpty) {
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(customSnack(
                      context,
                      message: "No transactions found to export ❌"));
                  return;
                }

                final success = await BackupService.instance.exportData();
                if (!context.mounted) return;
                Navigator.pop(context);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(customSnack(
                      context,
                      message: "Data exported successfully ✅"));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      customSnack(context, message: "Data export failed ❌"));
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.outbond, size: 45, color: AppColor.incomeGreen),
                  const SizedBox(height: 10),
                  Text(
                    "Export",
                    style: AppTextStyles.poppins16w600.copyWith(
                      color: Theme.of(context).disabledColor,
                      fontSize: 18.sp,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                showConfirmationDialog(
                  context: context,
                  title: 'Import Backup',
                  subtitle:
                      'Importing data will erase all your existing records. Are you sure you want to proceed?',
                  onConfirm: () async {
                    final success = await BackupService.instance.importBackup();
                    if (!context.mounted) return;
                    Navigator.pop(context);
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(customSnack(
                          context,
                          message: "Data imported successfully ✅"));

                      Navigator.pushNamedAndRemoveUntil(
                          context, RouteNames.splash, (route) => false);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(customSnack(
                          context,
                          message: "Data import failed ❌"));
                    }
                  },
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.file_open, size: 45, color: AppColor.expenseRed),
                  const SizedBox(height: 10),
                  Text(
                    "Import",
                    style: AppTextStyles.poppins16w600.copyWith(
                      fontSize: 18.sp,
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
