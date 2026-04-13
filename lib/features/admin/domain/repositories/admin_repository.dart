import 'package:library_management_app/features/admin/domain/entities/audit_log_entity.dart';
import 'package:library_management_app/features/auth/domain/entities/user_entity.dart';

/// Abstract admin repository contract.
abstract class AdminRepository {
  Future<List<UserEntity>> getAllUsers();
  Future<void> updateUserRole(String userId, UserRole role);
  Future<void> toggleUserFreeze(String userId, bool freeze);
  Future<List<AuditLogEntity>> getAuditLogs();
  Future<void> createUser({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  });
}
