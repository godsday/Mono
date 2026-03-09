import 'dart:ui';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:mono/core/theme/app_theme.dart';
import 'package:mono/core/utils/extension/context_extension.dart';
import 'package:mono/features/home/domain/entity/insight_model.dart';

class SmartInsightCard extends StatefulWidget {
  final String id;
  final String title;
  final String message;
  final IconData icon;
  final InsightType type;

  const SmartInsightCard({
    super.key,
    required this.id,
    required this.title,
    required this.message,
    this.icon = Icons.lightbulb_outline,
    required this.type,
  });

  @override
  State<SmartInsightCard> createState() => _SmartInsightCardState();
}

class _SmartInsightCardState extends State<SmartInsightCard> {
  bool isTapped = true;
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final style = _getStyle(widget.type);
    return InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          setState(() {
            isTapped = !isTapped;
          });
        },
        onHighlightChanged: (value) {
          setState(() {
            isExpanded = value;
          });
        },
        child: AnimatedScale(
          scale: isExpanded ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.fastOutSlowIn,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 2000),
                  curve: Curves.fastLinearToSlowEaseIn,
                  width: double.infinity,
                  padding: EdgeInsets.only(
                      top: isTapped ? 8 : 16,
                      bottom: isTapped ? 8 : 16,
                      left: 8,
                      right: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.black,
                        Color.fromARGB(255, 30, 35, 35),
                        Colors.amber,
                        Color.fromARGB(255, 3, 19, 18)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(22),
                    color: Colors.white.withValues(alpha: 0.08),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: style.shadowColor.withValues(alpha: 0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: AnimatedSize(
                    duration: const Duration(milliseconds: 2000),
                    curve: Curves.fastLinearToSlowEaseIn,
                    alignment: Alignment.topCenter,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AvatarGlow(
                          glowColor: isTapped
                              ? style.backgroundColor.withValues(alpha: 0.3)
                              : style.backgroundColor,
                          duration: const Duration(milliseconds: 3000),
                          repeat: false,
                          glowRadiusFactor: 4,
                          curve: isTapped
                              ? Curves.easeOutQuad
                              : Curves.easeInOutBack,
                          child: Container(
                            height: 44,
                            width: 44,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: style.backgroundColor,
                            ),
                            child: Icon(
                              style.icon,
                              color: style.iconColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getLocalizedTitle(context),
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w900,
                                    color: Theme.of(context)
                                        .extension<AppGradients>()!
                                        .textThemeBlueHeader),
                              ),
                              if (!isTapped) ...[
                                const SizedBox(height: 6),
                                Text(
                                  _getLocalizedMessage(context),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).disabledColor,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  String _getLocalizedTitle(BuildContext context) {
    switch (widget.id) {
      case "budget_warning":
        return context.l10n.insight_budget_warning_title;
      case "budget_safe":
        return context.l10n.insight_budget_safe_title;
      case "budget_exceeded":
        return context.l10n.insight_budget_exceeded_title;
      case "no_budget":
        return context.l10n.insight_no_budget_title;
      case "daily_safe":
        return context.l10n.insight_smart_tip_title;
      case "savings":
        return context.l10n.insight_savings_title;
      default:
        return context.l10n.insight_default_title;
    }
  }

  String _getLocalizedMessage(BuildContext context) {
    // Extract amount from message if it exists (e.g., "₹100" or just numbers)
    // The previous implementation used widget.message which contains something like "You have only ₹100 left..."
    final amountRegex = RegExp(r'[₹\$]\d+');
    final match = amountRegex.firstMatch(widget.message);
    final amount = match?.group(0) ?? "";

    switch (widget.id) {
      case "budget_warning":
        return context.l10n.insight_budget_warning_message(amount);
      case "budget_safe":
        return context.l10n.insight_budget_safe_message(amount);
      case "budget_exceeded":
        return context.l10n.insight_budget_exceeded_message(amount);
      case "no_budget":
        return context.l10n.insight_no_budget_message;
      case "daily_safe":
        return context.l10n.insight_smart_tip_message(amount);
      case "savings":
        return context.l10n.insight_savings_message(amount);
      default:
        return context.l10n.insight_default_message;
    }
  }

  _InsightStyle _getStyle(InsightType type) {
    switch (type) {
      case InsightType.positive:
        return _InsightStyle(
          backgroundColor: const Color(0xFFE8F5E9),
          icon: Icons.trending_up,
          iconColor: Colors.green,
          titleColor: Colors.green.shade800,
          messageColor: Colors.green.shade700,
          shadowColor: Colors.green.withValues(alpha: 0.2),
        );

      case InsightType.warning:
        return _InsightStyle(
          backgroundColor: const Color(0xFFFFF8E1),
          icon: Icons.warning_amber_rounded,
          iconColor: Colors.orange,
          titleColor: Colors.orange.shade800,
          messageColor: Colors.orange.shade700,
          shadowColor: Colors.orange.withValues(alpha: 0.2),
        );

      case InsightType.alert:
        return _InsightStyle(
          backgroundColor: const Color(0xFFFFEBEE),
          icon: Icons.error_outline,
          iconColor: Colors.red,
          titleColor: Colors.red.shade800,
          messageColor: Colors.red.shade700,
          shadowColor: Colors.red.withValues(alpha: 0.2),
        );

      case InsightType.neutral:
        return _InsightStyle(
          backgroundColor: const Color(0xFFE3F2FD),
          icon: Icons.info_outline,
          iconColor: Colors.blue,
          titleColor: Colors.blue.shade800,
          messageColor: Colors.blue.shade700,
          shadowColor: Colors.blue.withValues(alpha: 0.15),
        );
    }
  }
}

class _InsightStyle {
  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;
  final Color titleColor;
  final Color messageColor;
  final Color shadowColor;

  _InsightStyle({
    required this.backgroundColor,
    required this.icon,
    required this.iconColor,
    required this.titleColor,
    required this.messageColor,
    required this.shadowColor,
  });
}
