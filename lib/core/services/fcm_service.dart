import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:library_management_app/core/config/supabase_config.dart';

/// Top-level background message handler (must be a top-level function).
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // No-op: we just need to acknowledge the message.
}

/// Firebase Cloud Messaging service.
///
/// Call [FcmService.init] from `main()` after Firebase.initializeApp().
class FcmService {
  FcmService._();
  static final FcmService instance = FcmService._();

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  /// Android notification channel for high-importance messages.
  static const _androidChannel = AndroidNotificationChannel(
    'smart_library_channel',
    'Smart Library Notifications',
    description: 'Due reminders, request updates, and availability alerts',
    importance: Importance.high,
  );

  /// Initialize FCM, request permissions, set up listeners,
  /// and store the FCM token in the user's Supabase profile.
  Future<void> init() async {
    // Register background handler
    FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler);

    // Request permissions (Android 13+ / iOS)
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Create Android notification channel
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);

    // Initialize local notifications plugin
    await _localNotifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );

    // Subscribe to foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Store FCM token in Supabase profile
    await _storeFcmToken();

    // Listen for token refresh
    _messaging.onTokenRefresh.listen((_) => _storeFcmToken());
  }

  /// Stores the current FCM token in the user's Supabase profile.
  Future<void> _storeFcmToken() async {
    final token = await _messaging.getToken();
    final userId = SupabaseConfig.client.auth.currentUser?.id;
    if (token != null && userId != null) {
      await SupabaseConfig.client
          .from('profiles')
          .update({'fcm_token': token}).eq('id', userId);
    }
  }

  /// Shows a local notification when the app is in the foreground.
  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }
}
