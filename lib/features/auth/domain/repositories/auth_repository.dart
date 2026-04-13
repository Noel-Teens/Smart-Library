import 'package:library_management_app/features/auth/domain/entities/user_entity.dart';

/// Abstract contract for authentication operations.
abstract class AuthRepository {
  /// Signs in with Google OAuth. Default role is student.
  Future<UserEntity> signInWithGoogle();

  /// Signs in with email and password.
  Future<UserEntity> signInWithPassword({
    required String email,
    required String password,
  });

  /// Signs up a new user with email and password. Default role is student.
  Future<UserEntity> signUp({
    required String email,
    required String password,
    required String name,
  });

  /// Signs the current user out.
  Future<void> signOut();

  /// Returns the currently authenticated user, or `null` if not signed in.
  Future<UserEntity?> getCurrentUser();
}
