import 'package:library_management_app/features/notifications/domain/entities/notification_entity.dart';

/// Abstract notifications repository contract.
abstract class NotificationsRepository {
  Future<List<NotificationEntity>> getUserNotifications(String userId);
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead(String userId);
  Future<int> getUnreadCount(String userId);
}
