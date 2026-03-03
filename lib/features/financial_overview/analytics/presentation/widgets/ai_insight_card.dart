import 'package:flutter/material.dart';
import '../../domain/entities/ai_insight_data.dart';

class AiInsightCard extends StatelessWidget {
  final AiInsightData insight;

  const AiInsightCard({super.key, required this.insight});

  Color _getColor() {
    switch (insight.type) {
      case InsightType.positive:
        return Colors.green;
      case InsightType.warning:
        return Colors.orange;
      case InsightType.alert:
        return Colors.red;
      case InsightType.neutral:
        return Colors.blue;
    }
  }

  IconData _getIcon() {
    switch (insight.type) {
      case InsightType.positive:
        return Icons.star_rounded;
      case InsightType.warning:
        return Icons.warning_rounded;
      case InsightType.alert:
        return Icons.error_rounded;
      case InsightType.neutral:
        return Icons.info_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(seconds: 1),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position:
                  Tween<Offset>(begin: const Offset(0.0, 0.2), end: Offset.zero)
                      .animate(animation),
              child: child,
            ));
      },
      child: Container(
        key: ValueKey<String>(insight.message),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _getColor().withValues(alpha: 0.8),
                _getColor(),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: _getColor().withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ]),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(_getIcon(), color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "AI Wealth Insight",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    insight.message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
