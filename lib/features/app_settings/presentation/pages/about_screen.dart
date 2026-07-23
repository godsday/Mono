import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:mono/core/constants/app_string/app_strings.dart';
import 'package:mono/core/constants/app_textstyle/app_textstyle.dart';
import 'package:mono/core/theme/app_texttheme.dart';
import 'package:mono/core/theme/app_theme.dart';
import 'package:mono/features/app_settings/presentation/widgets/sublist_tile.dart';
import 'package:mono/core/utils/extension/context_extension.dart';
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

  Future<void> openGoogleDriveLink(String driveUrl) async {
    final Uri url = Uri.parse(driveUrl);

    if (!await launchUrl(
      url,
      mode: LaunchMode.platformDefault,
    )) {
      throw Exception("Could not open privacy policy");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        title: Text(
          context.l10n.about_title,
          style: AppTextStyles.montserrat18w600.copyWith(
            color: Theme.of(context).extension<AppGradients>()!.textTheme,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          height: 100.h,
          width: 100.w,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildAppIdentitySection(context),
                SectionHeader(
                    title: context.l10n.section_legal,
                    subtitle: null,
                    context: context),
                SubListTile(
                    icon: Icons.privacy_tip_outlined,
                    title: context.l10n.privacy_policy,
                    onTap: () async {
                      await openGoogleDriveLink(AppStrings.privacyPolicyUrl);
                    },
                    context: context),
                SubListTile(
                    icon: Icons.description_outlined,
                    title: context.l10n.terms_of_service,
                    onTap: () async {
                      await openGoogleDriveLink(AppStrings.termsOfServiceUrl);
                    },
                    context: context),
                const Divider(height: 32),
                SectionHeader(
                    title: context.l10n.section_community,
                    subtitle: null,
                    context: context),
                SubListTile(
                    icon: Icons.star_rate_outlined,
                    title: context.l10n.rate_the_app,
                    onTap: () async {
                      if (await inAppReview.isAvailable()) {
                        inAppReview.requestReview();
                      }
                    },
                    context: context),
                SubListTile(
                    icon: Icons.share_outlined,
                    title: context.l10n.share_with_friends,
                    onTap: () {
                      final params = ShareParams(
                        text: context.l10n.share_text,
                      );
                      SharePlus.instance.share(params);
                    },
                    context: context),
                SizedBox(height: 4.h),
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
      padding: EdgeInsets.only(
        top: 5.h,
      ),
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
            style: AppTextTheme.inter.copyWith(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).extension<AppGradients>()!.textTheme,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            context.l10n.app_tagline,
            style: AppTextTheme.poppins(
              fontSize: 14.sp,
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
                  ? context.l10n.version_loading
                  : context.l10n.version_display(
                      _packageInfo.version, _packageInfo.buildNumber),
              style: AppTextTheme.poppins(
                fontSize: 12.sp,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /*Widget _buildCreditsRow(String text, IconData icon, BuildContext context) {
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
  }*/

  Widget _buildFooter() {
    return Center(
      child: Column(
        children: [
          Text(
            context.l10n.made_with_love,
            style: AppTextTheme.poppins(
              fontSize: 14.5.sp,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            "© Mono ${DateTime.now().year}",
            style: AppTextTheme.poppins(
              fontSize: 11.sp,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    required this.context,
  });

  final String title;
  final String? subtitle;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.only(top: 14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextTheme.poppins(
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
            ),
            if (subtitle != null) ...[
              SizedBox(height: 0.5.h),
              Text(
                subtitle!,
                style: AppTextTheme.poppins(
                  fontSize: 15.sp,
                  color: Theme.of(context).disabledColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
