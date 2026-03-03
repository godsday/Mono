enum HealthClassification {
  needsAttention,
  improving,
  strong,
  excellent,
}

class FinancialHealthData {
  final double score; // 0 - 100
  final HealthClassification classification;

  FinancialHealthData({
    required this.score,
    required this.classification,
  });

  String get classificationString {
    switch (classification) {
      case HealthClassification.needsAttention:
        return 'Needs Attention';
      case HealthClassification.improving:
        return 'Improving';
      case HealthClassification.strong:
        return 'Strong';
      case HealthClassification.excellent:
        return 'Excellent';
    }
  }
}
