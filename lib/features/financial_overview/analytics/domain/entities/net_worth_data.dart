class NetWorthData {
  final double currentNetWorth;
  final Map<DateTime, double>
      historyLast6Months; // Month start date -> net worth
  final double growthPercentage;

  NetWorthData({
    required this.currentNetWorth,
    required this.historyLast6Months,
    required this.growthPercentage,
  });
}
