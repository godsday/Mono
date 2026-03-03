enum InsightType {
  positive,
  warning,
  alert,
  neutral,
}

class AiInsightData {
  final String message;
  final InsightType type;
  final int priority;

  AiInsightData({
    required this.message,
    required this.type,
    required this.priority,
  });
}
