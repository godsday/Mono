import 'package:shared_preferences/shared_preferences.dart';

class SmsDeduplicationService {
  final SharedPreferences sharedPreferences;
  static const String _keyProcessedHashes = 'sms_processed_hashes_list';
  static const int _maxStoredHashes = 500;

  SmsDeduplicationService({required this.sharedPreferences});

  /// Checks whether a transaction with this deterministic hash has already been processed.
  Future<bool> isDuplicate(String hash) async {
    if (hash.isEmpty) return false;
    final list = sharedPreferences.getStringList(_keyProcessedHashes) ?? [];
    return list.contains(hash);
  }

  /// Records a deterministic hash to prevent future duplicate processing.
  Future<void> recordHash(String hash) async {
    if (hash.isEmpty) return;
    final list = sharedPreferences.getStringList(_keyProcessedHashes) ?? [];
    if (!list.contains(hash)) {
      list.add(hash);
      // Keep only recent 500 hashes to avoid unbounded storage
      if (list.length > _maxStoredHashes) {
        list.removeRange(0, list.length - _maxStoredHashes);
      }
      await sharedPreferences.setStringList(_keyProcessedHashes, list);
    }
  }

  /// Clears stored deduplication hashes (useful for app reset / testing).
  Future<void> clearHashes() async {
    await sharedPreferences.remove(_keyProcessedHashes);
  }
}
