import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors/app_colors.dart';
import 'package:mono/core/theme/app_texttheme.dart';
import 'package:mono/core/widgets/app_bottomsheet.dart';
import 'package:mono/core/widgets/dialog_box.dart';
import 'package:mono/features/setting_screen/presentation/widgets/curve_shape.dart';
import 'package:mono/features/transaction/data/datasources/transaction_local_data_source.dart';
import 'package:mono/providers/notification_provider.dart';
import 'package:mono/providers/theme_provider.dart';
import 'package:mono/features/add_screen/presentation/add_screen.dart';
import 'package:mono/features/setting_screen/presentation/widgets/notification.dart';
import 'package:mono/routes/route_names.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../financial_overview/budget/data/repositories/budget_repository_impl.dart';
import '../../../financial_overview/asset/data/repositories/asset_repository_impl.dart';
import '../../../financial_overview/goals/data/repositories/goal_repository_impl.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool expandabout = false;
  @override
  void initState() {
    super.initState();
    NotificationApi().init(initScheduled: true);
    listenNotifications();
  }

  void listenNotifications() {
    NotificationApi.onNotifications.listen(onClickNotifications);
  }

  onClickNotifications(String? payload) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const AddScreen()));
  }

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context).size.width;
    MediaQuery.of(context).size.height;
    final themepovider = Provider.of<DarkThemeProvider>(context);
    final notificationProvider = Provider.of<NotificationProvider>(context);
    return Scaffold(
        body: Column(children: [
      ClipPath(
        clipper: WaveClipper(),
        child: Stack(
            clipBehavior: Clip.hardEdge,
            alignment: Alignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF429690), Color(0xFF1E4744)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                // color: Theme.of(context).dividerColor,
                height: 17.0.h,
              ),
              Positioned(
                  top: 5.h,
                  left: 33.w,
                  child: Image(
                    width: 57.w,
                    image: const AssetImage(
                      'assets/images/rings.png',
                    ),
                  )),
              Positioned(
                top: 6.h,
                child: Text(
                  "Settings",
                  style: AppTextTheme.montserrart(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColor.white,
                  ),
                ),
              ),
            ]),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: Container(
          width: 90.w,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.sp),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 4,
                )
              ]),
          child: Padding(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                            notificationProvider.notifValue
                                ? Icons.notifications
                                : Icons.notifications_off,
                            color: themepovider.darkTheme
                                ? AppColor.white
                                : Colors.black),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Notification',
                          style: AppTextTheme.poppins(
                              fontSize: 17.sp, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Transform.scale(
                      scale: .77,
                      child: Switch.adaptive(
                          activeThumbColor: AppColor.mainHexcolor,
                          value: notificationProvider.notifValue,
                          onChanged: (value) {
                            setState(() {
                              notificationProvider.notifValue = value;
                            });
                          }),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(themepovider.darkTheme
                            ? Icons.dark_mode_outlined
                            : Icons.light_mode_outlined),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Dark Mode',
                          style: AppTextTheme.poppins(
                              fontSize: 17.sp, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Transform.scale(
                      scale: .77,
                      child: Switch.adaptive(
                          activeThumbColor: AppColor.mainHexcolor,
                          value: themepovider.darkTheme,
                          onChanged: (value) {
                            setState(() {
                              themepovider.darkTheme = value;
                            });
                          }),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(),
                SizedBox(
                  height: 2.h,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'More',
                            style: AppTextTheme.poppins(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColor.grey),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, RouteNames.about);
                        },
                        child: SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("About",
                                  style: AppTextTheme.poppins(
                                      color: AppColor.textGrey,
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w500)),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 17.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      InkWell(
                        onTap: () async {
                          // ignore: deprecated_member_use
                          if (!await launch(
                              'mailto:rafikkvavoor@gmail.com?subject=Mono-App&body=write your own...')) {
                            throw 'Could not send massage';
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Send feedback",
                              style: AppTextTheme.poppins(
                                color: AppColor.textGrey,
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 17.sp,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      InkWell(
                        onTap: () {
                          showAppBottomSheet(
                            context: context,
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Secure Data",
                              style: AppTextTheme.poppins(
                                color: AppColor.textGrey,
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 17.sp,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      InkWell(
                          onTap: () async {
                            showAddCategoryDialog(
                              context,
                              isAlert: true,
                              title: "Alert!!!",
                              subtitle:
                                  "All transaction details will be deleted.\n\nDo you like to continue ?",
                              onYesPressed: () async {
                                print("delete all data");
                                await TransactionLocalDataSourceImpl.instance
                                    .clearTransactions();
                                await BudgetRepositoryImpl().clearBudget();
                                await AssetRepositoryImpl().clearAssets();
                                await GoalRepositoryImpl().clearGoals();

                                if (context.mounted) {
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      RouteNames.splash, (route) => false);
                                }
                              },
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Reset App",
                                style: AppTextTheme.poppins(
                                  color: AppColor.textGrey,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    ]));
  }
}
