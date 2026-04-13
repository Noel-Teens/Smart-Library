import 'package:equatable/equatable.dart';

/// Types of notifications from PRD §8.5.
enum NotificationType {
  dueReminder,
  overdueAlert,
  requestUpdate,
  availabilityAlert;

  String get label {
    switch (this) {
      case NotificationType.dueReminder:
        return 'Due Reminder';
      case NotificationType.overdueAlert:
        return 'Overdue Alert';
      case NotificationType.requestUpdate:
        return 'Request Update';
      case NotificationType.availabilityAlert:
        return 'Availability Alert';
    }
  }
}

/// Domain entity for an in-app notification.
class NotificationEntity extends Equatable {
  const NotificationEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.isRead = false,
    required this.createdAt,
    this.relatedTransactionId,
  });

  final String id;
  final String userId;
  final String title;
  final String body;
  final NotificationType type;
  final bool isRead;
  final DateTime createdAt;
  final String? relatedTransactionId;

  @override
  List<Object?> get props =>
      [id, userId, title, body, type, isRead, createdAt, relatedTransactionId];

  NotificationEntity copyWith({
    String? id,
    String? userId,
    String? title,
    String? body,
    NotificationType? type,
    bool? isRead,
    DateTime? createdAt,
    String? relatedTransactionId,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      relatedTransactionId:
          relatedTransactionId ?? this.relatedTransactionId,
    );
  }

  /// Human-readable relative time string.
  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }
}
