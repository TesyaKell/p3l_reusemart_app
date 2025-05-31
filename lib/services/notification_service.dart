import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  /// Initialize notification service
  static Future<void> init() async {
    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        // Handle notification tap
        print('Notification tapped: ${details.payload}');
      },
    );

    // Create high importance notification channel for Android
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Request permission to display notifications
    await _requestPermissions();

    // Log FCM token for debugging
    final fcmToken = await FirebaseMessaging.instance.getToken();
    debugPrint('FCM Token: $fcmToken');
  }

  /// Handle messages received while the app is in the foreground
  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('Got a foreground message: ${message.messageId}');
    debugPrint('Notification: ${message.notification?.title}');
    debugPrint('Data: ${message.data}');

    // Show local notification for foreground messages
    if (message.notification != null) {
      await showNotification(
        id: message.hashCode,
        title: message.notification?.title ?? 'Notification',
        body: message.notification?.body ?? '',
        payload: message.data.toString(),
      );
    }
  }

  /// Request notification permissions
  static Future<void> _requestPermissions() async {
    // Local notification permissions
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    // Android 13+ requires POST_NOTIFICATIONS permission
    // This method doesn't exist on AndroidFlutterLocalNotificationsPlugin
    // For Android 13+, you need to use permission_handler package

    // FCM permissions
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
  }

  /// Show a local notification
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await _localNotifications.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: payload,
    );
  }

  /// Get FCM token for the device
  static Future<String?> getFcmToken() async {
    return await FirebaseMessaging.instance.getToken();
  }

  /// Delete the current FCM token
  static Future<void> deleteToken() async {
    try {
      // Delete the instance ID, which invalidates the token
      await FirebaseMessaging.instance.deleteToken();

      // Also unsubscribe from any topics if you're using them
      // Example: await FirebaseMessaging.instance.unsubscribeFromTopic('news');
    } catch (e) {
      debugPrint('Error deleting FCM token: $e');
    }
  }
}
