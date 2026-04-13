import 'package:library_management_app/features/notifications/domain/entities/notification_entity.dart';

/// Abstract datasource for notifications.
abstract class NotificationsRemoteDataSource {
  Future<List<NotificationEntity>> getUserNotifications(String userId);
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead(String userId);
  Future<int> getUnreadCount(String userId);
}
