enum VolatilityClassification {
  low,
  medium,
  high,
}

class VolatilityData {
  final double standardDeviation;
  final VolatilityClassification classification;

  VolatilityData({
    required this.standardDeviation,
    required this.classification,
  });
}
