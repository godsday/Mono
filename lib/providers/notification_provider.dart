import 'package:flutter/material.dart';
import 'package:mono/features/setting_screen/settings_widgets/sharedprefernce.dart';

class NotificationProvider with ChangeNotifier {
  NotificationPreference notificationPreference = NotificationPreference();
  bool _notifValue = false;
  bool get notifValue => _notifValue;

  set notifValue(bool value) {
    _notifValue = value;
    notificationPreference.setNotification(value);
    notifyListeners();
  }
}
