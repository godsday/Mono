import 'package:flutter/material.dart';
import 'package:mono/core/theme/app_texttheme.dart';
import 'package:mono/core/utils/extension/app_extension.dart';
import 'package:mono/features/home/presentation/providers/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:mono/core/utils/extension/context_extension.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${context.l10n.home_greeting_prefix} ${getDisplayName(homeProvider.userName)}",
              style: AppTextTheme.montserrart(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white54,
              ),
            ),
            Text(
              _getLocalizedGreeting(context),
              style: AppTextTheme.montserrart(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white54,
              ),
            ),
          ],
        );
      },
    );
  }

  String _getLocalizedGreeting(BuildContext context) {
    final hour = DateTime.now().hour;
    if (hour < 12) return context.l10n.greeting_morning;
    if (hour < 17) return context.l10n.greeting_afternoon;
    return context.l10n.greeting_evening;
  }

  String getDisplayName(String name) {
    if (name.isEmpty) return '';
    final words = name.trim().split(' ');
    final validWords =
        words.where((word) => word.isNotEmpty && word.length >= 3).toList();

    if (validWords.isEmpty) return '';

    validWords.sort((a, b) => a.length.compareTo(b.length));

    return validWords.first.capitalizeFirstLetter();
  }
}
