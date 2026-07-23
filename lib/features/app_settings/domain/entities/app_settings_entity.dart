class AppSettingsEntity {
  final String languageCode;
  final String currencyCode;

  AppSettingsEntity({
    required this.languageCode,
    required this.currencyCode,
  });

  AppSettingsEntity copyWith({
    String? languageCode,
    String? currencyCode,
  }) {
    return AppSettingsEntity(
      languageCode: languageCode ?? this.languageCode,
      currencyCode: currencyCode ?? this.currencyCode,
    );
  }
}
