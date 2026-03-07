import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:mono/core/constants/colors/app_colors.dart';
import 'package:mono/core/theme/app_texttheme.dart';
import 'package:mono/core/theme/app_theme.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  final InAppReview inAppReview = InAppReview.instance;

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Future<void> _sendFeedback() async {
    // ignore: deprecated_member_use
    if (!await launch(
        'mailto:rafikkvavoor@gmail.com?subject=Mono-App&body=write your own...')) {
      throw 'Could not send massage';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("About"),
        backgroundColor: Theme.of(context).primaryColorDark,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          height: 100.h,
          width: 100.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).shadowColor,
                isDarkTheme ? AppColor.blackColor : HexColor('#edede9'),
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildAppIdentitySection(context),
                _buildSectionHeader("Need Help?",
                    "We're here to help improve your experience.", context),
                _buildListTile(
                  icon: Icons.support_agent_outlined,
                  title: "Contact Support",
                  onTap: _sendFeedback,
                  context: context,
                ),
                _buildListTile(
                  icon: Icons.bug_report_outlined,
                  title: "Report a Bug",
                  onTap: _sendFeedback,
                  context: context,
                ),
                _buildListTile(
                  icon: Icons.tips_and_updates_outlined,
                  title: "Request Feature",
                  onTap: _sendFeedback,
                  context: context,
                ),
                const Divider(height: 32),
                _buildSectionHeader("Legal", null, context),
                _buildListTile(
                  icon: Icons.privacy_tip_outlined,
                  title: "Privacy Policy",
                  onTap: () {
                    // Navigate to privacy policy or open url
                  },
                  context: context,
                ),
                _buildListTile(
                  icon: Icons.description_outlined,
                  title: "Terms of Service",
                  onTap: () {
                    // Navigate to terms of service or open url
                  },
                  context: context,
                ),
                _buildListTile(
                  icon: Icons.gavel_outlined,
                  title: "Open Source Licenses",
                  onTap: () {
                    showLicensePage(
                      context: context,
                      applicationName: _packageInfo.appName,
                      applicationVersion: _packageInfo.version,
                      applicationLegalese: "© ${DateTime.now().year} Mono",
                    );
                  },
                  context: context,
                ),
                const Divider(height: 32),
                _buildSectionHeader("Community", null, context),
                _buildListTile(
                  icon: Icons.star_rate_outlined,
                  title: "Rate the App",
                  onTap: () async {
                    if (await inAppReview.isAvailable()) {
                      inAppReview.requestReview();
                    }
                  },
                  context: context,
                ),
                _buildListTile(
                  icon: Icons.share_outlined,
                  title: "Share with Friends",
                  onTap: () {
                    final params = ShareParams(
                      text:
                          'Check out the Mono App for better money management! https://example.com/monoapp',
                    );
                    SharePlus.instance.share(params);
                  },
                  context: context,
                ),
                const Divider(height: 32),
                _buildSectionHeader("Data & Privacy", null, context),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 8.0),
                  child: Text(
                    "Your financial data stays on your device. This app does not collect or upload your personal financial information.",
                    style: AppTextTheme.poppins(
                      fontSize: 10.sp,
                      color: Theme.of(context).disabledColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const Divider(height: 32),
                _buildSectionHeader("Credits", null, context),
                _buildCreditsRow(
                    "Built with Flutter", Icons.flutter_dash, context),
                _buildCreditsRow("Icons from Material Design",
                    Icons.design_services_outlined, context),
                SizedBox(height: 6.h),
                _buildFooter(),
                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppIdentitySection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: AssetImage('assets/images/Appicon.png'),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ]),
          ),
          SizedBox(height: 2.h),
          Text(
            _packageInfo.appName == 'Unknown' ? 'Mono' : _packageInfo.appName,
            style: AppTextTheme.poppins(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).extension<AppGradients>()!.textTheme,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            "Offline money management app",
            style: AppTextTheme.poppins(
              fontSize: 11.sp,
              color: Theme.of(context).disabledColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 1.h),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _packageInfo.version == 'Unknown'
                  ? "Version ..."
                  : "Version ${_packageInfo.version} (${_packageInfo.buildNumber})",
              style: AppTextTheme.poppins(
                fontSize: 9.sp,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
      String title, String? subtitle, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextTheme.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 0.5.h),
            Text(
              subtitle,
              style: AppTextTheme.poppins(
                fontSize: 10.sp,
                color: Theme.of(context).disabledColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 24.0, vertical: 0.0),
      leading: Icon(icon,
          color: Theme.of(context).extension<AppGradients>()!.textTheme,
          size: 20.sp),
      title: Text(
        title,
        style: AppTextTheme.poppins(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).extension<AppGradients>()!.textTheme,
        ),
      ),
      trailing: Icon(Icons.chevron_right,
          color: Theme.of(context).disabledColor, size: 18.sp),
      onTap: onTap,
    );
  }

  Widget _buildCreditsRow(String text, IconData icon, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 14.sp, color: Theme.of(context).disabledColor),
          SizedBox(width: 3.w),
          Text(
            text,
            style: AppTextTheme.poppins(
              fontSize: 10.sp,
              color: Theme.of(context).disabledColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Column(
        children: [
          Text(
            "Made with ❤️ for better money management",
            style: AppTextTheme.poppins(
              fontSize: 10.sp,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            "© Mono ${DateTime.now().year}",
            style: AppTextTheme.poppins(
              fontSize: 9.sp,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
