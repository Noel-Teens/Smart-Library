import 'package:library_management_app/features/auth/data/datasources/supabase_auth_datasource.dart';
import 'package:library_management_app/features/auth/domain/entities/user_entity.dart';
import 'package:library_management_app/features/auth/domain/repositories/auth_repository.dart';

/// Concrete implementation of [AuthRepository].
///
/// Delegates to [SupabaseAuthDataSource] for real Supabase operations.
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._dataSource);

  final SupabaseAuthDataSource _dataSource;

  @override
  Future<UserEntity> signInWithGoogle() {
    return _dataSource.signInWithGoogle();
  }

  @override
  Future<UserEntity> signInWithPassword({
    required String email,
    required String password,
  }) {
    return _dataSource.signInWithPassword(
        email: email, password: password);
  }

  @override
  Future<UserEntity> signUp({
    required String email,
    required String password,
    required String name,
  }) {
    return _dataSource.signUp(
        email: email, password: password, name: name);
  }

  @override
  Future<void> signOut() {
    return _dataSource.signOut();
  }

  @override
  Future<UserEntity?> getCurrentUser() {
    return _dataSource.getCurrentUser();
  }
}
