import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logAppOpen() async {
    try {
      await _analytics.logAppOpen();
      debugPrint('Analytics: app_open logged');
    } catch (e) {
      debugPrint('Analytics Error: Failed to log app_open: $e');
    }
  }

  Future<void> logAddTransaction({required String type, required String category}) async {
    try {
      await _analytics.logEvent(
        name: 'add_transaction',
        parameters: {
          'transaction_type': type,
          'category': category,
        },
      );
      debugPrint('Analytics: add_transaction logged ($type, $category)');
    } catch (e) {
      debugPrint('Analytics Error: Failed to log add_transaction: $e');
    }
  }

  Future<void> logDeleteTransaction({required String id}) async {
    try {
      await _analytics.logEvent(
        name: 'delete_transaction',
        parameters: {
          'transaction_id': id,
        },
      );
      debugPrint('Analytics: delete_transaction logged ($id)');
    } catch (e) {
      debugPrint('Analytics Error: Failed to log delete_transaction: $e');
    }
  }

  Future<void> logExportBackup() async {
    try {
      await _analytics.logEvent(
        name: 'export_backup',
      );
      debugPrint('Analytics: export_backup logged');
    } catch (e) {
      debugPrint('Analytics Error: Failed to log export_backup: $e');
    }
  }
}
