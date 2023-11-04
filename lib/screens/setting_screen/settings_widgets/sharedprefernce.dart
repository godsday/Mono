import 'package:shared_preferences/shared_preferences.dart';

class DarkThemePreferences {
  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("themestatus", value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(
          "themestatus",
        ) ??
        false;
  }
}

class NotificationPreference {
  setNotification(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("notifval", value);
  }

  Future<bool> getnotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("notifval") ?? false;
  }
}
