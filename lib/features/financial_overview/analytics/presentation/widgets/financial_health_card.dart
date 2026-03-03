import 'package:flutter/material.dart';
import '../../domain/entities/financial_health_data.dart';

class FinancialHealthCard extends StatelessWidget {
  final FinancialHealthData data;

  const FinancialHealthCard({super.key, required this.data});

  Color _getColor() {
    switch (data.classification) {
      case HealthClassification.needsAttention:
        return Colors.redAccent;
      case HealthClassification.improving:
        return Colors.orangeAccent;
      case HealthClassification.strong:
        return Colors.blueAccent;
      case HealthClassification.excellent:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _getColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _getColor().withValues(alpha: 0.5), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Financial Health Score',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Icon(Icons.monitor_heart_outlined, color: _getColor()),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                data.score.toStringAsFixed(0),
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: _getColor(),
                ),
              ),
              const Text(
                ' / 100',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getColor(),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              data.classificationString,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
