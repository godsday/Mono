class InsightModel {
  final String title;
  final String message;
  final InsightType type;

  InsightModel({
    required this.title,
    required this.message,
    required this.type,
  });
}

enum InsightType {
  positive,
  warning,
  alert,
  neutral,
}
