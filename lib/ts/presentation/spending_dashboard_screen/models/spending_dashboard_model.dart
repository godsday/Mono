class SpendingDashboardModel {
  String? title;
  String? totalSpending;
  int? selectedExpenseTab;
  int? selectedTimePeriod;

  SpendingDashboardModel({
    this.title,
    this.totalSpending,
    this.selectedExpenseTab,
    this.selectedTimePeriod,
  }) {
    title = title ?? 'My Spendings';
    totalSpending = totalSpending ?? '₹1000.0';
    selectedExpenseTab = selectedExpenseTab ?? 1;
    selectedTimePeriod = selectedTimePeriod ?? 1;
  }
}
