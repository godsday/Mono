import 'package:flutter/material.dart';
import 'package:mono/core/constants/app_textstyle/app_textstyle.dart';
import 'package:mono/core/constants/colors/app_colors.dart';
import 'package:mono/core/theme/app_texttheme.dart';
import 'package:mono/core/theme/app_theme.dart';
import 'package:mono/core/widgets/app_bottomsheet.dart';
import 'package:mono/core/widgets/dialog_box.dart';
import 'package:mono/features/app_settings/presentation/widgets/curve_shape.dart';
import 'package:mono/features/app_settings/presentation/widgets/sublist_tile.dart';
import 'package:mono/features/transaction/data/datasources/transaction_local_data_source.dart';
import 'package:mono/providers/notification_provider.dart';
import 'package:mono/providers/theme_provider.dart';
import 'package:mono/features/add_screen/presentation/add_screen.dart';
import 'package:mono/features/app_settings/presentation/widgets/notification.dart';
import 'package:mono/routes/route_names.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:mono/features/app_settings/presentation/providers/app_settings_provider.dart';
import 'package:mono/providers/locale_provider.dart';
import 'package:mono/core/utils/extension/context_extension.dart';
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
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(115), child: SettingsHeader()),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 38.0, left: 24, right: 24),
            child: Column(children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.sp),
                    color: Theme.of(context).scaffoldBackgroundColor,
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
                                    ? AppColor.whiteColor
                                    : AppColor.blackColor,
                                size: 20.sp,
                              ),
                              SizedBox(
                                width: 4.w,
                              ),
                              Text(
                                context.l10n.settings_notification,
                                style: AppTextTheme.poppins(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          Transform.scale(
                            scale: .70,
                            child: Switch.adaptive(
                                activeThumbColor: Theme.of(context)
                                    .extension<AppGradients>()!
                                    .switchColor,
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
                              Icon(
                                themepovider.darkTheme
                                    ? Icons.dark_mode_outlined
                                    : Icons.light_mode_outlined,
                                size: 20.sp,
                              ),
                              SizedBox(
                                width: 4.w,
                              ),
                              Text(
                                context.l10n.settings_dark_mode,
                                style: AppTextTheme.poppins(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Transform.scale(
                                scale: .70,
                                child: Switch.adaptive(
                                    activeThumbColor: Theme.of(context)
                                        .extension<AppGradients>()!
                                        .switchColor,
                                    value: themepovider.darkTheme,
                                    onChanged: (value) {
                                      setState(() {
                                        themepovider.darkTheme = value;
                                      });
                                    }),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.language,
                                color: themepovider.darkTheme
                                    ? AppColor.whiteColor
                                    : AppColor.blackColor,
                                size: 20.sp,
                              ),
                              SizedBox(
                                width: 4.w,
                              ),
                              Text(
                                context.l10n.settings_language,
                                style: AppTextTheme.poppins(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          Consumer2<AppSettingsProvider, LocaleProvider>(
                            builder:
                                (context, appSettings, localeProvider, child) {
                              return DropdownButton<String>(
                                value: appSettings.languageCode,
                                underline: const SizedBox(),
                                icon: const Icon(Icons.arrow_drop_down),
                                items: L10n.all.map((locale) {
                                  final code = locale.languageCode;
                                  return DropdownMenuItem<String>(
                                    value: code,
                                    child: Text(
                                      '${L10n.getFlag(code)} ${L10n.getLanguageName(code)}',
                                      style:
                                          AppTextTheme.poppins(fontSize: 14.sp),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    appSettings.updateLanguage(newValue);
                                    localeProvider.setLocale(Locale(newValue));
                                  }
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.attach_money,
                                color: themepovider.darkTheme
                                    ? AppColor.whiteColor
                                    : AppColor.blackColor,
                                size: 20.sp,
                              ),
                              SizedBox(
                                width: 4.w,
                              ),
                              Text(
                                context.l10n.settings_currency,
                                style: AppTextTheme.poppins(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          Consumer<AppSettingsProvider>(
                            builder: (context, appSettings, child) {
                              final currencies = [
                                'USD',
                                'EUR',
                                'INR',
                                'GBP',
                                'JPY'
                              ];
                              return DropdownButton<String>(
                                value: currencies
                                        .contains(appSettings.currencyCode)
                                    ? appSettings.currencyCode
                                    : 'USD',
                                underline: const SizedBox(),
                                icon: const Icon(Icons.arrow_drop_down),
                                items: currencies.map((String currency) {
                                  return DropdownMenuItem<String>(
                                    value: currency,
                                    child: Text(
                                      '${AppSettingsProvider.getCurrencySymbol(currency)} $currency',
                                      style: AppTextStyles.roboto16w600Black
                                          .copyWith(fontSize: 14.sp),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    appSettings.updateCurrency(newValue);
                                  }
                                },
                              );
                            },
                          )
                        ],
                      ),
                      const Divider(
                        height: 20,
                      ),
                      SubListTile(
                          isSettings: true,
                          icon: Icons.privacy_tip_outlined,
                          title: context.l10n.settings_about,
                          onTap: () async {
                            Navigator.pushNamed(context, RouteNames.about);
                          },
                          context: context),
                      SubListTile(
                          isSettings: true,
                          icon: Icons.description_outlined,
                          title: context.l10n.settings_support,
                          onTap: () async {
                            Navigator.pushNamed(context, RouteNames.support);
                          },
                          context: context),

                      SubListTile(
                          isSettings: true,
                          icon: Icons.lock_outline,
                          title: context.l10n.settings_secure_data,
                          onTap: () {
                            showAppBottomSheet(
                              context: context,
                            );
                          },
                          context: context),

                      SubListTile(
                          isSettings: true,
                          icon: Icons.delete_outline,
                          title: context.l10n.settings_reset_app,
                          onTap: () async {
                            showAddCategoryDialog(
                              context,
                              isAlert: true,
                              title: context.l10n.settings_reset_alert_title,
                              subtitle:
                                  context.l10n.settings_reset_alert_subtitle,
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
                          context: context),

                      // InkWell(
                      //     onTap: () async {
                      //       showAddCategoryDialog(
                      //         context,
                      //         isAlert: true,
                      //         title: "Alert!!!",
                      //         subtitle:
                      //             "All transaction details will be deleted.\n\nDo you like to continue ?",
                      //         onYesPressed: () async {
                      //           print("delete all data");
                      //           await TransactionLocalDataSourceImpl.instance
                      //               .clearTransactions();
                      //           await BudgetRepositoryImpl().clearBudget();
                      //           await AssetRepositoryImpl().clearAssets();
                      //           await GoalRepositoryImpl().clearGoals();

                      //           if (context.mounted) {
                      //             Navigator.pushNamedAndRemoveUntil(context,
                      //                 RouteNames.splash, (route) => false);
                      //           }
                      //         },
                      //       );
                      //     },

                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         Text(
                      //           "Reset App",
                      //           style: AppTextTheme.poppins(
                      //             color: Theme.of(context).disabledColor,
                      //             fontSize: 17.sp,
                      //             fontWeight: FontWeight.w500,
                      //           ),
                      //         ),
                      //       ],
                      //     )),
                    ],
                  ),
                ),
              )
            ]),
          ),
        ));
  }
}

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WaveClipper(),
      child: Stack(clipBehavior: Clip.hardEdge, children: [
        Container(
          width: double.infinity,

          decoration: BoxDecoration(
            gradient:
                Theme.of(context).extension<AppGradients>()!.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          // color: Theme.of(context).dividerColor,

          child: Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Column(
              children: [
                Text(
                  context.l10n.settings_title,
                  style: AppTextTheme.montserrart(
                    fontSize: 18.5.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColor.whiteColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
            top: 3.h,
            left: 33.w,
            child: Image(
              width: 77.w,
              image: const AssetImage(
                'assets/images/rings.png',
              ),
            )),
      ]),
    );
  }
}
