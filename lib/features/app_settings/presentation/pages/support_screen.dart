import 'package:flutter/material.dart';
import 'package:mono/core/constants/app_textstyle/app_textstyle.dart';
import 'package:mono/core/theme/app_theme.dart';
import 'package:mono/features/app_settings/presentation/pages/about_screen.dart';
import 'package:mono/core/utils/extension/context_extension.dart';
import 'package:mono/features/app_settings/presentation/widgets/sublist_tile.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          centerTitle: true,
          elevation: 1,
          title: Text(
            context.l10n.support_title,
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
                      SectionHeader(
                          title: context.l10n.need_help_title,
                          subtitle: context.l10n.need_help_subtitle,
                          context: context),
                      SubListTile(
                        icon: Icons.support_agent_outlined,
                        title: context.l10n.contact_support,
                        onTap: () => _sendFeedback(
                            titleLine: context.l10n.support_request_title,
                            bodyLine: context.l10n.support_request_body),
                        context: context,
                      ),
                      SubListTile(
                        icon: Icons.bug_report_outlined,
                        title: context.l10n.report_bug,
                        onTap: () => _sendFeedback(
                            titleLine: context.l10n.bug_report_title,
                            bodyLine: context.l10n.bug_report_body),
                        context: context,
                      ),
                      SubListTile(
                        icon: Icons.tips_and_updates_outlined,
                        title: context.l10n.request_feature,
                        onTap: () => _sendFeedback(
                            titleLine: context.l10n.feature_request_title,
                            bodyLine: context.l10n.feature_request_body),
                        context: context,
                      ),
                    ])))));
  }

  Future<void> _sendFeedback({String? titleLine, String? bodyLine}) async {
    final subject = Uri.encodeComponent(titleLine ?? "Mono App feedback");
    final body = Uri.encodeComponent(bodyLine ?? "");

    final Uri emailUri = Uri.parse(
      'mailto:support.monoapp@gmail.com?subject=$subject&body=$body',
    );

    if (!await launchUrl(emailUri)) {
      throw 'Could not send message';
    }
  }
}
