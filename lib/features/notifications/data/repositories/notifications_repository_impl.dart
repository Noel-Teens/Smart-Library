import 'package:library_management_app/features/notifications/data/datasources/notifications_remote_datasource.dart';
import 'package:library_management_app/features/notifications/domain/entities/notification_entity.dart';
import 'package:library_management_app/features/notifications/domain/repositories/notifications_repository.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  const NotificationsRepositoryImpl(this._ds);
  final NotificationsRemoteDataSource _ds;

  @override
  Future<List<NotificationEntity>> getUserNotifications(String userId) =>
      _ds.getUserNotifications(userId);
  @override
  Future<void> markAsRead(String notificationId) =>
      _ds.markAsRead(notificationId);
  @override
  Future<void> markAllAsRead(String userId) => _ds.markAllAsRead(userId);
  @override
  Future<int> getUnreadCount(String userId) => _ds.getUnreadCount(userId);
}
