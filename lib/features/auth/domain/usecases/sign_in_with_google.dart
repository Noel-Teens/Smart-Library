import 'package:library_management_app/features/auth/domain/entities/user_entity.dart';
import 'package:library_management_app/features/auth/domain/repositories/auth_repository.dart';

/// Use case: Sign in with Google OAuth.
class SignInWithGoogle {
  const SignInWithGoogle(this._repository);

  final AuthRepository _repository;

  Future<UserEntity> call() {
    return _repository.signInWithGoogle();
  }
}
