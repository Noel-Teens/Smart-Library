import 'package:library_management_app/core/config/supabase_config.dart';
import 'package:library_management_app/features/notifications/data/datasources/notifications_remote_datasource.dart';
import 'package:library_management_app/features/notifications/domain/entities/notification_entity.dart';

/// Supabase implementation of [NotificationsRemoteDataSource].
class SupabaseNotificationsDataSource
    implements NotificationsRemoteDataSource {
  final _client = SupabaseConfig.client;

  @override
  Future<List<NotificationEntity>> getUserNotifications(String userId) async {
    final data = await _client
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return data
        .map<NotificationEntity>((json) => _fromJson(json))
        .toList();
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await _client
        .from('notifications')
        .update({'is_read': true}).eq('id', notificationId);
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('user_id', userId)
        .eq('is_read', false);
  }

  @override
  Future<int> getUnreadCount(String userId) async {
    final data = await _client
        .from('notifications')
        .select('id')
        .eq('user_id', userId)
        .eq('is_read', false);
    return data.length;
  }

  NotificationEntity _fromJson(Map<String, dynamic> json) {
    return NotificationEntity(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: _parseType(json['type'] as String?),
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      relatedTransactionId: json['related_transaction_id'] as String?,
    );
  }

  NotificationType _parseType(String? t) {
    switch (t) {
      case 'dueReminder':
        return NotificationType.dueReminder;
      case 'overdueAlert':
        return NotificationType.overdueAlert;
      case 'availabilityAlert':
        return NotificationType.availabilityAlert;
      case 'requestUpdate':
      default:
        return NotificationType.requestUpdate;
    }
  }
}
