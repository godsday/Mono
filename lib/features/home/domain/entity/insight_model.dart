class InsightModel {
  final String id;
  final String title;
  final String message;
  final InsightType type;
  final int priority;

  InsightModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.priority,
  });
}

enum InsightType {
  positive,
  warning,
  alert,
  neutral,
}
