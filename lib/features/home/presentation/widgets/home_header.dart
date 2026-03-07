import 'package:flutter/material.dart';
import 'package:mono/core/theme/app_texttheme.dart';
import 'package:mono/core/utils/extension/app_extension.dart';
import 'package:mono/features/home/presentation/providers/home_provider.dart';
import 'package:provider/provider.dart';

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
              "Hi ${homeProvider.userName.capitalizeFirstLetter()}",
              style: AppTextTheme.montserrart(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white54,
              ),
            ),
            Text(
              homeProvider.greeting,
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
}
