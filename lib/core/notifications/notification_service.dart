import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static const String _fcmTokenKey = 'fcm_token';

  Future<void> init() async {
    // Initialize Timezones
    tz.initializeTimeZones();

    // Get device timezone

    // Set local timezone
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

    // 1. Request Permissions (FCM)
    await _requestFCMPermissions();

    // 2. Initialize Local Notifications
    await _initLocalNotifications();

    // 3. Configure FCM Handlers
    _configureFCMHandlers();

    // 4. Get/cache FCM Token
    await _getFCMToken();
  }

  Future<void> _requestFCMPermissions() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not granted permission');
    }
  }

  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        print("Notification tapped: ${response.payload}");
      },
    );

    // Create a high importance channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.max,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  void _configureFCMHandlers() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message received: ${message.messageId}');
      _showLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked! ${message.data}');
    });

    // Keep the local cache in sync whenever Firebase rotates the token
    _fcm.onTokenRefresh.listen((newToken) async {
      await _secureStorage.write(key: _fcmTokenKey, value: newToken);
      print('FCM Token refreshed & re-cached: $newToken');
    });
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data.toString(),
      );
    }
  }

  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await _localNotifications.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'mono_alerts',
          'Mono Alerts',
          channelDescription: 'Financial alerts and reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: payload,
    );
  }

  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    await _localNotifications.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminders',
          'Daily Reminders',
          channelDescription: 'Daily reminders to log your expenses',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  /// Returns the locally cached FCM token, fetching from Firebase only when
  /// no cached value is present or [forceRefresh] is true.
  Future<String?> getFCMToken({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = await _secureStorage.read(key: _fcmTokenKey);
      if (cached != null && cached.isNotEmpty) {
        print('FCM Token (cached): $cached');
        return cached;
      }
    }
    return await _fetchAndCacheToken();
  }

  Future<void> _getFCMToken() async {
    await getFCMToken();
  }

  Future<String?> _fetchAndCacheToken() async {
    try {
      final token = await _fcm.getToken();
      if (token != null) {
        await _secureStorage.write(key: _fcmTokenKey, value: token);
        print('FCM Token (fetched & cached): $token');
      }
      return token;
    } catch (e) {
      print('FCM Token fetch error: $e');
      await Future.delayed(const Duration(seconds: 3));
      try {
        final token = await _fcm.getToken();
        if (token != null) {
          await _secureStorage.write(key: _fcmTokenKey, value: token);
          print('FCM Token (retry & cached): $token');
        }
        return token;
      } catch (retryError) {
        print('FCM Token retry error: $retryError');
        return null;
      }
    }
  }

  /// Call this to clear the cached FCM token (e.g., on logout).
  Future<void> clearCachedFCMToken() async {
    await _secureStorage.delete(key: _fcmTokenKey);
  }
}
