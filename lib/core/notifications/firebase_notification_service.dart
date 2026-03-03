import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    await _requestPermission();
    await _configureHandlers();
    _getToken();
  }

  Future<void> _requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      print('User declined or has not granted permission');
      // On Android this will never happen, but for cross-platform code it's okay.
      return;
    }
  }

  Future<void> _configureHandlers() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      // If the message contains a notification payload, you can extract it:
      if (message.notification != null) {
        print(
            'Message also contained a notification: ${message.notification!.title}');
      }

      // Here you can show a local notification (e.g., using flutter_local_notifications)
      // because when the app is in foreground, FCM does NOT automatically display a heads-up notification.
    });
// When the app is in the background but opened by tapping a notification - but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification clicked!');
      // Navigate to a specific screen based on message.data
    });

    // Check if the app was opened from a terminated state by tapping a notification
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print('App opened from terminated state by a notification');
      // Navigate accordingly
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print('Token refreshed: $newToken');
      // Send the new token to your server
    });
  }

  Future<void> _getToken() async {
    String? token = await _messaging.getToken();
    print("FCM Token: $token");
  }
}
