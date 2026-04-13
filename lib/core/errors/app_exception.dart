/// Base exception class for the Smart Library application.
sealed class AppException implements Exception {
  const AppException(this.message, [this.stackTrace]);

  final String message;
  final StackTrace? stackTrace;

  @override
  String toString() => '$runtimeType: $message';
}

/// Thrown when a network request fails (timeout, no connectivity, etc.).
class NetworkException extends AppException {
  const NetworkException([super.message = 'A network error occurred.', super.stackTrace]);
}

/// Thrown by the auth layer (invalid credentials, expired session, etc.).
class AuthException extends AppException {
  const AuthException([super.message = 'An authentication error occurred.', super.stackTrace]);
}

/// Thrown when the authenticated user does not have sufficient permissions.
class PermissionException extends AppException {
  const PermissionException([super.message = 'You do not have permission to perform this action.', super.stackTrace]);
}

/// Thrown when a database or data-layer operation fails.
class DatabaseException extends AppException {
  const DatabaseException([super.message = 'A database error occurred.', super.stackTrace]);
}

/// Thrown when a requested resource is not found.
class NotFoundException extends AppException {
  const NotFoundException([super.message = 'The requested resource was not found.', super.stackTrace]);
}

/// Thrown when a business validation rule is violated.
class ValidationException extends AppException {
  const ValidationException([super.message = 'A validation error occurred.', super.stackTrace]);
}
