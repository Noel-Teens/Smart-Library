import 'package:flutter/material.dart';
import 'package:library_management_app/core/theme/app_colors.dart';
import 'package:library_management_app/features/notifications/domain/entities/notification_entity.dart';

/// A single notification row with type-specific icon and read/unread styling.
class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.notification,
    this.onTap,
  });

  final NotificationEntity notification;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isUnread
              ? AppColors.primary50
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).dividerColor,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Type icon ──
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _iconBg(notification.type),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _iconFor(notification.type),
                size: 20,
                color: _iconColor(notification.type),
              ),
            ),
            const SizedBox(width: 12),

            // ── Content ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight:
                                isUnread ? FontWeight.w600 : FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        notification.timeAgo,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.body,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // ── Unread dot ──
            if (isUnread)
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(left: 8, top: 6),
                decoration: const BoxDecoration(
                  color: AppColors.primary500,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(NotificationType type) {
    switch (type) {
      case NotificationType.dueReminder:
        return Icons.schedule_rounded;
      case NotificationType.overdueAlert:
        return Icons.warning_amber_rounded;
      case NotificationType.requestUpdate:
        return Icons.assignment_turned_in_rounded;
      case NotificationType.availabilityAlert:
        return Icons.library_books_rounded;
    }
  }

  Color _iconBg(NotificationType type) {
    switch (type) {
      case NotificationType.dueReminder:
        return AppColors.warning50;
      case NotificationType.overdueAlert:
        return AppColors.error50;
      case NotificationType.requestUpdate:
        return AppColors.info50;
      case NotificationType.availabilityAlert:
        return AppColors.success50;
    }
  }

  Color _iconColor(NotificationType type) {
    switch (type) {
      case NotificationType.dueReminder:
        return AppColors.warning600;
      case NotificationType.overdueAlert:
        return AppColors.error600;
      case NotificationType.requestUpdate:
        return AppColors.info500;
      case NotificationType.availabilityAlert:
        return AppColors.success600;
    }
  }
}
