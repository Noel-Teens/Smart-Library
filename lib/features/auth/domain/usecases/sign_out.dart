import 'package:library_management_app/features/auth/domain/repositories/auth_repository.dart';

/// Use case: Sign the current user out.
class SignOut {
  const SignOut(this._repository);

  final AuthRepository _repository;

  Future<void> call() {
    return _repository.signOut();
  }
}
