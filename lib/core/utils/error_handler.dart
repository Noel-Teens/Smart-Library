import 'package:flutter/material.dart';
import 'package:library_management_app/core/theme/app_colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Centralized error handling utility.
///
/// Converts raw exceptions (Supabase, Auth, Network, etc.)
/// into clean, user-facing messages.
class AppError {
  AppError._();

  /// Converts any error into a human-readable message.
  static String friendlyMessage(Object error) {
    // ── Supabase Auth errors ──
    if (error is AuthException) {
      return _authMessage(error);
    }

    // ── Supabase Postgres errors ──
    if (error is PostgrestException) {
      return _postgresMessage(error);
    }

    // ── Network / general errors ──
    final msg = error.toString().toLowerCase();
    if (msg.contains('socketexception') ||
        msg.contains('clientexception') ||
        msg.contains('handshakeexception') ||
        msg.contains('no internet') ||
        msg.contains('network')) {
      return 'No internet connection. Please check your network and try again.';
    }
    if (msg.contains('timeout')) {
      return 'Request timed out. Please try again.';
    }
    if (msg.contains('google sign-in was cancelled') ||
        msg.contains('cancelled')) {
      return 'Sign-in was cancelled.';
    }
    if (msg.contains('failed to get google id token')) {
      return 'Unable to authenticate with Google. Please try again.';
    }
    if (msg.contains('failed to load user profile')) {
      return 'Unable to load your profile. Please sign in again.';
    }

    // ── Fallback: strip "Exception:" prefix ──
    String fallback = error.toString();
    if (fallback.startsWith('Exception: ')) {
      fallback = fallback.substring(11);
    }
    // Don't show overly technical messages
    if (fallback.length > 120) {
      return 'Something went wrong. Please try again.';
    }
    return fallback;
  }

  /// Maps Supabase Auth error codes to user-friendly messages.
  static String _authMessage(AuthException error) {
    final code = error.code ?? '';
    switch (code) {
      case 'invalid_credentials':
        return 'Invalid email or password. Please try again.';
      case 'email_not_confirmed':
        return 'Please verify your email address before signing in.';
      case 'user_not_found':
        return 'No account found with this email address.';
      case 'user_already_registered':
      case 'email_exists':
        return 'An account with this email already exists. Try signing in instead.';
      case 'weak_password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'email_address_invalid':
        return 'Please enter a valid email address.';
      case 'over_email_send_rate_limit':
        return 'Too many attempts. Please wait a few minutes and try again.';
      case 'over_request_rate_limit':
        return 'Too many requests. Please slow down and try again.';
      case 'signup_disabled':
        return 'Registration is currently disabled. Contact your administrator.';
      case 'validation_failed':
        return 'Invalid input. Please check your details and try again.';
      case 'bad_json':
      case 'bad_jwt':
        return 'Session expired. Please sign in again.';
      case 'not_admin':
        return 'You do not have permission to perform this action.';
      case 'user_banned':
        return 'This account has been suspended. Contact your administrator.';
      default:
        // Use the human-readable message from Supabase if available
        if (error.message.isNotEmpty && error.message.length < 120) {
          return error.message;
        }
        return 'Authentication failed. Please try again.';
    }
  }

  /// Maps Supabase Postgres error codes to user-friendly messages.
  static String _postgresMessage(PostgrestException error) {
    final code = error.code ?? '';
    switch (code) {
      case '23505': // unique_violation
        return 'This record already exists.';
      case '23503': // foreign_key_violation
        return 'Cannot complete this action — related data is missing.';
      case '42501': // insufficient_privilege (RLS)
        return 'You do not have permission to perform this action.';
      case 'PGRST301': // JWT expired
        return 'Your session has expired. Please sign in again.';
      case '42P01': // relation does not exist
        return 'A required database table is missing. Contact support.';
      default:
        if (error.message.isNotEmpty && error.message.length < 120) {
          return error.message;
        }
        return 'A database error occurred. Please try again.';
    }
  }
}

/// Shows a styled error SnackBar with a friendly message.
void showErrorSnackBar(BuildContext context, Object error) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              AppError.friendlyMessage(error),
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.error600,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 4),
    ),
  );
}

/// Shows a styled success SnackBar.
void showSuccessSnackBar(BuildContext context, String message) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.success600,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    ),
  );
}
