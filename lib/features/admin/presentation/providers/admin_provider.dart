import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_management_app/features/admin/data/datasources/admin_remote_datasource.dart';
import 'package:library_management_app/features/admin/data/datasources/supabase_admin_datasource.dart';
import 'package:library_management_app/features/admin/data/repositories/admin_repository_impl.dart';
import 'package:library_management_app/features/admin/domain/entities/audit_log_entity.dart';
import 'package:library_management_app/features/admin/domain/repositories/admin_repository.dart';
import 'package:library_management_app/features/auth/domain/entities/user_entity.dart';

final _adminDsProvider = Provider<AdminRemoteDataSource>((ref) {
  return SupabaseAdminDataSource();
});

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepositoryImpl(ref.watch(_adminDsProvider));
});

// ──────────────────────────────────────────────
// Users Notifier
// ──────────────────────────────────────────────
final usersNotifierProvider =
    AsyncNotifierProvider<UsersNotifier, List<UserEntity>>(
  UsersNotifier.new,
);

class UsersNotifier extends AsyncNotifier<List<UserEntity>> {
  @override
  Future<List<UserEntity>> build() async {
    final repo = ref.read(adminRepositoryProvider);
    return repo.getAllUsers();
  }

  Future<void> updateRole(String userId, UserRole role) async {
    final repo = ref.read(adminRepositoryProvider);
    await repo.updateUserRole(userId, role);
    ref.invalidateSelf();
  }

  Future<void> toggleFreeze(String userId, bool freeze) async {
    final repo = ref.read(adminRepositoryProvider);
    await repo.toggleUserFreeze(userId, freeze);
    ref.invalidateSelf();
  }

  Future<void> createUser({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) async {
    final repo = ref.read(adminRepositoryProvider);
    await repo.createUser(
      email: email,
      password: password,
      name: name,
      role: role,
    );
    ref.invalidateSelf();
  }
}

// ──────────────────────────────────────────────
// Audit Logs
// ──────────────────────────────────────────────
final auditLogsProvider = FutureProvider<List<AuditLogEntity>>((ref) async {
  final repo = ref.watch(adminRepositoryProvider);
  return repo.getAuditLogs();
});

// ── Selectors ──
final userCountByRoleProvider =
    Provider<Map<UserRole, int>>((ref) {
  final users = ref.watch(usersNotifierProvider).valueOrNull ?? [];
  final counts = <UserRole, int>{};
  for (final role in UserRole.values) {
    counts[role] = users.where((u) => u.role == role).length;
  }
  return counts;
});
