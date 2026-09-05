import '../entities/transaction_candidate.dart';
import '../entities/transaction_draft.dart';
import 'candidate_detector.dart';
import 'transaction_template_registry.dart';

class SmsParserResult {
  final TransactionCandidate candidate;
  final TransactionDraft? draft;

  const SmsParserResult({
    required this.candidate,
    this.draft,
  });
}

class SmsParserEngine {
  /// Pure function entry point suitable for execution on background isolates.
  static TransactionDraft? parseToDraft({
    required String sender,
    required String body,
    required DateTime date,
  }) {
    final detector = CandidateDetector();
    final candidate = detector.detect(
      sender: sender,
      body: body,
      timestamp: date,
    );

    if (!candidate.isCandidate) {
      return null;
    }

    final registry = TransactionTemplateRegistry();
    return registry.parse(
      sender: sender,
      body: body,
      timestamp: date,
    );
  }

  /// Full evaluation returning candidate status + extracted draft (used for debugging/testing).
  static SmsParserResult parseFull({
    required String sender,
    required String body,
    required DateTime date,
  }) {
    final detector = CandidateDetector();
    final candidate = detector.detect(
      sender: sender,
      body: body,
      timestamp: date,
    );

    if (!candidate.isCandidate) {
      return SmsParserResult(candidate: candidate, draft: null);
    }

    final registry = TransactionTemplateRegistry();
    final draft = registry.parse(
      sender: sender,
      body: body,
      timestamp: date,
    );

    return SmsParserResult(candidate: candidate, draft: draft);
  }
}
