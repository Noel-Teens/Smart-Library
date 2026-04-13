import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:library_management_app/features/notifications/data/datasources/notifications_remote_datasource.dart';
import 'package:library_management_app/features/notifications/data/datasources/supabase_notifications_datasource.dart';
import 'package:library_management_app/features/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:library_management_app/features/notifications/domain/entities/notification_entity.dart';
import 'package:library_management_app/features/notifications/domain/repositories/notifications_repository.dart';

final _notificationsDsProvider =
    Provider<NotificationsRemoteDataSource>((ref) {
  return SupabaseNotificationsDataSource();
});

final notificationsRepositoryProvider =
    Provider<NotificationsRepository>((ref) {
  return NotificationsRepositoryImpl(ref.watch(_notificationsDsProvider));
});

// ──────────────────────────────────────────────
// Notifications Notifier
// ──────────────────────────────────────────────
final notificationsNotifierProvider = AsyncNotifierProvider<
    NotificationsNotifier, List<NotificationEntity>>(
  NotificationsNotifier.new,
);

class NotificationsNotifier
    extends AsyncNotifier<List<NotificationEntity>> {
  @override
  Future<List<NotificationEntity>> build() async {
    final repo = ref.read(notificationsRepositoryProvider);
    final user = ref.watch(authNotifierProvider).valueOrNull;
    if (user == null) return [];
    return repo.getUserNotifications(user.id);
  }

  Future<void> markAsRead(String notificationId) async {
    final repo = ref.read(notificationsRepositoryProvider);
    await repo.markAsRead(notificationId);
    ref.invalidateSelf();
  }

  Future<void> markAllAsRead() async {
    final repo = ref.read(notificationsRepositoryProvider);
    final user = ref.read(authNotifierProvider).valueOrNull;
    if (user == null) return;
    await repo.markAllAsRead(user.id);
    ref.invalidateSelf();
  }
}

// ── Selectors ──
final unreadNotificationCountProvider = Provider<int>((ref) {
  final notifs =
      ref.watch(notificationsNotifierProvider).valueOrNull ?? [];
  return notifs.where((n) => !n.isRead).length;
});
