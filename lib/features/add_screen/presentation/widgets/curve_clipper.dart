import 'package:flutter/material.dart';
import 'package:mono/core/constants/colors/app_colors.dart';
import 'package:mono/core/theme/app_texttheme.dart';
import 'package:mono/core/theme/app_theme.dart';
import 'package:mono/core/utils/extension/context_extension.dart';
import 'package:mono/features/transaction/data/models/transcation_model.dart';
import 'package:mono/features/add_screen/presentation/widgets/add_clipper.dart';
import 'package:mono/features/transaction/presentation/providers/transaction_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CurveClipperAddScreen extends StatefulWidget {
  final TranscationModel? isDataExist;

  const CurveClipperAddScreen({
    super.key,
    this.isDataExist,
  });

  @override
  State<CurveClipperAddScreen> createState() => _CurveClipperAddScreenState();
}

class _CurveClipperAddScreenState extends State<CurveClipperAddScreen> {
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: const Key('add_screen_curve_clipper'),
      child: ClipPath(
        clipper: CurveClipper(),
        child: Container(
          decoration: BoxDecoration(
            gradient:
                Theme.of(context).extension<AppGradients>()?.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          height: 40.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Consumer<TransactionProvider>(
                        builder: (context, transactionProvider, child) {
                      return Text(
                        widget.isDataExist == null
                            ? '${context.l10n.add_transaction_title} ${transactionProvider.selectedType}'
                            : '${context.l10n.edit_transaction_title} ${transactionProvider.selectedType}',
                        style: AppTextTheme.montserrart(
                          fontSize: 18.5.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColor.whiteColor,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
