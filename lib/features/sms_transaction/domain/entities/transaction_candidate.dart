class TransactionCandidate {
  final bool isCandidate;
  final String? rejectionReason;
  final String sender;
  final String body;
  final DateTime timestamp;

  const TransactionCandidate({
    required this.isCandidate,
    this.rejectionReason,
    required this.sender,
    required this.body,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'TransactionCandidate(isCandidate: $isCandidate, reason: $rejectionReason)';
  }
}
