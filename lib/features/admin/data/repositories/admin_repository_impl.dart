import 'package:library_management_app/features/admin/data/datasources/admin_remote_datasource.dart';
import 'package:library_management_app/features/admin/domain/entities/audit_log_entity.dart';
import 'package:library_management_app/features/admin/domain/repositories/admin_repository.dart';
import 'package:library_management_app/features/auth/domain/entities/user_entity.dart';

class AdminRepositoryImpl implements AdminRepository {
  const AdminRepositoryImpl(this._ds);
  final AdminRemoteDataSource _ds;

  @override
  Future<List<UserEntity>> getAllUsers() => _ds.getAllUsers();
  @override
  Future<void> updateUserRole(String userId, UserRole role) =>
      _ds.updateUserRole(userId, role);
  @override
  Future<void> toggleUserFreeze(String userId, bool freeze) =>
      _ds.toggleUserFreeze(userId, freeze);
  @override
  Future<List<AuditLogEntity>> getAuditLogs() => _ds.getAuditLogs();
  @override
  Future<void> createUser({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) =>
      _ds.createUser(email: email, password: password, name: name, role: role);
}
