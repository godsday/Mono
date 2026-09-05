class AppSettingsEntity {
  final String languageCode;
  final String currencyCode;
  final bool smartTransactionCapture;

  AppSettingsEntity({
    required this.languageCode,
    required this.currencyCode,
    this.smartTransactionCapture = false,
  });

  AppSettingsEntity copyWith({
    String? languageCode,
    String? currencyCode,
    bool? smartTransactionCapture,
  }) {
    return AppSettingsEntity(
      languageCode: languageCode ?? this.languageCode,
      currencyCode: currencyCode ?? this.currencyCode,
      smartTransactionCapture:
          smartTransactionCapture ?? this.smartTransactionCapture,
    );
  }
}

