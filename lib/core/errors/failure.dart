import 'package:equatable/equatable.dart';

/// Represents a handled error state.
///
/// Use [Failure] as the error side of a Result / Either type when
/// propagating errors through the domain layer without throwing.
class Failure extends Equatable {
  const Failure(this.message, [this.code]);

  /// Human-readable error description.
  final String message;

  /// Optional error code for programmatic handling.
  final String? code;

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => 'Failure($message${code != null ? ', code: $code' : ''})';
}

/// Failure originating from a network operation.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'A network error occurred.', super.code]);
}

/// Failure originating from the authentication layer.
class AuthFailure extends Failure {
  const AuthFailure([super.message = 'An authentication error occurred.', super.code]);
}

/// Failure originating from a database operation.
class DatabaseFailure extends Failure {
  const DatabaseFailure([super.message = 'A database error occurred.', super.code]);
}

/// Failure when the user does not have the required role or permission.
class PermissionFailure extends Failure {
  const PermissionFailure([super.message = 'Insufficient permissions.', super.code]);
}
