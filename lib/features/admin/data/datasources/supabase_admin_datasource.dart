import 'package:library_management_app/core/config/supabase_config.dart';
import 'package:library_management_app/features/admin/data/datasources/admin_remote_datasource.dart';
import 'package:library_management_app/features/admin/domain/entities/audit_log_entity.dart';
import 'package:library_management_app/features/auth/domain/entities/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase implementation of [AdminRemoteDataSource].
class SupabaseAdminDataSource implements AdminRemoteDataSource {
  final _client = SupabaseConfig.client;

  @override
  Future<List<UserEntity>> getAllUsers() async {
    final data = await _client
        .from('profiles')
        .select()
        .order('created_at', ascending: false);
    return data.map<UserEntity>((json) => _userFromJson(json)).toList();
  }

  @override
  Future<void> updateUserRole(String userId, UserRole role) async {
    await _client
        .from('profiles')
        .update({'role': role.name}).eq('id', userId);
  }

  @override
  Future<void> toggleUserFreeze(String userId, bool freeze) async {
    await _client
        .from('profiles')
        .update({'is_frozen': freeze}).eq('id', userId);
  }

  @override
  Future<List<AuditLogEntity>> getAuditLogs() async {
    final data = await _client
        .from('audit_logs')
        .select()
        .order('timestamp', ascending: false);
    return data
        .map<AuditLogEntity>((json) => _auditFromJson(json))
        .toList();
  }

  @override
  Future<void> createUser({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) async {
    // Use a separate SupabaseClient so the admin's session stays intact.
    final tempClient = SupabaseClient(
      SupabaseConfig.url,
      SupabaseConfig.anonKey,
    );

    try {
      final response = await tempClient.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': name},
      );

      if (response.user == null) {
        throw const AuthException('Failed to create user account.');
      }

      final newUserId = response.user!.id;

      // Wait briefly for the handle_new_user trigger to fire.
      await Future.delayed(const Duration(milliseconds: 800));

      // Update the role from 'student' (default) to the requested role
      // using the admin's authenticated client so RLS allows it.
      if (role != UserRole.student) {
        await _client
            .from('profiles')
            .update({'role': role.name}).eq('id', newUserId);
      }
    } finally {
      // Sign out the temp client to clean up its session.
      await tempClient.auth.signOut();
      tempClient.dispose();
    }
  }

  UserEntity _userFromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'] as String,
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      role: _parseRole(json['role'] as String?),
      avatarUrl: json['avatar_url'] as String?,
      houseId: json['house_id'] as String?,
      points: (json['points'] as num?)?.toInt() ?? 0,
      isFrozen: json['is_frozen'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  AuditLogEntity _auditFromJson(Map<String, dynamic> json) {
    return AuditLogEntity(
      id: json['id'] as String,
      action: json['action'] as String,
      performedBy: json['performed_by'] as String,
      performedByName: json['performed_by_name'] as String? ?? '',
      targetUserId: json['target_user_id'] as String?,
      targetUserName: json['target_user_name'] as String?,
      targetBookId: json['target_book_id'] as String?,
      targetBookTitle: json['target_book_title'] as String?,
      timestamp: DateTime.parse(json['timestamp'] as String),
      details: json['details'] as String?,
    );
  }

  UserRole _parseRole(String? role) {
    switch (role) {
      case 'librarian':
        return UserRole.librarian;
      case 'admin':
        return UserRole.admin;
      case 'staff':
        return UserRole.staff;
      case 'student':
      default:
        return UserRole.student;
    }
  }
}
