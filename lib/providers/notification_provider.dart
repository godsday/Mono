import 'package:flutter/material.dart';
import 'package:mono/features/app_settings/presentation/widgets/sharedprefernce.dart';
import 'package:mono/core/notifications/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider with ChangeNotifier {
  NotificationPreference notificationPreference = NotificationPreference();
  bool _notifValue = false;
  bool get notifValue => _notifValue;

  set notifValue(bool value) {
    _notifValue = value;
    notificationPreference.setNotification(value);
    if (value) {
      _scheduleDailyReminder();
    } else {
      NotificationService().cancelAllNotifications();
    }
    notifyListeners();
  }

  void _scheduleDailyReminder() {
    // Default to 8:00 PM
    NotificationService().scheduleDailyNotification(
      id: 100,
      title: 'Time to log your expenses! 💰',
      body: 'Keep your finances on track by logging today\'s transactions.',
      hour: 20,
      minute: 0,
    );
  }

  Future<void> triggerBudgetAlert(double totalSpent, double budgetLimit) async {
    if (!_notifValue) return;

    final prefs = await SharedPreferences.getInstance();
    final lastNotifDate = prefs.getString('last_budget_notif_date');
    final today = DateTime.now().toIso8601String().split('T')[0];

    if (lastNotifDate == today) return;

    String? title;
    String? body;
    int? id;

    if (totalSpent > budgetLimit) {
      title = 'Budget Exceeded! ⚠️';
      body =
          'You have spent \$${totalSpent.toStringAsFixed(2)}, which is over your budget of \$${budgetLimit.toStringAsFixed(2)}.';
      id = 200;
    } else if (totalSpent > budgetLimit * 0.9) {
      title = 'Budget Warning 🔔';
      body = 'You have reached 90% of your monthly budget.';
      id = 201;
    }

    if (title != null && body != null && id != null) {
      await NotificationService().showInstantNotification(
        id: id,
        title: title,
        body: body,
      );
      await prefs.setString('last_budget_notif_date', today);
    }
  }

  void triggerGoalMilestone(String goalName, double progress) {
    if (!_notifValue) return;

    String? title;
    String? body;

    if (progress >= 1.0) {
      title = 'Goal Achieved! 🎉';
      body = 'Congratulations! You have reached your goal for "$goalName".';
    } else if (progress >= 0.5 && progress < 0.55) {
      // Trigger only once when crossing 50%
      title = 'Halfway There! 🚀';
      body = 'You have reached 50% of your goal for "$goalName". Keep going!';
    }

    if (title != null && body != null) {
      NotificationService().showInstantNotification(
        id: goalName.hashCode,
        title: title,
        body: body,
      );
    }
  }
}
