import 'package:library_management_app/features/auth/data/models/user_model.dart';

/// Contract for the auth remote data source.
abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithGoogle();
  Future<UserModel> signInWithPassword({
    required String email,
    required String password,
  });
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
  });
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
}
