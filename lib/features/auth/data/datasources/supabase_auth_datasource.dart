import 'package:google_sign_in/google_sign_in.dart';
import 'package:library_management_app/core/config/supabase_config.dart';
import 'package:library_management_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:library_management_app/features/auth/data/models/user_model.dart';
import 'package:library_management_app/features/auth/domain/entities/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase implementation of [AuthRemoteDataSource].
class SupabaseAuthDataSource implements AuthRemoteDataSource {
  final _client = SupabaseConfig.client;

  @override
  Future<UserModel> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn(
      serverClientId: SupabaseConfig.googleWebClientId,
    );

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw const AuthException('Google sign-in was cancelled');
    }

    final googleAuth = await googleUser.authentication;
    final idToken = googleAuth.idToken;
    final accessToken = googleAuth.accessToken;

    if (idToken == null) {
      throw const AuthException('Unable to authenticate with Google. Please try again.');
    }

    final response = await _client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

    if (response.user == null) {
      throw const AuthException('Sign-in failed. Please try again.');
    }

    return _fetchOrCreateProfile(response.user!);
  }

  /// Sign in with email and password.
  @override
  Future<UserModel> signInWithPassword({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw const AuthException('Invalid email or password.');
    }

    return _fetchOrCreateProfile(response.user!);
  }

  /// Sign up with email and password.
  @override
  Future<UserModel> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': name},
    );

    if (response.user == null) {
      throw const AuthException('Registration failed. Please try again.');
    }

    return _fetchOrCreateProfile(response.user!);
  }

  @override
  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _client.auth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final authUser = _client.auth.currentUser;
    if (authUser == null) return null;

    try {
      return await _fetchOrCreateProfile(authUser);
    } catch (_) {
      return null;
    }
  }

  /// Fetches the user profile from the `profiles` table.
  /// If it doesn't exist yet (trigger hasn't fired), waits briefly and retries.
  Future<UserModel> _fetchOrCreateProfile(User authUser) async {
    Map<String, dynamic>? data;

    // The trigger may not have fired yet, retry up to 3 times
    for (var i = 0; i < 3; i++) {
      try {
        data = await _client
            .from('profiles')
            .select()
            .eq('id', authUser.id)
            .single();
        break;
      } catch (_) {
        if (i < 2) {
          await Future.delayed(const Duration(milliseconds: 500));
        }
      }
    }

    if (data == null) {
      throw const AuthException('Unable to load your profile. Please try signing in again.');
    }

    final isFrozen = data['is_frozen'] as bool? ?? false;
    if (isFrozen) {
      await _client.auth.signOut();
      throw const AuthException(
        'This account has been suspended. Contact your administrator.',
        statusCode: '403',
      );
    }

    return UserModel(
      id: data['id'] as String,
      email: data['email'] as String,
      name: data['name'] as String? ?? '',
      role: _parseRole(data['role'] as String?),
      avatarUrl: data['avatar_url'] as String?,
      houseId: data['house_id'] as String?,
      points: (data['points'] as num?)?.toInt() ?? 0,
      isFrozen: isFrozen,
      createdAt: DateTime.parse(data['created_at'] as String),
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
